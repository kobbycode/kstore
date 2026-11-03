import {before, after, beforeEach, test} from 'node:test';
import assert from 'node:assert/strict';
import {createRequire} from 'node:module';
import {initializeApp, deleteApp} from 'firebase/app';
import {getAuth, connectAuthEmulator, createUserWithEmailAndPassword} from 'firebase/auth';
import {getFunctions, connectFunctionsEmulator, httpsCallable} from 'firebase/functions';
import {getFirestore, connectFirestoreEmulator, doc, setDoc, getDoc, serverTimestamp} from 'firebase/firestore';

// Never seed, approve a seller or create orders against a real project.
const projectId = 'demo-kstore';
for (const key of ['FIRESTORE_EMULATOR_HOST', 'FIREBASE_AUTH_EMULATOR_HOST']) {
  if (!process.env[key]?.match(/^(127\.0\.0\.1|localhost):\d+$/)) throw Error('Local emulator required: ' + key);
}
const require = createRequire(new URL('../functions/package.json', import.meta.url));
const adminApp = require('firebase-admin/app');
const adminAuth = require('firebase-admin/auth');
const adminDb = require('firebase-admin/firestore');
let server, db, seller, buyer, stranger, unverified, guest;
const apps = [];
async function user(name, verified = true) {
  const app = initializeApp({projectId, apiKey: 'demo-key', authDomain: 'localhost'}, name);
  apps.push(app);
  const auth = getAuth(app);
  connectAuthEmulator(auth, 'http://' + process.env.FIREBASE_AUTH_EMULATOR_HOST, {disableWarnings: true});
  const {user} = await createUserWithEmailAndPassword(auth, name + '@example.test', 'Emulator-only-password1!');
  if (verified) {
    await adminAuth.getAuth(server).updateUser(user.uid, {emailVerified: true});
    await user.getIdToken(true);
  }
  return client(app, user.uid);
}
function client(app, uid) {
  const functions = getFunctions(app, 'europe-west1');
  connectFunctionsEmulator(functions, '127.0.0.1', 5001);
  const firestore = getFirestore(app);
  const [host, port] = process.env.FIRESTORE_EMULATOR_HOST.split(':');
  connectFirestoreEmulator(firestore, host, Number(port));
  return {uid, firestore, call: async (name, data = {}) => (await httpsCallable(functions, name)(data)).data};
}
const fails = (operation, code) => assert.rejects(operation, e => e.code === 'functions/' + code);
const storeInput = {shopName: 'Emulator Shop', ownerName: 'Test Seller', phone: '0240000000', address: 'Test Street 1', region: 'Greater Accra', city: 'Accra', step: 3};
const listingInput = {id: 'test-product', name: 'Emulator test product', sku: 'TEST-001', description: 'A synthetic product used only in emulator tests.', category: 'Phones', price: 100, images: ['https://example.test/product.png'], variants: [{name: 'Black', stock: 5}], status: 'draft'};
const cart = {items: [{id: 'test-product', variant: 'Black', qty: 2}], delivery: 'door', addressId: 'home'};
const checkout = async (key = 'test-checkout-key-0001', actor = buyer, input = cart) => {
  const quote = await actor.call('quoteOrder', input);
  return actor.call('createOrder', {...input, payment: 'Pay on delivery', quoteVersion: quote.version, idempotencyKey: key});
};
async function catalog() {
  await seller.call('saveStore', storeInput);
  // Approval and commerce configuration exist only inside demo-kstore emulator.
  await db.doc('stores/' + seller.uid).update({verificationStatus: 'approved'});
  await seller.call('saveListing', {...listingInput, status: 'active'});
  await db.doc('commerce/settings').set({checkoutEnabled: true, regions: ['Greater Accra'], doorFeeCents: 1500, pickupFeeCents: 500});
  await setDoc(doc(buyer.firestore, 'accounts', buyer.uid), {cart: [], wishlist: [], followed: [], pickups: [], addresses: [{id: 'home', name: 'Test Buyer', address: 'Test Road 2', city: 'Accra', region: 'Greater Accra'}], delivery: 'door', addressId: 'home', station: '', payment: 'Pay on delivery', updatedAt: serverTimestamp()});
}
before(async () => {
  server = adminApp.initializeApp({projectId}, 'integration-server');
  db = adminDb.getFirestore(server);
  seller = await user('seller'); buyer = await user('buyer'); stranger = await user('stranger'); unverified = await user('unverified', false);
  const guestApp = initializeApp({projectId, apiKey: 'demo-key'}, 'guest'); apps.push(guestApp); guest = client(guestApp);
});
beforeEach(async () => {
  const response = await fetch(`http://${process.env.FIRESTORE_EMULATOR_HOST}/emulator/v1/projects/${projectId}/databases/(default)/documents`, {method: 'DELETE'});
  assert.equal(response.ok, true);
});
after(async () => {await Promise.all(apps.map(deleteApp)); if (server) await adminApp.deleteApp(server);});

test('all callables reject signed-out and unverified users', async () => {
  for (const name of ['saveStore', 'saveListing', 'quoteOrder', 'createOrder', 'updateFulfillment', 'cancelOrder', 'requestReturn', 'publishReview']) {
    await fails(guest.call(name), 'unauthenticated');
    await fails(unverified.call(name), 'failed-precondition');
  }
});
test('seller onboarding cannot approve itself; publication, SKU and ownership checks hold', async () => {
  await seller.call('saveStore', {...storeInput, step: 2});
  assert.equal((await db.doc('stores/' + seller.uid).get()).data().status, 'draft');
  await seller.call('saveStore', {...storeInput, verificationStatus: 'approved'});
  const completed = (await db.doc('stores/' + seller.uid).get()).data();
  assert.equal(completed.verificationStatus, 'pending');
  assert.equal(completed.application, undefined);
  await seller.call('saveListing', listingInput);
  await fails(seller.call('saveListing', {...listingInput, version: 1, status: 'active'}), 'failed-precondition');
  await fails(seller.call('saveListing', {...listingInput, id: 'duplicate-sku'}), 'already-exists');
  await stranger.call('saveStore', storeInput);
  await fails(stranger.call('saveListing', {...listingInput, version: 1}), 'permission-denied');
});
test('account writes are owned; quotes use server prices and checkout defaults to disabled', async () => {
  await catalog();
  await assert.rejects(getDoc(doc(stranger.firestore, 'accounts', buyer.uid)), e => e.code === 'permission-denied');
  const q = await buyer.call('quoteOrder', {...cart, total: 0, price: 1});
  assert.equal(q.total, 215); assert.equal(q.subtotal, 200);
  await db.doc('commerce/settings').delete();
  await fails(buyer.call('quoteOrder', cart), 'failed-precondition');
});
test('orders are idempotent, reserve stock once and expose only the seller projection', async () => {
  await catalog();
  const first = await checkout(); const second = await checkout();
  assert.equal(first.id, second.id);
  assert.equal((await db.doc('listings/test-product').get()).data().variants[0].stock, 3);
  assert.equal((await db.collection('orders').get()).size, 1);
  assert.equal((await getDoc(doc(buyer.firestore, 'orders', first.id))).data().total, 215);
  await assert.rejects(getDoc(doc(seller.firestore, 'orders', first.id)), e => e.code === 'permission-denied');
  assert.equal((await getDoc(doc(seller.firestore, 'sellerOrders', seller.uid, 'orders', first.id))).data().lines.length, 1);
});
test('stale quotes, unsupported payments and excess stock are rejected without an order', async () => {
  await catalog(); const q = await buyer.call('quoteOrder', cart);
  await fails(buyer.call('createOrder', {...cart, idempotencyKey: 'test-checkout-key-0001', quoteVersion: q.version, payment: 'Card'}), 'failed-precondition');
  await db.doc('listings/test-product').update({priceCents: 11000, price: 110});
  await fails(buyer.call('createOrder', {...cart, idempotencyKey: 'test-checkout-key-0001', quoteVersion: q.version, payment: 'Pay on delivery'}), 'failed-precondition');
  await fails(buyer.call('quoteOrder', {...cart, items: [{...cart.items[0], qty: 6}]}), 'invalid-argument');
  assert.equal((await db.collection('orders').get()).size, 0);
});
test('vouchers and pickup locations are checked against server configuration', async () => {
  await catalog();
  await db.doc('vouchers/SAVE10').set({active: true, percent: 10, expiresAt: adminDb.Timestamp.fromMillis(Date.now() + 60000)});
  assert.equal((await buyer.call('quoteOrder', {...cart, voucher: 'save10'})).total, 195);
  await db.doc('vouchers/SAVE10').update({expiresAt: adminDb.Timestamp.fromMillis(Date.now() - 60000)});
  await fails(buyer.call('quoteOrder', {...cart, voucher: 'SAVE10'}), 'invalid-argument');
  await db.doc('accounts/' + buyer.uid).update({pickups: [{id: 'station', name: 'Test Buyer', city: 'Fake City', region: 'Fake Region'}]});
  await db.doc('pickupStations/station').set({active: true, name: 'Test Station', city: 'Accra', region: 'Greater Accra', address: 'Station Street'});
  const input = {...cart, delivery: 'pickup', station: 'station'};
  assert.equal((await buyer.call('quoteOrder', input)).total, 205);
  await db.doc('pickupStations/station').update({active: false});
  await fails(buyer.call('quoteOrder', input), 'invalid-argument');
});
test('concurrent buyers cannot oversell the last stock', async () => {
  await catalog(); await db.doc('listings/test-product').update({variants: [{name: 'Black', stock: 2}]});
  const q = await buyer.call('quoteOrder', cart);
  const results = await Promise.allSettled(['concurrent-checkout-0001', 'concurrent-checkout-0002'].map(idempotencyKey => buyer.call('createOrder', {...cart, quoteVersion: q.version, payment: 'Pay on delivery', idempotencyKey})));
  assert.equal(results.filter(r => r.status === 'fulfilled').length, 1);
  assert.equal((await db.doc('listings/test-product').get()).data().variants[0].stock, 0);
});
test('cancellation restores stock once and invalidates stale seller inventory edits', async () => {
  await catalog(); const {id} = await checkout();
  await fails(stranger.call('cancelOrder', {id}), 'permission-denied');
  const prior = (await db.doc('listings/test-product').get()).data();
  await buyer.call('cancelOrder', {id}); await buyer.call('cancelOrder', {id});
  const current = (await db.doc('listings/test-product').get()).data();
  assert.equal(current.variants[0].stock, 5);
  assert.equal(current.version, prior.version + 1);
  await fails(seller.call('saveListing', {...listingInput, version: prior.version}), 'failed-precondition');
});
test('fulfillment enforces seller ownership, transition order and shipped cancellation lock', async () => {
  await catalog(); const {id} = await checkout();
  await fails(buyer.call('updateFulfillment', {id, status: 'Packed'}), 'permission-denied');
  await fails(seller.call('updateFulfillment', {id, status: 'Shipped'}), 'failed-precondition');
  await seller.call('updateFulfillment', {id, status: 'Packed'});
  await seller.call('updateFulfillment', {id, status: 'Shipped'});
  await fails(buyer.call('cancelOrder', {id}), 'failed-precondition');
  await fails(seller.call('updateFulfillment', {id, status: 'Delivered'}), 'failed-precondition');
});
test('reviews require a delivered purchase; returns belong to the buyer', async () => {
  await catalog(); const {id} = await checkout();
  const review = {orderId: id, productId: 'test-product', rating: 5, title: 'Test review', text: 'Synthetic emulator review text.'};
  await fails(buyer.call('publishReview', review), 'permission-denied');
  await fails(buyer.call('requestReturn', {id, reason: 'Test return'}), 'failed-precondition');
  await db.doc('orders/' + id).update({status: 'Delivered'});
  await fails(stranger.call('publishReview', review), 'permission-denied');
  await buyer.call('publishReview', review);
  await fails(buyer.call('publishReview', review), 'already-exists');
  await fails(stranger.call('requestReturn', {id, reason: 'Test return'}), 'permission-denied');
  await buyer.call('requestReturn', {id, reason: 'Test return'});
  assert.equal((await db.doc('sellerOrders/' + seller.uid + '/orders/' + id).get()).data().status, 'Return requested');
});
