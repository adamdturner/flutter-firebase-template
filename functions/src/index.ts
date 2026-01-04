/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions/v2";
import {onRequest, onCall, HttpsError} from 'firebase-functions/v2/https';
import * as logger from "firebase-functions/logger";
import * as admin from 'firebase-admin';


// ensure admin is only initialized once across codebases (Square and Stripe and others may all use it)
if (!admin.apps.length) {
  admin.initializeApp();
}

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// Set global options for all functions
setGlobalOptions({
  maxInstances: 10,
  region: "us-central1",
});

// Example HTTP function - accessible at https://REGION-PROJECT_ID.cloudfunctions.net/helloWorld
export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});




// This cloud function is called when a user signs up and creates their 
// account. The role they've selected gets set using Firebase Auth Custom Claims.
// This function is an example of onCall instead of onRequest and uses .call() instead
// of http.post() or http.get() in the service.dart file
exports.setUserRole = onCall(async (request) => {
  const { uid, role } = request.data;

  if (!uid || !role) {
    console.log('missing either uid or role');
    console.log(`uid: ${uid}, role: ${role}`);
    throw new HttpsError(
      'invalid-argument',
      'Missing uid or role. Operation failed.'
    );
  }

  console.log(`Setting role: ${role} for uid: ${uid}`);

  try {
    await admin.auth().setCustomUserClaims(uid, { role });
    console.log(`Role '${role}' set for user ${uid}`);
    return {
      error: false,
      code: 'ROLE_SET_SUCCESS',
      message: `Role '${role}' set for user ${uid}`,
    };
  } catch (error) {
    console.error('Error setting custom claim:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    throw new HttpsError(
      'internal',
      `Internal Server Error. Error message: ${errorMessage}`
    );
  }
});