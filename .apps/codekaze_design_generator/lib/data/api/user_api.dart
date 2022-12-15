import 'package:design_generator/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserApi {
  static initialize() async {
    await userCollection.set(
      {
        "profile": {
          "uid": AppSession.userCredential.user.uid,
          "email": AppSession.userCredential.user.email,
          "email_verified": AppSession.userCredential.user.emailVerified,
          "photo_url": AppSession.userCredential.user.photoURL,
          "display_name": AppSession.userCredential.user.displayName,
        },
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}
