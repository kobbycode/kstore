# Kstore delivery pilot

The internal delivery workspace is `/#/courier`. A verified account can submit a rider application; submitting does not grant access to deliveries. A trusted operator must approve the actual rider after reviewing their suitability. No production rider was created or approved during implementation.

From `firebase/functions`, using the intended operator's Application Default Credentials:

```powershell
node manage.mjs approve-courier kstore-d3bb3 FIREBASE_UID
node manage.mjs deactivate-courier kstore-d3bb3 FIREBASE_UID
```

Never share operator credentials with riders. Deactivation removes job access and the rider from the assignment directory. Resolve outstanding jobs operationally before deactivation; reassignment is not implemented.

An approved seller packs a single-seller order, selects an approved rider and supplies the estimated arrival date. The rider records Accepted → Picked up → Out for delivery → Delivered. Pickup marks the order shipped. Delivery requires the recipient's confirmation name and acknowledgment of the exact order total collected. Cash remains **awaiting settlement**; the platform does not transfer funds or certify reconciliation. Buyers and sellers see delivery progress. Cancellation before pickup closes the job and restores inventory.

New door-delivery orders require a recipient phone. Older orders without structured contact details cannot be assigned. No historical customer details are fabricated or backfilled.

The current pilot has GH₵45 door delivery in configured Greater Accra (including the owner's Kasoa service area), pay on delivery, and no pickup option. The displayed 1–2 business-day target starts after confirmed dispatch and is not a guarantee. Reference: https://vendorhub.jumia.com.gh/jumia-delivery/ (Zone 1 to Zone 1). Actual arrival is chosen when assigning a rider.

Support links display 0543496314 and support@kstore.com as supplied by the owner. Publishing a mail link does not provision or verify the mailbox. No SMS, push notifications, courier booking, route optimization, proof-of-delivery photos, failed-delivery/reassignment flow, cash settlement, refunds or rider payouts are implemented. Rider statements are recorded; recipient identity is not independently verified.

Firestore server writes own courier applications, active rider directory, jobs, order tracking and audit events. Clients cannot approve riders or edit these records directly. Only an assigned, active, authenticated rider can read their jobs or advance delivery. Only the relevant approved seller can assign a packed order. Combined-seller dispatch is blocked in this pilot. No new composite index is required.

Validation: 28 local backend tests and eight browser checks passed against demo-kstore, with separate seller/rider browser contexts. These checks do not establish real rider availability, actual delivery or collected cash in production. Local Functions used Node 24; deployment targets Node 22.
