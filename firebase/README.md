# Firebase connection guide

Status: integration prepared; no Firebase project is configured or deployed yet. Existing hosted Kstore remains a browser-local demo while dist/firebase-config.js is null.

## Required project inputs

Provide the Firebase project ID and public web-app configuration: apiKey, authDomain, projectId, storageBucket, messagingSenderId and appId. Never paste a service-account private key. If there is no project yet, create one in Firebase Console first. Do not upgrade billing automatically: review Cloud Functions/Storage requirements in your own Firebase account.

1. Register a Web app in Firebase Console. Copy its public config into dist/firebase-config.js.
2. Enable Authentication → Email/Password. Add kstore-ghana-shop.vivid-morel-1647.chatgpt.site and localhost to authorized domains. Configure verification and password-reset templates.
3. Create Firestore and Storage in the intended project. Suggested Functions region: europe-west1; decide the database location before creation. Keep KSTORE_FIREBASE_REGION aligned with the function deployment region.
4. Install Firebase CLI and authenticate locally with firebase login. From this firebase/ directory install function dependencies (npm --prefix functions install), then deploy only the reviewed services with firebase deploy --project YOUR_PROJECT_ID --only firestore:rules,firestore:indexes,storage,functions:kstore. Existing project rules may protect other applications: merge these rules before deploying into a shared project.
5. After rules/functions are deployed, enable the public web config and publish the static Site update through the existing Sites project. Sites owner-private access remains in front of Firebase sign-in; its audience is unchanged.

## Data and permissions

- profiles/{uid}: private name and newsletter preferences. No role or approval fields accepted.
- accounts/{uid}: private cart, saved items, addresses, pickup choices and preferences.
- stores/{uid}: private business application/profile, modified through authenticated callables. New stores are pending approval.
- publicStores/{uid}: public approved store presentation only.
- listings/{id}: active listings readable by shoppers; drafts readable only by their seller/operator. Callable writes enforce ownership, email verification and approval before publishing.
- orders/{id}: buyer/operator reads; server-only writes. Seller projections at sellerOrders/{uid}/orders/{id} contain only that seller’s order lines.
- product-images/{uid}/{file}: public product photos; verified owners upload JPG/PNG/WebP under 5 MB. No sensitive documents are stored there.
- reviews/{id}: public, server-created only after a delivered purchase.

All identity comes from Firebase Auth UID, not a form email. Existing local demo profiles, sellers and orders are not automatically imported into Firebase. Firebase mode does not fall back to local demo identity if a cloud request fails.

## Trusted operator setup

From firebase/functions, run manage.mjs with Google Application Default Credentials belonging to the intended project operator. Do not distribute these credentials to shoppers.

- node manage.mjs approve-seller PROJECT_ID FIREBASE_UID
- node manage.mjs grant-admin PROJECT_ID FIREBASE_UID
- node manage.mjs set-commerce PROJECT_ID --enable-cod DOOR_FEE_PESEWAS PICKUP_FEE_PESEWAS REGION_1 REGION_2

The last command intentionally requires explicit fees and regions. Checkout starts disabled. Only pay-on-delivery is supported; no online payment is marked paid. Create approved pickupStations documents before offering pickup checkout. Real tax, shipping rules, payment gateways, carrier confirmation, refunds and payouts require their own integrations. The backend allows seller transitions only Processing → Packed → Shipped; it does not let sellers self-certify delivery or payment.

## Verification

- Run node --test tests/domain.test.mjs: cart aggregation, amount validation, stock limits and server-price arithmetic.
- Firestore rules tests: install this directory’s dev dependencies and Firebase CLI; install the Java version required by the current Firestore emulator. Run npm run test:rules. The test suite uses demo-kstore and does not contact production.
- Local emulators: firebase emulators:start --project demo-kstore. Set public config for that demo project and KSTORE_FIREBASE_EMULATORS=true only on localhost.
- Validate sign-up, verification, sign-in, reset, sign-out, a second user’s denial, two-device data, pending seller approval, competing final-stock purchases, retrying the same checkout key, and order cancellation restoring stock before enabling real orders.

Current environment: domain tests pass; scripts pass syntax checks. Emulator access tests and live Firebase calls have not run because no project configuration has been supplied and Java is unavailable. Do not treat syntax tests as proof of deployed authorization.
