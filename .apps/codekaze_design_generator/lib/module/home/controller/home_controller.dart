import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:design_generator/module/home/view/home_view.dart';
import 'package:screenshot/screenshot.dart';


class HomeController extends GetxController {
  HomeView view;
  int imageIndex = 36;
  Uint8List imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  String promotionalTag = "Elegance";
  String applicationName1 = "Barbershop";
  String applicationName2 = "Booking App";
  String iconName = "Br";

  void initialize() async {}

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List features = [
    {
      "icon": FlutterIcons.google_ant,
      "label": "Social Login",
    },
    {
      "icon": FlutterIcons.firebase_mco,
      "label": "Firestore Integration",
    },
    {
      "icon": FlutterIcons.stripe_faw5d,
      "label": "Stripe Integration",
    },
    {
      "icon": FlutterIcons.map_check_mco,
      "label": "Google Map Integration",
    },
    {
      "icon": FlutterIcons.chip_mco,
      "label": "Getx State Management",
    },
    {
      "icon": FlutterIcons.image_album_mco,
      "label": "ImgBB Api Integration",
    },
    {
      "icon": FlutterIcons.extension_mdi,
      "label": "Useful Admin Utility",
    },
    {
      "icon": Icons.palette,
      "label": "40+ Theme",
    }
  ];

  List mainFeatures = [
    {
      "icon": FlutterIcons.servicestack_faw5d,
      "label": "Product/Service Management",
    },
    {
      "icon": FlutterIcons.statusnet_zoc,
      "label": "Order Tracking",
    },
    {
      "icon": FlutterIcons.approximately_equal_box_mco,
      "label": "Order Approval",
    },
    {
      "icon": FlutterIcons.account_badge_mco,
      "label": "Vendor Approval",
    },
    {
      "icon": FlutterIcons.cash_refund_mco,
      "label": "Payment Refund",
    },
    {
      "icon": FlutterIcons.calendar_alt_faw5,
      "label": "Booking Calendar",
    },
    {
      "icon": FlutterIcons.photo_mdi,
      "label": "Manage Galleries",
    },
    {
      "icon": FlutterIcons.map_fea,
      "label": "Search by Nearby Location",
    },
  ];

  void generate() {
    screenshotController.capture().then((Uint8List image) {
      //Capture Done
      imageFile = image;
      update();

      Get.snackbar("Generated", "Your Image(s) is Generated!");

      var f = File("c:/test.jpg");
      f.writeAsBytesSync(imageFile);
    }).catchError((onError) {
      print(onError);
    });
  }
}
