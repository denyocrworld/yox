import 'dart:io';

class CommonPackageExporter {
  static List commonExternalImportList = [
    "export 'package:get/get.dart';",
  ];
  
  static run() {
    var file = File("./lib/core.dart");
    var content = file.readAsStringSync();

    content += "\n" + commonExternalImportList.join("\n");

    file.writeAsStringSync(content);
  }
}
