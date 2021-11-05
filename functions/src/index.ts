import * as functions from "firebase-functions";
import * as admin from 'firebase-admin'; //access to firestore

admin.initializeApp(functions.config().firebase);

//check if a new user is created!
export const onNewUser = functions.firestore.document("/usuarios/{id}").onCreate((snapshot, context) => {
    const idUser = context.params.id;
    console.log("id do novo usuario ",idUser);
    return null;
  });
