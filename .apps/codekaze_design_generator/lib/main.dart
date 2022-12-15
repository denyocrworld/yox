import 'package:design_generator/core.dart';
import 'package:design_generator/module/home/view/home_view.dart';
import 'package:flutter/material.dart';

void main() async {
  await MainSetup.setup();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    theme: ThemeData.dark(),
    defaultTransition: Transition.fade,
    home: getHome(),
  ));
}

Widget getHome() {
  return HomeView();
}
