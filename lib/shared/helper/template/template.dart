import "dart:io";
import 'package:process_run/shell.dart';
import 'package:yox/resources/session/package_info.dart';

class Template {
  static Future<bool> create(outputName, template) async {
    var file = await File(outputName);
    if (file.existsSync()) {
      print("Cannot create this module, already exists");
      return false;
    }
    await file.create(recursive: true);

    template = template
        .toString()
        .replaceAll("@material", "import \"package:flutter/material.dart\";")
        .replaceAll("@core", "import \"package:$packageName/core.dart\";")
        .replaceAll("package:example_app", "package:$packageName");

    await file.writeAsString(template);
    await Template.format(outputName);
    return true;
  }

  static void appendCodeBeforeTag({
    String fileName,
    String tag,
    String code,
    String validator,
    int tabCount = 1,
    bool disableFormat = false,
  }) async {
    var file = await File(fileName);
    var template = file.readAsStringSync();

    var tabString = "\t";
    if (tabCount > 1) {
      for (var i = 0; i < tabCount; i++) {
        tabString += "\t";
      }
    }

    code = code.trim();
    validator = validator.trim();
    if (template.indexOf(validator) > -1) return;

    template = template.replaceAll(tag, "$code\n$tabString$tag");

    await file.writeAsString(template);
    if (!disableFormat) {
      await Template.format(fileName);
    }
  }

  static format(String path) async {
    var shell = Shell();
    await shell.run("flutter format $path");
  }
}
