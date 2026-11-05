import {HttpsError} from 'firebase-functions/v2/https';
import {FieldValue} from 'firebase-admin/firestore';
import {text,ValidationError} from './domain.js';
export function adminHandlers(db,auth){return {
 async reviewApplication(r){
  if(r.auth.token.admin!==true)throw new HttpsError('permission-denied','Administrator access is required.');
  const uid=text(r.data?.uid,'Applicant ID',100),kind=r.data?.kind;if(!/^[A-Za-z0-9_-]+$/.test(uid)||!['seller','rider'].includes(kind))throw new ValidationError('Choose a seller or rider application.');
  const user=await auth.getUser(uid);if(!user.emailVerified||user.disabled)throw new HttpsError('failed-precondition','The applicant needs an enabled, verified account.');
  const ref=db.doc((kind==='seller'?'stores/':'couriers/')+uid);
  return db.runTransaction(async tx=>{
   const snap=await tx.get(ref),a=snap.data();if(!a)throw new HttpsError('not-found','Application not found.');
   const email=kind==='seller'?a.ownerEmail:a.email;if(String(email).toLowerCase()!==String(user.email).toLowerCase())throw new HttpsError('failed-precondition','Applicant identity does not match the verified account.');
   if(kind==='seller'){
    if(a.verificationStatus==='approved')return {uid,status:'approved'};
    if(a.verificationStatus!=='pending'||a.status!=='active'||!a.submittedAt)throw new HttpsError('failed-precondition','The seller must submit their application first.');
    const publicRef=db.doc('publicStores/'+uid);if(!(await tx.get(publicRef)).exists)throw new HttpsError('failed-precondition','The public store projection is missing.');
    tx.update(ref,{verificationStatus:'approved',updatedAt:FieldValue.serverTimestamp()});tx.update(publicRef,{verificationStatus:'approved'});
   }else{
    if(a.status==='approved'&&a.active===true)return {uid,status:'approved'};
    if(a.status!=='pending'||!a.name||!a.phone)throw new HttpsError('failed-precondition','A complete pending rider application is required.');
    tx.update(ref,{active:true,status:'approved',updatedAt:FieldValue.serverTimestamp()});tx.set(db.doc('courierDirectory/'+uid),{id:uid,name:a.name,phone:a.phone,active:true,updatedAt:FieldValue.serverTimestamp()});
   }
   tx.create(db.collection('adminAudit').doc(),{type:'Application approved',kind,applicantUid:uid,actorUid:r.auth.uid,createdAt:FieldValue.serverTimestamp()});return {uid,status:'approved'};
  });
 }
};}
