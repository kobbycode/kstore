import {HttpsError} from 'firebase-functions/v2/https';
import {FieldValue} from 'firebase-admin/firestore';
import {text,ValidationError} from './domain.js';
const stamp=()=>FieldValue.serverTimestamp();
const arrival=value=>{const eta=text(value,'Estimated arrival date',10);if(!/^\d{4}-\d{2}-\d{2}$/.test(eta)||!Number.isFinite(Date.parse(eta))||new Date(eta).toISOString().slice(0,10)!==eta||eta<new Date().toISOString().slice(0,10))throw new ValidationError('Choose a valid estimated arrival date.');return eta;};
const key=value=>{const v=text(value,'Identifier',100);if(!/^[A-Za-z0-9_-]+$/.test(v))throw new ValidationError('Invalid identifier.');return v;};
export function phone(value){const v=text(value,'Recipient phone',20,9);if(!/^[+0-9 ()-]+$/.test(v)||v.replace(/\D/g,'').length<9||v.replace(/\D/g,'').length>15)throw new ValidationError('A valid recipient phone is required.');return v;}
export function deliveryHandlers(db){return {
 async requestCourierAccess(r){
  const uid=r.auth.uid,name=text(r.data?.name,'Rider name',70),contact=phone(r.data?.phone),ref=db.doc('couriers/'+uid);
  return db.runTransaction(async tx=>{const prior=(await tx.get(ref)).data()||{};tx.set(ref,{...prior,id:uid,name,phone:contact,email:r.auth.token.email||'',active:prior.active===true,status:prior.active===true?'approved':'pending',updatedAt:stamp()});if(prior.active)tx.set(db.doc('courierDirectory/'+uid),{id:uid,name,phone:contact,active:true,updatedAt:stamp()});return {status:prior.active?'approved':'pending'};});
 },
 async assignDelivery(r){
  const uid=r.auth.uid,id=key(r.data?.id),courierUid=key(r.data?.courierUid),orderRef=db.doc('orders/'+id),jobRef=db.doc('courierJobs/'+courierUid+'/jobs/'+id);
  return db.runTransaction(async tx=>{
   const [os,ss,cs,js]=await Promise.all([tx.get(orderRef),tx.get(db.doc('stores/'+uid)),tx.get(db.doc('couriers/'+courierUid)),tx.get(jobRef)]);
   const o=os.data(),s=ss.data(),c=cs.data();
   if(!o||!o.sellerUids?.includes(uid)||s?.verificationStatus!=='approved')throw new HttpsError('permission-denied','Only this order’s approved seller can dispatch it.');
   if(o.sellerUids.length!==1)throw new HttpsError('failed-precondition','Combined-seller delivery is not supported by the pilot.');
   if(o.status!=='Packed'||o.collection)throw new HttpsError('failed-precondition','Only a packed parcel held by the seller can be assigned.');
   const previous=o.deliveryAssignment;
   const reassignmentReason=previous?text(r.data?.reason,'Reassignment reason',200,5):null;
   if(previous){
    if(r.data?.expectedCourierUid!==previous.courierUid||courierUid===previous.courierUid)throw new HttpsError('failed-precondition','Refresh the assignment and choose a different rider.');
    if(!['Assigned','Accepted','Delivery failed','Returned to seller'].includes(previous.status))throw new HttpsError('failed-precondition','The parcel must be returned before reassignment.');
   }
   if(js.exists&&!['Reassigned','Returned to seller'].includes(js.data().status))throw new HttpsError('failed-precondition','This rider already has an active or completed job for this order.');
   const oldJob=previous?db.doc('courierJobs/'+previous.courierUid+'/jobs/'+id):null;
   if(oldJob&&!(await tx.get(oldJob)).exists)throw new HttpsError('failed-precondition','The previous delivery job is missing.');
   if(!c?.active)throw new HttpsError('failed-precondition','Choose an approved rider.');
   if(!o.recipient?.phone)throw new HttpsError('failed-precondition','This older order needs confirmed delivery contact details.');
   const eta=arrival(r.data?.estimatedDate);
   const assignment={courierUid,riderName:c.name,status:'Assigned',jobId:id,estimatedDate:eta};
   if(oldJob)tx.set(oldJob,{id,orderId:id,sellerId:uid,courierUid:previous.courierUid,status:'Reassigned',updatedAt:stamp()});
   tx.set(jobRef,{id,orderId:id,sellerId:uid,courierUid,status:'Assigned',estimatedDate:eta,recipient:o.recipient,destination:o.destination,lines:o.lines,total:o.total,currency:o.currency,payment:o.payment,createdAt:stamp(),updatedAt:stamp()});
   tx.update(orderRef,{deliveryAssignment:assignment,updatedAt:stamp()});tx.update(db.doc('sellerOrders/'+uid+'/orders/'+id),{deliveryAssignment:assignment,updatedAt:stamp()});
   tx.create(orderRef.collection('events').doc(),{type:previous?'Rider reassigned':'Rider assigned',actorUid:uid,courierUid,previousCourierUid:previous?.courierUid||null,reason:reassignmentReason,createdAt:stamp()});return {id,status:'Assigned'};
  });
 },
 async updateCourierDelivery(r){
  const uid=r.auth.uid,id=key(r.data?.id),next=r.data?.status,jobRef=db.doc('courierJobs/'+uid+'/jobs/'+id),orderRef=db.doc('orders/'+id);
  return db.runTransaction(async tx=>{
   const [js,os,cs]=await Promise.all([tx.get(jobRef),tx.get(orderRef),tx.get(db.doc('couriers/'+uid))]);const j=js.data(),o=os.data();
   if(!j||!o||!cs.data()?.active||o.deliveryAssignment?.courierUid!==uid)throw new HttpsError('permission-denied','Delivery access denied.');
   if(['Cancelled','Return requested','Delivered'].includes(o.status))throw new HttpsError('failed-precondition','This order is no longer available for delivery updates.');
   const failed=next==='Delivery failed';
   if(failed?!['Accepted','Picked up','Out for delivery'].includes(j.status):({Assigned:'Accepted',Accepted:'Picked up','Picked up':'Out for delivery','Out for delivery':'Delivered'})[j.status]!==next)throw new HttpsError('failed-precondition','Complete delivery steps in order.');
   const assignment={...o.deliveryAssignment,status:next},patch={deliveryAssignment:assignment,updatedAt:stamp()},jobPatch={status:next,updatedAt:stamp()};
   if(failed){const reason=r.data?.reason;if(!['Recipient unavailable','Address issue','Recipient declined','Vehicle issue','Other'].includes(reason))throw new ValidationError('Select a failure reason.');assignment.failureReason=reason;assignment.failedFrom=j.status;jobPatch.failureReason=reason;jobPatch.failedFrom=j.status;}
   if(next==='Picked up'){patch.status='Shipped';patch.sellerFulfillment={...o.sellerFulfillment,[j.sellerId]:'Shipped'};}
   if(next==='Delivered'){
    if(o.payment!=='Pay on delivery'||r.data?.cashCollected!==true)throw new HttpsError('failed-precondition','Confirm the exact cash amount collected before completing this COD delivery.');
    const receivedBy=text(r.data?.receivedBy,'Recipient confirmation name',70);patch.status='Delivered';patch.sellerFulfillment={...o.sellerFulfillment,[j.sellerId]:'Delivered'};patch.paymentStatus='Cash collected — awaiting settlement';patch.collection={amount:o.total,currency:o.currency,courierUid:uid,receivedBy,recordedAt:stamp()};jobPatch.receivedBy=receivedBy;jobPatch.cashCollected=o.total;
   }
   tx.update(jobRef,jobPatch);tx.update(orderRef,patch);tx.update(db.doc('sellerOrders/'+j.sellerId+'/orders/'+id),patch);tx.create(orderRef.collection('events').doc(),{type:next,actorUid:uid,reason:failed?assignment.failureReason:null,createdAt:stamp()});return {id,status:next};
  });
 },
 async resolveDeliveryFailure(r){
  const uid=r.auth.uid,id=key(r.data?.id),ref=db.doc('orders/'+id);
  return db.runTransaction(async tx=>{
   const [os,ss]=await Promise.all([tx.get(ref),tx.get(db.doc('stores/'+uid))]);const o=os.data(),a=o?.deliveryAssignment;
   if(!o||o.sellerUids?.length!==1||o.sellerUids[0]!==uid||ss.data()?.verificationStatus!=='approved')throw new HttpsError('permission-denied','Only the approved seller can resolve this delivery.');
   if(!a||a.status!=='Delivery failed'||!['Packed','Shipped'].includes(o.status)||o.collection||r.data?.expectedCourierUid!==a.courierUid)throw new HttpsError('failed-precondition','Refresh this failed delivery before resolving it.');
   const jobRef=db.doc('courierJobs/'+a.courierUid+'/jobs/'+id),[js,cs]=await Promise.all([tx.get(jobRef),tx.get(db.doc('couriers/'+a.courierUid))]);const j=js.data();
   if(!j||j.status!=='Delivery failed')throw new HttpsError('failed-precondition','The failed job does not match this order.');
   let status,estimatedDate=a.estimatedDate;const patch={updatedAt:stamp()};
   if(r.data?.action==='retry'){if(!cs.data()?.active)throw new HttpsError('failed-precondition','The rider is no longer active.');estimatedDate=arrival(r.data?.estimatedDate);status=o.status==='Packed'?'Assigned':'Picked up';}
   else if(r.data?.action==='returned'){if(o.status!=='Shipped'||r.data?.parcelReceived!==true)throw new HttpsError('failed-precondition','Confirm physical return of the parcel to the seller.');status='Returned to seller';patch.status='Packed';patch.sellerFulfillment={...o.sellerFulfillment,[uid]:'Packed'};}
   else throw new ValidationError('Choose retry or confirm parcel return.');
   patch.deliveryAssignment={...a,status,estimatedDate,failureReason:null,failedFrom:null};tx.update(jobRef,{status,estimatedDate,updatedAt:stamp()});tx.update(ref,patch);tx.update(db.doc('sellerOrders/'+uid+'/orders/'+id),patch);tx.create(ref.collection('events').doc(),{type:status==='Returned to seller'?'Parcel return confirmed':'Delivery retry arranged',actorUid:uid,courierUid:a.courierUid,previousFailureReason:a.failureReason||null,createdAt:stamp()});return {id,status};
  });
 }
};}
