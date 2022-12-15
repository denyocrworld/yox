import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future showPopup(
  Widget popupWidget, {
  bool barrierDismissible = false,
}) async {
  var context = Get.context;

  await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (barrierDismissible) Get.back();
            },
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Center(
                  child: popupWidget,
                ),
              ],
            ),
          ),
        );
      });
}
