import 'dart:io';
import 'package:yox/resources/session/package_info.dart';

extension CleanFileNameExtension on String {
  String getFileName() {
    var value = this;
    value = this.replaceAll("\\", "/");
    return value;
  }

  bool isDartFile() {
    if (this.endsWith(".dart")) {
      return true;
    }
    return false;
  }
}

extension CleanFileNameForFileExtension on File {
  String getExportScriptFromFileName() {
    var file = this;
    var fileName = file.path;
    fileName = fileName.replaceAll("\\", "/").replaceAll("lib/", "");
    fileName = "export \"package:${packageName}/${fileName}\";"
        .getFileName();
    return fileName;
  }

  bool isDartFile() {
    if (this.path.endsWith(".dart")) {
      return true;
    }
    return false;
  }
}
