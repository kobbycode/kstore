import {before, after, test} from 'node:test';
import {readFile} from 'node:fs/promises';
import {initializeTestEnvironment, assertFails, assertSucceeds} from '@firebase/rules-unit-testing';
import {ref, uploadBytes, getBytes, deleteObject} from 'firebase/storage';

let env;
before(async () => {
  env = await initializeTestEnvironment({projectId: 'demo-kstore', storage: {
    rules: await readFile(new URL('../storage.rules', import.meta.url), 'utf8')
  }});
});
after(async () => env?.cleanup());
const photo = new Uint8Array([137, 80, 78, 71]);
const verified = uid => env.authenticatedContext(uid, {email_verified: true}).storage();

test('verified owners upload public product photos; other users cannot overwrite or delete', async () => {
  const path = 'product-images/alice/ownership.png';
  await assertSucceeds(uploadBytes(ref(verified('alice'), path), photo, {contentType: 'image/png'}));
  await assertSucceeds(getBytes(ref(env.unauthenticatedContext().storage(), path)));
  await assertFails(uploadBytes(ref(verified('bob'), path), photo, {contentType: 'image/png'}));
  await assertFails(deleteObject(ref(verified('bob'), path)));
  await assertSucceeds(deleteObject(ref(verified('alice'), path)));
});

test('anonymous and unverified users cannot upload', async () => {
  await assertFails(uploadBytes(ref(env.unauthenticatedContext().storage(), 'product-images/alice/guest.png'), photo, {contentType: 'image/png'}));
  await assertFails(uploadBytes(ref(env.authenticatedContext('alice', {email_verified: false}).storage(), 'product-images/alice/unverified.png'), photo, {contentType: 'image/png'}));
});

test('unsupported content types, oversized files and private paths are denied', async () => {
  const storage = verified('alice');
  await assertFails(uploadBytes(ref(storage, 'product-images/alice/code.html'), photo, {contentType: 'text/html'}));
  await assertFails(uploadBytes(ref(storage, 'product-images/alice/big.png'), new Uint8Array(5 * 1024 * 1024), {contentType: 'image/png'}));
  await assertFails(uploadBytes(ref(storage, 'identity/alice/document.png'), photo, {contentType: 'image/png'}));
  await assertFails(getBytes(ref(storage, 'identity/alice/document.png')));
});
