import 'package:yox/shared/helper/dir/dir.dart';
import 'package:yox/shared/helper/exec/exec.dart';

class WifeClean {
  static String getFilePathFromAnalyzerLineString(String line) {
    var arr = line.split(" ");
    var path;
    for (var i = 0; i < arr.length; i++) {
      var str = arr[i];
      if (str.contains("lib\\")) {
        path = str;
        break;
      }
    }

    path = path.split(":")[0];
    return path;
  }

  static void run() {
    var test = exec("flutter analyze").toString().trim();
    var arr = test.split("\n");

    for (var i = 0; i < arr.length; i++) {
      var line = arr[i].trim();

      if (line.indexOf("is unnecessary because all of the used elements are") >
          -1) {
        var str = line;
        str = str.replaceAll("info - The import of ", "");
        str = str.split(" is ")[0];

        var path = getFilePathFromAnalyzerLineString(line);
        var file = dir(path);
        var content = file.readAsStringSync();
        content = content.replaceAll("import $str;", "");
        file.writeAsStringSync(content);

        print("Remove unnecessary import @ ${file.path}");
      }

      if (line.indexOf("Unused import:") > -1) {
        var str = line;
        str = str.replaceAll("info - Unused import: ", "");
        str = str.replaceAll(" - unused_import", "");
        str = str.replaceAll("'", "");
        str = str.trim();

        var packageString = str.split(" - ")[0];
        var path = str.split(" - ")[1].split(":")[0];
        var file = dir(path);
        var content = file.readAsStringSync();
        content = content.replaceAll("import '${packageString}';", "");
        file.writeAsStringSync(content);

        print("Remove unused import @ ${file.path}");
      }
    }
  }
}
