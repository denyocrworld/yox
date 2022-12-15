import "dart:io";
import 'package:yox/shared/helper/exec/exec.dart';
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

class SwitchGenerator {
  static run(String selectedAppName) async {
    Directory currentDir = Directory.current;
    print("Current DIR: ${currentDir.path}");

    var dirs = [];
    Directory("${currentDir.path}/lib/config")
        .listSync(
      recursive: false,
    )
        .forEach((element) {
      if (element is Directory) {
        dirs.add(element.path);
      }
    });

    execLines([
      'rmdir /s /q "${currentDir.path}/build"',
    ]);

    var appName = selectedAppName;
    var target = '${currentDir.path}';

    var dummyApiClassName = "${NameParser.getClassName(appName)}DummyApi";
    var dummyApiFileName = "${NameParser.getFileName(appName)}_dummy_api.dart";
    print(dummyApiFileName);

    var f = File('${currentDir.path}/lib/config/$appName/$dummyApiFileName');
    var content = f.readAsStringSync();
    content = content.replaceAll(dummyApiClassName, "MainDummyApi");

    var tf = File('$target/lib/config/main_dummy_api.dart');
    tf.writeAsStringSync(content);

    //Change Icon
    var appAssetDir =
        '${currentDir.path}/lib/config/$appName/assets/'.fixFormat;
    var projectAssetDir = '${currentDir.path}/assets/'.fixFormat;

    execLines([
      'xcopy "$appAssetDir" "$projectAssetDir" /E/H/C/I/Y/S',
      'flutter pub run flutter_launcher_icons:main',
    ]);
  }
}
