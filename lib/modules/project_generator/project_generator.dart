import 'dart:io';
import 'package:yox/shared/helper/exec/exec.dart';

class ProjectGenerator {
  static create() async {
    var dir = Directory.current;
    if (dir.listSync().isNotEmpty) {
      print("Current directory is not empty");
      print("If you continue, the contents of this directory will be deleted.");
      writeSeparator();
      var confirm = getInput(
        message: "Continue? (Y/N)",
      );

      if (confirm.toLowerCase() == "n") {
        return;
      }
    }

    writeSeparator();
    var applicationName = getInput(
      message: "1. Application Name:",
    );

    var packageName = getInput(
      message: "2. Package Name: (example: com.example.my_awesome_app)",
    );

    var arr = packageName.split(".");
    var shortPackageName = arr[arr.length - 1];

    writeSpace();
    writeSeparator();
    writeSeparator();
    print("Confirm:");
    print("Applicaton Name : ${applicationName}");
    print("Package Name : ${packageName}");
    print("Short Package Name : ${shortPackageName}");
    writeSeparator();
    writeSeparator();
    print("Create YoProject? (Y/N)");
    var confirm = getInput();

    if (confirm.toString().toLowerCase() == "n") {
      return;
    }

    // dir.deleteSync(
    //   recursive: true,
    // );

    List items = dir.listSync();
    for (var item in items) {
      if (item is File) {
        File file = item;
        file.deleteSync();
      } else if (item is Directory) {
        Directory dir = item;
        dir.deleteSync(
          recursive: true,
        );
      }
    }

    // exec('del /s /q /f .git');
    // exec('del /s /q /f .git');
    // exec('del /s /q /f *');
    //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
    exec('git clone https://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@github.com/codekaze/codekaze_app .');

    // print(res);
    // exec('del /s /q /f .git');

    // var dir = Directory.current;

    // var filePath = "$dir/pubspec.yaml";

    // filePath = filePath.replaceAll("'", "");
    // filePath = filePath.replaceAll("\\", "/");
    // print(filePath);

    await updatePackageName(packageName);
    await updateShortPackageName(shortPackageName);
    await replaceDefaultAppName(shortPackageName, applicationName);
    await cleanReadme();
    await updateApplicationName(applicationName);

    var p = File("./pubspec.yaml");
    print(p.existsSync());
    // // print(p.readAsStringSync());

    exec("git remote remove origin");

    writeSeparator();
    print("YoProject Created!");
    writeSeparator();
  }

  static updatePackageName(packageName) async {
    List files = [
      "android/app/build.gradle",
      "android/app/src/debug/AndroidManifest.xml",
      "android/app/src/main/AndroidManifest.xml",
      "android/app/src/main/kotlin/com/example/codekaze_app/MainActivity.kt",
      "android/app/src/main/kotlin/com/example/codekaze_app/MainActivity.kt",
      "android/app/src/profile/AndroidManifest.xml",
    ];

    files.forEach((filePath) {
      File file = File(filePath);
      var content = file.readAsStringSync();
      content = content.replaceAll("com.example.codekaze_app", packageName);
      file.writeAsStringSync(content);
    });
  }

  static updateShortPackageName(shortPackageName) async {
    Directory dir = Directory('lib/');
    dir.list(recursive: true).forEach((f) {
      if (f.path.endsWith(".dart")) {
        File file = File(f.path);
        var content = file.readAsStringSync();

        content =
            content.replaceAll("package:demo_app", "package:$shortPackageName");
        file.writeAsStringSync(content);
      }
    });

    File file = File("pubspec.yaml");
    var content = file.readAsStringSync();
    content = content.replaceAll("name: demo_app", "name: $shortPackageName");
    file.writeAsStringSync(content);
  }

  static replaceDefaultAppName(shortPackageName, applicationName) async {
    List dirs = [
      "android/",
      "ios/",
      "windows/",
      "web/",
    ];

    dirs.forEach((dirName) {
      Directory dir = Directory('$dirName');
      dir.list(recursive: true).forEach((f) {
        File file = File(f.path);
        if (file.path.endsWith(".gradle") ||
            file.path.endsWith(".xml") ||
            file.path.endsWith(".kt") ||
            file.path.endsWith(".plist") ||
            file.path.endsWith(".html") ||
            file.path.endsWith(".json") ||
            file.path.endsWith(".txt") ||
            file.path.endsWith(".cpp") ||
            file.path.endsWith(".rc") ||
            file.path.endsWith(".pbxproj")) {
          var content = file.readAsStringSync();
          content = content.replaceAll("codekaze_app", "$shortPackageName");
          content = content.replaceAll("codekazeApp", "${applicationName}");
          file.writeAsStringSync(content);
        }
      });
    });
  }

  static cleanReadme() {
    File file = File("README.md");
    file.writeAsStringSync("");
  }

  static updateApplicationName(applicationName) async {
    List files = [
      "android/app/src/main/AndroidManifest.xml",
    ];

    files.forEach((filePath) {
      File file = File(filePath);
      var content = file.readAsStringSync();
      content = content.replaceAll("Codekaze App", applicationName);
      file.writeAsStringSync(content);
    });
  }
}
