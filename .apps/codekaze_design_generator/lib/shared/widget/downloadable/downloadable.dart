import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:screenshot/screenshot.dart';

class Downloadable extends StatefulWidget {
  final String id;
  final Widget child;

  Downloadable({
    @required this.id,
    @required this.child,
  });

  @override
  _DownloadableState createState() => _DownloadableState();
}

class _DownloadableState extends State<Downloadable> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  void download() async {
    screenshotController.capture().then((Uint8List imageFile) {
      Get.snackbar("Generated", "Your Image(s) is Generated!");

      Directory currentDir = Directory.current;
      Directory('${currentDir.path}/output/').createSync();
      var f = File('${currentDir.path}/output/${widget.id}.png');
      f.writeAsBytesSync(imageFile);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: widget.child,
          ),
          Positioned(
            right: 10.0,
            top: 10.0,
            child: GlassContainer(
              blur: 1,
              opacity: 0.2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => download(),
                      child: Text("DL"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
