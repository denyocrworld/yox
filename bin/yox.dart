import "dart:io";
import 'package:yox/core.dart';
import 'package:yox/modules/archive/archive_generator.dart';
import 'package:yox/modules/asset_to_network/asset_to_network.dart';
import 'package:yox/modules/build_generator/build_generator.dart';
import 'package:yox/modules/core_generator/core_generator.dart';
import 'package:yox/modules/deploy/deploy.dart';
import 'package:yox/modules/gdrive_check/gdrive_check.dart';
import 'package:yox/modules/generate_snippet/generate_snippet.dart';
import 'package:yox/modules/git_helper/git_helper.dart';
import 'package:yox/modules/icon_generator/icon_generator.dart';
import 'package:yox/modules/module_generator/module_generator.dart';
import 'package:yox/modules/project_generator/project_generator.dart';
import 'package:yox/modules/devx_build/devx_build.dart';
import 'package:yox/modules/devx_clean/devx_clean.dart';
import 'package:yox/modules/publisher/publisher.dart';
import 'package:yox/modules/requirement/requirement.dart';
import 'package:yox/modules/split_generator/booking_core_split_generator.dart';
import 'package:yox/modules/split_generator/split_generator.dart';
import 'package:yox/modules/switch_generator/switch_generator.dart';
import 'package:yox/resources/session/package_info.dart';
import 'package:yox/shared/helper/exec/exec.dart';

void main(List<String> args) async {
  var pubSpecFile = await File("./pubspec.yaml");
  bool hasPubspec = false;
  if (pubSpecFile.existsSync()) {
    await getPackageName();
    hasPubspec = true;
  }

  if (Directory("c:/yo_temp").existsSync() == false) {
    Directory("c:/yo_temp").createSync();
  }

  if (!await Requirement.isValid()) {
    return;
  }

  // await generateDefinedTemplate();
  // await createImport();

  var dir = Directory("c:/yo");
  if (!dir.existsSync()) {
    dir.createSync();

    var f = File("c:/yo/yoxdev.bat");
    f.writeAsStringSync("flutter pub global run yox %*");
  }

  // if (!File("c:/yo/autocrop.exe").existsSync()) {
  //   print("Generate autocrop.exe");
  //   var cmdS =
  //       'curl -S -H "Authorization: token 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" -o c:/yo/autocrop.exe "https://raw.githubusercontent.com/codekaze/yo/master/python-script/autocrop.exe"';

  //   var f = File("c:/yo/script.bat");
  //   f.writeAsStringSync(cmdS);

  //   exec("c:/yo/script.bat");
  //   exec('SETX PATH "%PATH%;c:\yo"');

  //   print("Generate autocrop.exe DONE");
  //   f.deleteSync();
  // }

  List mustRegisteredPath = [
    "C:\\yo",
    "C:\\flutter\\bin",
    "C:\\flutter\\.pub-cache\\bin",
    "C:\\flutter\\bin\\cache\\dart-sdk\\bin",
    "C:\\flutter\\bin\\cache\\dart-sdk\\bin\\cache\\dart-sdk\\bin",
    "C:\\Program Files\\Android\\Android Studio\\jre\\bin",
    "C:\\Program Files\\7-Zip\\",
    //PHP & MYSQL
    "C:\\xampp\\mysql\\bin",
    "C:\\xampp\\php",
  ];

  var fullPath = "";
  mustRegisteredPath.forEach((path) {
    fullPath += ";$path";
  });

  var currentPath = exec("echo %PATH%");
  fullPath = currentPath + fullPath;
  fullPath = fullPath.replaceAll(";;", ";");
  fullPath = fullPath.replaceAll("//", "/");
  fullPath = fullPath.replaceAll("\n", "");
  var arr = fullPath.split(";");

  arr = arr.toSet().toList();
  fullPath = arr.join(";").trim();

  execLines([
    'SETX PATH "$fullPath"',
  ]);

  execLines([
    'SET PATH="$fullPath"',
  ]);

  execLines([
    'SETX JAVA_HOME "C:\\Program Files\\Android\\Android Studio\\jre"',
  ]);

  var fullArgumentString = args.join(" ");
  var command = args.isEmpty ? "" : args[0];

  if (command == "module") {
    if (hasPubspec) {
      await getPackageName();

      if (fullArgumentString.contains("module create")) {
        var moduleName = fullArgumentString.split("module create ")[1];
        print("--------------");
        print("Create Module");
        print("Module Name: $moduleName");
        print("--------------");
        ModuleGenerator.create(moduleName);
      }
    } else {
      print("This command only works on flutter projects directory");
    }
  } else if (command == "init") {
    print("--------------");
    print("DevxInit");
    print("This command will create a project with yox app templates");
    print("--------------");
    ProjectGenerator.create();
  } else if (command == "generate_icon") {
    print("--------------");
    print("Update Icon");
    print("This command will use icon on assets/icon/icon.png");
    print("--------------");
    IconGenerator.create();
  } else if (command == "build") {
    print("--------------");
    print("DevxBuild");
    print("This command will build apk and upload to Google Drive");
    print("--------------");
    WifeBuild.run();
  } else if (command == "clean") {
    print("--------------");
    print("DevxClean");
    print("This command will remove unused imports");
    print("--------------");
    WifeClean.run();
  } else if (command == "asset_to_network") {
    print("--------------");
    print("This command will upload all network assets to imgbb?");
    print("--------------");
    AssetToNetwork.run();
  }
  //Under Development Feature
  else if (command == "core") {
    print("--------------");
    print("This command will generate core file");
    print("--------------");
    CoreGenerator.run();
  } else if (command == "push") {
    print("--------------");
    print("This command will do a simple push with your git");
    print("--------------");
    GitHelper.simplePush();
  } else if (command == "config") {
    print("--------------");
    print("This command will show your current config");
    print("--------------");
    GitHelper.config();
  } else if (command == "add") {
    print("--------------");
    print("This command will do a simple push with your git");
    print("--------------");
    GitHelper.add(fullArgumentString);
  } else if (command == "clone") {
    print("--------------");
    print("This command will do a simple clone with your git");
    print("--------------");
    GitHelper.clone(fullArgumentString);
  } else if (command == "deploy") {
    print("--------------");
    print("This command will do a deploy to website");
    print("--------------");
    Deploy.run(fullArgumentString);
  } else if (command == "check") {
    print("--------------");
    print("This command will Check Google Drive");
    print("--------------");
    GdriveCheck.run();
  } else if (command == "split") {
    print("--------------");
    print("This command will Split UI KIt Project");
    print("--------------");
    SpitGenerator.run();
  }
  //SNIPPET
  else if (command == "snippet") {
    print("--------------");
    print("This command will Generate Snippet");
    print("--------------");
    SnippetGenerator.generateSnippet();
  }
  //Booking Api Related
  else if (command == "bc_split") {
    print("--------------");
    print("This command will Split Booking Core Apps Project");
    print("--------------");
    BookingCoreSpitGenerator.run();
  } else if (command == "build_all") {
    print("--------------");
    print("This command will Build All APK for registered projects");
    print("--------------");
    BuildGenerator.run();
  } else if (command == "archive_all") {
    print("--------------");
    print("This command will Build All APK for registered projects");
    print("--------------");
    BuildGenerator.archiveAll();
  }
  //---------------
  else if (command == "switch") {
    print("--------------");
    print("This command will Switch Your App to Anoher App");
    print("--------------");
    SwitchGenerator.run(args[1]);
  } else if (command == "archive") {
    print("--------------");
    print("This command will Archive Current Project");
    print("--------------");
    ArchiveGenerator.run();
  } else if (command == "publish") {
    print("--------------");
    print("This command will Publish Current Project");
    print("--------------");
    Publisher.run();
  } else if (command == "rename") {
    print("--------------");
    print("This command will Rename Current Project Package/Name");
    print("--------------");
    // ArchiveGenerator.run();
  }
  //
  else {
    print("--------------");
    print("Yo");
    print("by Codekaze");
    print("--------------");
    print("Init Project");
    print("code: yox init");
    print("--------------");
    print("Create Module");
    print("code: yox module create [module_name]");
    print("example: yox module create product_list");
    print("example: yox module create product/product_list");
    print("--------------");
    print("Generate Icon");
    print("1. Update icon files in assets/icon/icon.png");
    print("2. Run > yox generate_icon");
    print("--------------");
    print("Remove Unused Import");
    print("1. Run > yox clean");
    print("--------------");
    print("Import all files to core.dart");
    print("1. Run > yox core");
    print("--------------");
    print("CvC");
  }
}
