import "dart:io";
import 'package:uuid/uuid.dart';
import 'package:yox/data/config.dart';
import 'package:yox/shared/helper/fsx/fsx.dart';
import 'package:yox/shared/helper/exec/exec.dart';

class ArchiveGenerator {
  static run() async {
    var currentDirectory = execr(
      "echo %cd%",
    ).toString().trim();

    var arr = currentDirectory.split("\\");
    var directoryName = arr.last;

    execLines([
      "flutter clean",
    ]);

    execLines([
      "rmdir /s /q \"$currentDirectory\\test\"",
    ]);

    var uuid = Uuid();
    var tempDirName = uuid.v4();

    Fsx.copy(
      currentDirectory,
      "${tempDir}\\$tempDirName\\source\\",
    );

    var f = File("${tempDir}\\$tempDirName\\documentation.html");
    if (f.existsSync() == false) {
      f.createSync(
        recursive: true,
      );
    }
    f.writeAsStringSync(
        '<script>window.location.href = "${docsUrl}";</script>');

    String zipFileName = "${directoryName}_source_and_docs.zip";
    String zipPath = "${tempDir}\\$zipFileName";
    String zipGoogleDrivePath = "${mainGdrivePath}\\$directoryName\\";

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
