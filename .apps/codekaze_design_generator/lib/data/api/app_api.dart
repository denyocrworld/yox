import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_generator/core.dart';

class AppApi {
  static Future<bool> firstTimeSetupDataCheck() async {
    try {
      var snapshot = await userCollection.collection("tasks").get();

      if (snapshot.docs.isEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
  // // static Future generateDummyDataIfNotExists() async {
  // //   //TODO: change collectionName to your product collection
  // //   var snapshot = await publicCollection.collection("collectionName").get();
  // //   if (snapshot.docs.isEmpty) {
  // //     //TODO: Generate Your Dummy data Here
  // //   }
  // // }

  //! Example
  static Future generateDummyDataIfNotExists() async {
    var snapshot = await userCollection.collection("tasks").get();
    if (snapshot.docs.isEmpty) {
      userCollection.collection("tasks").add({
        "task_name": "Fix wordpress bug",
        "status": "Pending",
        "created_at": Timestamp.now(),
      });

      userCollection.collection("tasks").add({
        "task_name": "Fix wordpress bug",
        "status": "Pending",
        "created_at": Timestamp.now(),
      });

      userCollection.collection("tasks").add({
        "task_name": "Fix UX error in Homepage",
        "status": "Pending",
        "created_at": Timestamp.now(),
      });

      userCollection.collection("tasks").add({
        "task_name": "Fix null Exception",
        "status": "Pending",
        "created_at": Timestamp.now(),
      });

      userCollection.collection("tasks").add({
        "task_name": "Update Woocommerxe to 4.0",
        "status": "Pending",
        "created_at": Timestamp.now(),
      });

      userCollection.collection("tasks").add({
        "task_name": "Migrate Database",
        "status": "Pending",
        "created_at": Timestamp.now(),
      });

      userCollection.collection("tasks").add({
        "task_name": "Update ticket status",
        "status": "Pending",
        "created_at": Timestamp.now(),
      });
    }
  }
}
