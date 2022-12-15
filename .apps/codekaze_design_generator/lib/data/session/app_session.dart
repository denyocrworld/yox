import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppSession {
  static UserCredential userCredential;
  static bool isVendor = false;
}

String applicationPrefix = "app";

DocumentReference get userCollection {
  return FirebaseFirestore.instance
      .collection(
        applicationPrefix.isEmpty
            ? "user_data"
            : "${applicationPrefix}_user_data",
      )
      .doc(AppSession.userCredential.user.uid);
}

DocumentReference get publicCollection {
  return FirebaseFirestore.instance.doc(
    applicationPrefix.isEmpty
        ? "public_data"
        : "${applicationPrefix}_public_data",
  );
}
