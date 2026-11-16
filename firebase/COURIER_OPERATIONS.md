# Kstore delivery pilot

The internal delivery workspace is `/#/courier`. A verified account can submit a rider application; submitting does not grant access to deliveries. A trusted operator must approve the actual rider after reviewing their suitability. No production rider was created or approved during implementation.

From `firebase/functions`, using the intended operator's Application Default Credentials:

```powershell
node manage.mjs approve-courier kstore-d3bb3 FIREBASE_UID
node manage.mjs deactivate-courier kstore-d3bb3 FIREBASE_UID
```

Never share operator credentials with riders. Deactivation removes job access and the rider from the assignment directory. Arrange a safe parcel handover before deactivating a rider who has a parcel.

## Problems, retries and rider reassignment

A rider who has accepted a job can report a delivery problem using a predefined reason. This pauses delivery without changing inventory, collecting cash or cancelling the order. Before pickup the parcel remains with the seller. After pickup the order remains Shipped and the rider keeps custody until the seller arranges a retry or receives the parcel back.

The approved seller can arrange a retry with the same active rider and an explicit new estimated arrival date. After-pickup retries resume from Picked up and still require Out for delivery before Delivered. A seller can confirm parcel return only after checking the physical parcel is back; this returns the order to Packed without restoring stock. The seller may then choose a different approved rider, provide a reason and a new arrival date. Direct reassignment after pickup is blocked until this return is recorded. A before-pickup assignment can be reassigned directly.

Reassignment checks the prior rider identity, atomically closes the old job and creates the replacement. The old job becomes a Reassigned notice with recipient/contact/product details removed. Old riders cannot advance the replacement delivery. Audit events retain the previous rider, reason and resolving seller. Do not use the return checkbox to simulate parcel custody.

An approved seller packs a single-seller order, selects an approved rider and supplies the estimated arrival date. The rider records Accepted → Picked up → Out for delivery → Delivered. Pickup marks the order shipped. Delivery requires the recipient's confirmation name and acknowledgment of the exact order total collected. Cash remains **awaiting settlement**; the platform does not transfer funds or certify reconciliation. Buyers and sellers see delivery progress. Cancellation before pickup closes the job and restores inventory.

New door-delivery orders require a recipient phone. Older orders without structured contact details cannot be assigned. No historical customer details are fabricated or backfilled.

The current pilot has GH₵45 door delivery in configured Greater Accra (including the owner's Kasoa service area), pay on delivery, and no pickup option. The displayed 1–2 business-day target starts after confirmed dispatch and is not a guarantee. Reference: https://vendorhub.jumia.com.gh/jumia-delivery/ (Zone 1 to Zone 1). Actual arrival is chosen when assigning a rider.

Support links display 0543496314 and support@kstore.com as supplied by the owner. Publishing a mail link does not provision or verify the mailbox. No SMS, push notifications, courier booking, route optimization, proof-of-delivery photos, cash settlement, refunds or rider payouts are implemented. Rider and seller statements are recorded; recipient identity and parcel return are not independently verified.

Firestore server writes own courier applications, active rider directory, jobs, order tracking and audit events. Clients cannot approve riders or edit these records directly. Only an assigned, active, authenticated rider can read their jobs or advance delivery. Only the relevant approved seller can assign a packed order. Combined-seller dispatch is blocked in this pilot. No new composite index is required.

Validation: 28 local backend tests and eight browser checks passed against demo-kstore, with separate seller/rider browser contexts. These checks do not establish real rider availability, actual delivery or collected cash in production. Local Functions used Node 24; deployment targets Node 22.

Delivery-exception release: 29 domain/Firestore/callable checks passed, including four new reassignment, custody, retry and race cases and authorization checks for all twelve callables. The test emulator was interrupted before Storage checks; the three Storage checks passed on a separate local rerun. Six browser wiring checks passed with synthetic state and mocked callable transport, and five cancellation-render regressions passed. No production failures, physical returns, deliveries or cash collection were simulated.
