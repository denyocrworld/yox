import "dart:io";
import 'package:yox/data/config.dart';
import 'package:yox/shared/helper/exec/exec.dart';
import 'package:yox/shared/helper/fsx/fsx.dart';
import 'package:yox/shared/helper/name_parser/name_parser.dart';

extension StringExtension on String {
  String get fileName {
    var str = this;
    str = str.replaceAll("/", "\\");
    return str.split("\\").last;
  }

  String get fixFormat {
    var str = this;
    str = str.replaceAll("/", "\\");
    return str;
  }
}

class BookingCoreSpitGenerator {
  static run() async {
    List<Map> logs = [];
    Directory bookingApiDir = Directory(BOOKING_API_DIR);
    print("Current DIR: ${bookingApiDir.path}");

    var dirs = [];
    Directory("${bookingApiDir.path}/lib/config")
        .listSync(
      recursive: false,
    )
        .forEach((element) {
      if (element is Directory) {
        dirs.add(element.path);
      }
    });

    execLines([
      'rmdir /s /q "${bookingApiDir.path}/build"',
    ]);

    for (var i = 0; i < dirs.length; i++) {
      var appName = dirs[i].toString().fileName;
      var target = '${bookingApiDir.path}/../generated/$appName';
      execLines([
        'rmdir /s /q "$target"',
        'xcopy "${bookingApiDir.path}" "$target" /E/H/C/I',
        'rmdir /s /q "$target/lib/config/"',
        'rmdir /s /q "$target/lib/config_backup/"',
        'rmdir /s /q "$target/.git"',
      ]);

      var copyAssetCommand =
          'xcopy "${bookingApiDir.path}\\lib\\config\\$appName\\assets" "$target\\assets" /E/H/C/I/Y';

      execLines([
        copyAssetCommand,
      ]);

      var dummyApiClassName = "${NameParser.getClassName(appName)}DummyApi";
      var dummyApiFileName =
          "${NameParser.getFileName(appName)}_dummy_api.dart";
      print(dummyApiFileName);

      var f =
          File('${bookingApiDir.path}/lib/config/$appName/$dummyApiFileName');
      var content = f.readAsStringSync();

      content = content.replaceAll(dummyApiClassName, "MainDummyApi");

      Directory('$target/lib/config/').createSync();
      var tf = File('$target/lib/config/main_dummy_api.dart');
      tf.writeAsStringSync(content);

      //Change Icon
      var appAssetDir =
          '${bookingApiDir.path}/lib/config/$appName/assets/'.fixFormat;
      var projectAssetDir = '${bookingApiDir.path}/assets/'.fixFormat;

      execLines([
        'xcopy "$appAssetDir" "$projectAssetDir" /E/H/C/I/Y/S',
      ]);

      //---------------------
      //!TODO:
      var fileList = Directory("$target")
          .listSync(
            recursive: true,
          )
          .toList();

      for (var x = 0; x < fileList.length; x++) {
        var f = fileList[x];
        if (f is File) {
          if (f.path.endsWith(".dart") ||
              f.path.endsWith(".gradle") ||
              f.path.endsWith(".xml") ||
              f.path.endsWith(".yaml") ||
              f.path.endsWith(".kt")) {
            var content = f.readAsStringSync();
            content = content.replaceAll("booking_core_api", "$appName");

            f.writeAsStringSync(content);
          }
        }
      }
      //---------------------
      var androidApplicationName = NameParser.getTitle(appName);
      var androidPackageName =
          "com.codekaze.${appName.toLowerCase().replaceAll(" ", "_")}";
      print("Rename to $androidPackageName");
      print(androidApplicationName);

      logs.add({
        "copy_asset_command": copyAssetCommand,
        "app_name": androidApplicationName,
        "android_package_name": androidPackageName,
        "working_directory": target,
      });

      Fsx.updateProjectNameAndPackage(
        target: target,
        appName: androidApplicationName,
        packageName: androidPackageName,
      );

      List commands = [
        "cd \"$target\"",
        "flutter clean",
        "flutter pub get",
        "yoxdev clean",
        "yoxdev generate_icon",
        "yoxdev core",
      ];

      execLines([
        commands.join(" && "),
      ], workingDirectory: target);
    }

    for (var i = 0; i < logs.length; i++) {
      var log = logs[i];
      print("==================================");
      log.forEach((key, value) {
        print("$key: $value");
      });
      print("==================================");
    }
  }
}
