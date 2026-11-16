# Firebase connection guide

Status (3 November 2026): backend deployed to `kstore-d3bb3`. All eight callables are ACTIVE and reject signed-out calls; released Firestore/Storage rules match local source and indexes are deployed. Frontend activation now sets the public project configuration with emulators disabled. Email/password authentication is enabled and the existing Site domain is authorized. Twelve emulator browser checks and a read-only real-project guest check passed. Publication uses the existing owner-private Site. Checkout settings, seller approvals and operational services remain separate.

## Required project inputs

The existing project's public web configuration is recorded in `web-config.json`. Preserve its default Firestore database in `nam5` and existing Storage bucket. The following checklist is for integration; project creation and backend deployment are already complete. Never paste a service-account private key or change billing automatically.

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

`saveStore` distinguishes draft progress (`step` 1–3, `submit: false`) from final application submission (`submit: true` with `guidelines` and `terms` acknowledged as true or the HTML checkbox value `on`). Saving the business-details step must not submit the application. Existing submitted-store settings updates retain the store's status. Seller approval stays server-owned.

## Trusted operator setup

Internal courier pilot: see [COURIER_OPERATIONS.md](COURIER_OPERATIONS.md) for rider enrollment/approval, assignment, delivery recording and operating limitations. Courier delivery functions require verified identities; client code cannot approve riders. Cash collection is recorded as awaiting settlement.

From firebase/functions, run manage.mjs with Google Application Default Credentials belonging to the intended project operator. Do not distribute these credentials to shoppers.

- node manage.mjs approve-seller PROJECT_ID FIREBASE_UID
- node manage.mjs grant-admin PROJECT_ID FIREBASE_UID
- node manage.mjs set-commerce PROJECT_ID --enable-cod DOOR_FEE_PESEWAS PICKUP_FEE_PESEWAS REGION_1 REGION_2

The last command intentionally requires explicit fees and regions. Checkout starts disabled. Only pay-on-delivery is supported; no online payment is marked paid. Create approved pickupStations documents before offering pickup checkout. Real tax, shipping rules, payment gateways, carrier confirmation, refunds and payouts require their own integrations. The backend allows seller transitions only Processing → Packed → Shipped; it does not let sellers self-certify delivery or payment.

## Verification

- Run node --test tests/domain.test.mjs: cart aggregation, amount validation, stock limits and server-price arithmetic.
- Firestore rules tests: install this directory’s dev dependencies and Firebase CLI; install the Java version required by the current Firestore emulator. Run npm run test:rules. The test suite uses demo-kstore and does not contact production.
- Run `npm run test:integration` for Auth, Functions, Firestore and Storage authorization/transaction tests. This requires Java 21 and local Node/Firebase CLI. Tests enforce loopback emulator hosts, seed synthetic records only in `demo-kstore`, and use real emulator sign-in tokens over the callable HTTP protocol. Test files run sequentially to keep Firestore resets isolated.
- Local emulators: firebase emulators:start --project demo-kstore. Set public config for that demo project and KSTORE_FIREBASE_EMULATORS=true only on localhost.
- Validate sign-up, verification, sign-in, reset, sign-out, a second user’s denial, two-device data, pending seller approval, competing final-stock purchases, retrying the same checkout key, and order cancellation restoring stock before enabling real orders.

Current environment: Java 21 is installed. All 25 local backend checks passed. Tests found and fixed seller submission and cancellation inventory-version bugs; both fixes are deployed. Live signed-out callable probes and released-rules comparisons passed. Twelve browser checks passed against local emulators; a real-project read-only guest/catalog/auth-page check passed. Local Functions ran on Node 24 versus deployed Node 22. Actual email delivery and authenticated production transactions remain unverified. Frontend source now uses the real public configuration with emulators disabled.
