import 'dart:convert';
import 'dart:io';

class SnippetGenerator {
  static String snippetProjectPath =
      r"C:\Users\denyo\Documents\FLUTTER_PROJECT\flutter-hyper-extension-vscode";
  static String command = "";
  static String value = "";
  static String packageName = "";
  static String currentGroupTemplate;

  static generateSnippet() async {
    var dir = Directory("./lib");
    var dirs = dir.listSync(
      recursive: true,
    );

    List codes = [];
    List docCodes = [];
    List code = [];
    String prefix = "";
    bool read = true;

    for (var file in dirs) {
      if (file is File) {
        String path = file.path;
        path = path.toString().replaceAll("\\", "/");

        String content = File(path.toString()).readAsStringSync();
        if (content.indexOf("#SKIP_TEMPLATE") > -1) continue;

        var lines = content.split("\n");
        for (var i = 0; i < lines.length; i++) {
          var line = lines[i];

          if (line.contains("#GROUP_TEMPLATE")) {
            currentGroupTemplate = line.split(" ").last.trim();
          }

          if (line.contains("#TEMPLATE")) {
            //start
            prefix = line.split(" ").last.trim();
            code = [];
            read = true;
          } else if (line.contains("#END")) {
            //end

            for (var i = 0; i < code.length; i++) {
              code[i] = code[i].toString().replaceAll('"', '\\"').trim();
              code[i] = code[i].toString().replaceAll('\\\$', '\\\\\$').trim();

              code[i] = code[i].toString().replaceAll(r'"$', r'"\\$').trim();
              code[i] = code[i].toString().replaceAll(r"'$", r"'\\$").trim();
              code[i] = code[i].toString().replaceAll(r" $", r" \\$").trim();
              code[i] = code[i].toString().replaceAll(r":$", r":\\$").trim();

              code[i] = code[i].toString().replaceAll("CURSOR_1", "\$1");
              code[i] = code[i].toString().replaceAll("CURSOR_2", "\$2");

              if (i == code.length - 1 &&
                  !code[i].toString().contains("CURSOR_")) {
                code[i] = "\"${code[i]}\$100\"";
              } else {
                code[i] = "\"${code[i]}\",";
              }
            }

            if (code.indexOf("#TEMPLATE") > -1 ||
                code.indexOf("#GROUP_TEMPLATE") > -1) {
              print("Invalid Snippet with prefix ${prefix}");
              exit(0);
            }

            codes.add("""            
            "${prefix.trim()}": {
                "prefix": "${prefix.trim()}",
                "body": [
                    ${code.join("\n").trim()}
                ]
            }
          """);

            if (currentGroupTemplate != "skip_docs") {
              var currentList =
                  docCodes.where((i) => i["prefix"] == prefix.trim()).toList();
              if (currentList.isNotEmpty) {
                print("Duplicates snippet: $prefix");
                print("path: $path");
                exit(0);
              }

              docCodes.add({
                "prefix": prefix.trim(),
                "group": "$currentGroupTemplate",
              });
            }

            read = false;
          } else {
            if (read) {
              code.add(line);
            }
          }
        }

        File(path.toString()).writeAsStringSync(lines.join("\n"));
      }
      if (file is Directory) {}
    }

    if (File("c:/yo/owner.txt").existsSync()) {
      var templateJsonFile =
          File("$snippetProjectPath\\snippets\\template.json");
      templateJsonFile.writeAsStringSync("""
{
  ${codes.join(",\n")}
}
""");

      var codeList = [];
      for (var c = 0; c < codes.length; c++) {
        codeList.add("""{
        ${codes[c]}
    }""");
      }
      var docsTsFile = File("${snippetProjectPath}\\src\\docs\\docs.ts");
      docsTsFile.writeAsStringSync("""
var obj = [
  ${jsonEncode(docCodes.join(",\n"))}
];
""");

      // ignore: avoid_print
      print("Snippet is Generated!");
    }
  }
}
