import 'package:uuid/uuid.dart';
import 'package:yox/data/config.dart';
import 'package:yox/shared/helper/fsx/fsx.dart';

import '../../shared/helper/exec/exec.dart';

class BuildGenerator {
  static run() {
    for (var i = 0; i < registeredProjects.length; i++) {
      print("Building... ");
      print("${i}/${registeredProjects.length}");
      var target = registeredProjects[i];

      String source =
          target + r"\build\app\outputs\flutter-apk\app-release.apk";
      String gdriveFileName =
          target.toString().split(r"\").last.replaceAll("_", "-") +
              "-release.apk";
      String gdrivePath = "${mainGdrivePath}\\${gdriveFileName}";

      List commands = [
        'cd "$target"'.trim(),
        "flutter build apk --release".trim(),
        // 'xcopy "$source" "$gdrivePath"* /Y'.trim(),
      ];

      var query = commands.join(" && ").trim();

      print("=====================================");
      print("Query::");
      print("=====================================");
      print("$query");
      print("=====================================");

      execLines([
        query,
      ], workingDirectory: target);

      Fsx.copyFile(source, gdrivePath);
    }
  }

  static archiveAll() async {
    for (var i = 0; i < registeredProjects.length; i++) {
      var target = registeredProjects[i];

      String dirName = target.toString().split(r"\").last.replaceAll("_", "-");

      var uuid = Uuid();
      var tempDirName = uuid.v4();

      List commands = [
        'cd "$target"'.trim(),
        'flutter clean',
      ];

      var query = commands.join(" && ").trim();
      execLines([
        query,
      ], workingDirectory: target);

      Fsx.copy(
        target,
        "${tempDir}\\$tempDirName\\source\\",
      );

      Fsx.createFile(
        target: "${tempDir}\\$tempDirName\\documentation.html",
        content: '<script>window.location.href = "${docsUrl}";</script>',
      );

      Fsx.createFile(
        target: "${tempDir}\\$tempDirName\\backend-example.html",
        content:
            '<script>window.location.href = "https://github.com/codekaze/codecanyon_backend";</script>',
      );

      String zipFileName = "${dirName}_source_and_docs.zip";
      String zipPath = "${tempDir}\\$zipFileName";
      String zipGoogleDrivePath = "${mainGdrivePath}\\$dirName\\";

      await Future.delayed(Duration(seconds: 3));

      Fsx.archive(
        zipPath,
        "${tempDir}\\$tempDirName\\",
      );

      Fsx.copy(
        zipPath,
        zipGoogleDrivePath,
      );

      Fsx.delete("${tempDir}\\$tempDirName\\");
      Fsx.delete(zipPath);
    }
  }
}
