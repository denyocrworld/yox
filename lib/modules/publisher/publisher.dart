import 'dart:io';

import 'package:yox/shared/helper/exec/exec.dart';

class Publisher {
  static run() async {
    var pubspecFile = File("pubspec.yaml");
    var lines = pubspecFile.readAsLinesSync();
    var newLines = [];
    var nv;

    for (var line in lines) {
      if (line.contains("version:")) {
        var arr = line.split(":");
        var version = arr[1];
        var vr = version.split(".");
        var minorVersion = vr.last;

        int newVersion = int.parse(minorVersion) + 1;

        vr.last = newVersion.toString();
        nv = vr.join(".").trim();

        line = "version: ${nv}";
        print(line);
      }
      newLines.add(line);
    }
    pubspecFile.writeAsStringSync(newLines.join("\n"));

    print("Publishing...");
    execLines([
      "flutter pub publish --force",
    ]);

    print("Push to Github");
    execLines([
      "git add .",
      "git commit -m \"Set new Version to ${nv}\"",
      "git push",
    ]);
    print("Done!");
  }
}
