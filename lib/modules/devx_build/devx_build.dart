import 'dart:io';
import 'package:yox/data/config.dart';
import 'package:yox/resources/session/package_info.dart';
import 'package:yox/shared/helper/exec/exec.dart';

class WifeBuild {
  static run() async {
    await getPackageName();
    Directory current = Directory.current;

    var res;

    print("Build APK");
    res = exec("flutter build apk --release");
    print(res);

    var source =
        current.path + r"\build\app\outputs\flutter-apk\app-release.apk";
    var target = "${mainGdrivePath}\\" + packageName + ".apk";

    print("Copy File");
    await File(source).copy(target);
  }
}
