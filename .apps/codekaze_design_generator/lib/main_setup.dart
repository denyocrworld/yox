import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_generator/core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MainSetup {
  static setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    if (Platform.isWindows) {
      return;
    }
    await Firebase.initializeApp();

    if (kIsWeb) {
      FirebaseFirestore.instance.enablePersistence();
    } else {
      FirebaseFirestore.instance.settings = Settings(
        persistenceEnabled: true,
      );
    }

    await db.load();
  }
}
