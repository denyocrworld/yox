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

      generateDocumentation(docCodes);
      // ignore: avoid_print
      print("Snippet is Generated!");
    }
  }

  static getDocsByGroup(List docCodes, String groupName) {
    List items = docCodes.where((i) => i["group"] == groupName).toList();
    List docs = [];
    for (var i = 0; i < items.length; i++) {
      var prefix = items[i]["prefix"];

      docs.add("<li class='list-group-item group-item'>$prefix</li>");
    }
    List customList = [];

    if (groupName == "project_template") {
      customList.addAll([
        """
<div style="margin-bottom: 10px;">
<span style="color: red;">
Be careful, you should press this button when your project is still empty to avoid unwanted things. Because this command will generate main.dart, setup.dart, riverpod_util.dart and also update your pubspec.yaml
</span>
</div>
      <vscode-button class="title" style="background-color: #2B3E51 !important;color: #FFF !important">setState</vscode-button>
      <vscode-button class="item create-project" id="setstate_hyper_ui">Hyper UI</vscode-button>
      <vscode-button class="item create-project" id="setstate">Blank</vscode-button>
      <vscode-button class="item create-project" id="setstate_freezed">Blank Freezed</vscode-button>
      <vscode-button class="item create-project" id="setstate_fire">Firebase</vscode-button>
      <vscode-button class="item create-project" id="setstate_fire_freezed">Firebase Freezed</vscode-button>
      <vscode-button class="item create-project" id="setstate_goroute_freezed">Web GoRoute Freezed</vscode-button>
      
      <vscode-button class="title" style="background-color: #2B3E51 !important;color: #FFF !important">Getx</vscode-button>
      <vscode-button class="item create-project" id="getx">Blank</vscode-button>
      <vscode-button class="item create-project" id="getx_freezed">Blank Freezed</vscode-button>
      <vscode-button class="item create-project" id="getx_fire">Firebase</vscode-button>
      <vscode-button class="item create-project" id="getx_fire_freezed">Firebase Freezed</vscode-button>

      <vscode-button class="title" style="background-color: #2B3E51 !important;color: #FFF !important">Riverpod</vscode-button>
      <vscode-button class="item create-project" id="riverpod">Blank</vscode-button>
      <vscode-button class="item create-project" id="riverpod_freezed">Blank Freezed</vscode-button>
      <vscode-button class="item create-project" id="riverpod_fire">Firebase</vscode-button>
      <vscode-button class="item create-project" id="riverpod_fire_freezed">Firebase Freezed</vscode-button>      

      """,
      ]);
    }

    if (groupName == "utility") {
      customList.addAll([
        """
<div style="margin-bottom: 10px;">
<span style="color: red;">
[Experimental Mode]<br>
These features are still in experimental mode. We may remove it or replace it with something else.
</span>
</div>
      <vscode-button class="title" style="background-color: #2B3E51 !important;color: #FFF !important">Util</vscode-button>
      <vscode-button class="item" id="install-vscode-settings-json">.vscode-settings</vscode-button>
      <vscode-button class="item create_terminal" id="create_terminal_build_runner">Run build_runner</vscode-button>
      <vscode-button class="item create_terminal" id="create_terminal_firebase">Add Firebase</vscode-button>
      <vscode-button class="item create_terminal" id="create_terminal_freezed">Add Freezed</vscode-button>
      
      <vscode-button class="title" style="background-color: #2B3E51 !important;color: #FFF !important">Install Packages</vscode-button>

      <vscode-button class="item install-package">google_fonts</vscode-button>
      <vscode-button class="item install-package">geolocator</vscode-button>
      <vscode-button class="item install-package">permission_handler</vscode-button>
      <vscode-button class="item install-package">image_picker</vscode-button>
      <vscode-button class="item install-package">dio</vscode-button>
      <vscode-button class="item install-package">http</vscode-button>
      <vscode-button class="item install-package">intl</vscode-button>
      <vscode-button class="item install-package">path_provider</vscode-button>
      <vscode-button class="item install-package">freezed</vscode-button>
      <vscode-button class="item install-package">cached_network_image</vscode-button>
      <vscode-button class="item install-package">flutter_slidable</vscode-button>
      <vscode-button class="item install-package">sqflite</vscode-button>
      <vscode-button class="item install-package">hive</vscode-button>

      <vscode-button class="title" style="background-color: #2B3E51 !important;color: #FFF !important">AndroidManifest</vscode-button>
      <vscode-button class="item update-android-manifest-permission">INTERNET</vscode-button>
      <vscode-button class="item update-android-manifest-permission">READ_EXTERNAL_STORAGE</vscode-button>
      <vscode-button class="item update-android-manifest-permission">WRITE_EXTERNAL_STORAGE</vscode-button>
      <vscode-button class="item update-android-manifest-permission">ACCESS_BACKGROUND_LOCATION</vscode-button>
      <vscode-button class="item update-android-manifest-permission">ACCESS_FINE_LOCATION</vscode-button>
      <vscode-button class="item update-android-manifest-permission">ACCESS_COARSE_LOCATION</vscode-button>

      """,
      ]);
    }

    if (groupName == "wrap") {
      customList.addAll([
        "Wrap with InkWell <b class='float-right'>Alt+I</b>",
        "Wrap with Expanded - <b class='float-right'>Alt+E</b>",
        "Wrap with Padding - <b class='float-right'>Alt+P</b>",
        "Wrap with Container - <b class='float-right'>Alt+C</b>",
        "Wrap with SingleChildScrollView - <b class='float-right'>Alt+Shift+S</b>",
        "Wrap with ListView Vertical - <b class='float-right'>Alt+Shift+V</b>",
        "Wrap with ListView Horizontal - <b class='float-right'>Alt+Shift+H</b>",
        "Wrap in StreamBuilder Item List - <b class='float-right'>Alt+Shift+Q</b>",
        "Wrap in StreamBuilder Item Horizontal List - <b class='float-right'>Alt+Shift+W</b>",
      ]);
    }

    if (groupName == "margin_padding_sizedbox") {
      customList.addAll([
        "pa <i class='float-right'>padding: const EdgeInsets.all(n),</i>",
        "ma <i class='float-right'>margin: const EdgeInsets.all(n),</i>",
        "p1-p40 <i class='float-right'>Padding n</i>",
        "pt1-pt40 <i class='float-right'>Padding Top</i>",
        "pr1-pr40 <i class='float-right'>Padding Right</i>",
        "pb1-pb40 <i class='float-right'>Padding Bottom</i>",
        "pl1-pl40 <i class='float-right'>Padding Left</i>",
        "pv1-pv40 <i class='float-right'>Padding Vertical</i>",
        "ph1-ph40 <i class='float-right'>Padding Horizontal</i>",
        "plr1-plr40 <i class='float-right'>Padding Left-Right</i>",
        "ptb1-ptb40 <i class='float-right'>Padding Top-Bottom</i>",
        "m1-m40 <i class='float-right'>Margin n</i>",
        "mt1-mt40 <i class='float-right'>Margin Top</i>",
        "mr1-mr40 <i class='float-right'>Margin Right</i>",
        "mb1-mb40 <i class='float-right'>Margin Bottom</i>",
        "ml1-ml40 <i class='float-right'>Margin Left</i>",
        "mv1-mv40 <i class='float-right'>Margin Vertical</i>",
        "mh1-mh40 <i class='float-right'>Margin Horizontal</i>",
        "mlr1-mlr40 <i class='float-right'>Margin Left-Right</i>",
        "mtb1-mtb40 <i class='float-right'>Margin Top-Bottom</i>",
        "sh1-sh40 <i class='float-right'>SizedBox width:</i>",
        "sw1-sw40 <i class='float-right'>SizedBox height:</i>",
      ]);
    }

    if (groupName == "text") {
      customList.addAll([
        "texts <i class='float-right'>Text with TextStyle</i>",
        "text1-text40 <i class='float-right'>Text with FontSize</i>",
        "textb1-textb40 <i class='float-right'>Text with FontSize & Bold</i>",
        "fs1-fs40 <i class='float-right'>fontSize</i>",
        "bold <i class='float-right'>fontWeight: bold</i>",
        "cwhite <i class='float-right'>color: Colors.white</i>",
        "cblack <i class='float-right'>color: Colors.black</i>",
        "cgrey <i class='float-right'>color: Colors.grey</i>",
      ]);
    }

    for (var i = 0; i < customList.length; i++) {
      var code = customList[i];
      docs.add("""
      <li class='list-group-item group-item'>
        $code
      </li>
      """);
    }

    return docs.join("");
  }

  static generateDocumentation(List docCodes) {
    List groupList = [];
    List docList = [];
    for (var i = 0; i < docCodes.length; i++) {
      var item = docCodes[i]["group"];
      groupList.add(item);
    }
    groupList = groupList.toSet().toList();
    groupList.sort();

    List mainGroupList = [
      "project_template",
      "utility",
      "common",
      "margin_padding_sizedbox",
      "layout",
      "grid",
      "widget",
      "wrap",
      "container",
      "shape",
      "text",
      "heading",
      "button",
      "image",
      "icon",
      "circle_avatar",
      "textfield",
      "list_horizontal",
      "list_vertical",
      "list_item",
      "firebase",
      "general_shortcode",
      "class",
      "import",
      "dummy_util",
      "scaffold",
      "menu",
      "banner",
      "navigation_ui",
      "flutter_hyper_ui",
      "future",
      "view",
    ];

    for (var i = 0; i < groupList.length; i++) {
      var group = groupList[i];
      if (!mainGroupList.contains(group)) {
        mainGroupList.add(group);
      }
    }

    for (var n = 0; n < mainGroupList.length; n++) {
      var groupName = mainGroupList[n];
      String docs = getDocsByGroup(docCodes, groupName);

      docList.add("""
    <ul class="list-group">
      <li class="list-group-item active group-name $groupName" hide-item="true">$groupName</li>
       $docs
    </ul>
""");
    }

    // //---------
    var testFile = File("./index.html");
    var testMode = true;
    var file = File("${snippetProjectPath}\\src\\provider\\html.ts");

    var content = """

export class HtmlMaker {
    public static getHtml(toolkitUri, stylesUri,bootstrapUri,bootstrapJs, jqueryUri, mainUri) {
        return `

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="\${bootstrapUri}">
    <link rel="stylesheet" href="\${stylesUri}">

    <!-- @TEST_MODE -->
    
    <style>
    a {
      text-decoration: none;
    }
    </style>
</head>

<body style="font-size: 12px;">


<div class="main">

<div class="row mb-2">
  <div class="col-md-12">
  <h6 class="mb-2 mt-2">Flutter Hyper Extension</h6>
  <div class="mb-2 mt-2">by DenyOcr</div>
  <div class="p-1">
    <a href="https://www.youtube.com/channel/UCN2qPsTmvR56QsW89rUv1sg" target="_blank">
        <img 
          style="width: 24px;height: 24px;"
        src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAAC4ElEQVRoge2YT0hUQRzHP/PyX1rmJgbSqhhBB7sVGFFRFIR06GKH6GTdN7p4ibAg6hKRREiUBWFFdYkIi7oESZkgXYQoqGjdg6fN1t6qqPvr4Jrre7P5dmffpvA+MPD4zcxvft/9zc6b94OAgICAgIBVjPI6UA5SyzRhoBFFE9AAbAZC6VaTbhXpKWsznqeAyYznn8B4usURYljESBEFoswxqt4TNxIgYLGXUwjHUbQClV7FFogkwgcUD3hLrwLRDdIKkBbK2Mgz4LCvIXpF8QKbo2qYGWeXpZ0Q4hIrJXgAoY1KLuq6XBmQ/VQwxxiwwffAciNBkno1TDLT6M7ALLtYecEDVLOOVqdRt4W2FCGY/Eix1WnSCWguQij54kmAWQauvobmFiMXWREvAhRho0V2HoLejxDphqoC/5Us94+ry8B644VKSqE9Ao++QvtpsPSndR7UOQ06z1WFWo3qWohcg5tDsH23uT+hThxHv24LFU7AAtt2wI0BuPAYNjWYeCqjjbJMg1uA+CAAQCk4cAz6PkHHeSgtz89PnCUT/d1COiqqoKML7o3MC8qVNX9vuEC2u1AxEIHpyeXHObGWXuhKNENs5u/1/jBlw8Mr0HcZZqZznS3Uk8g0uAUobMQHASLwqg96OiE+lq+X3+oJc5kGtwDBztd7Vj4PQ3cERt6ZevrlNGTbQoUhPgZ3uuD5bUilzP0J406TTsCE8UKzM/C0B3rPgZ1YfrxXlJcMCDHvn/oaBvvh+hkY/WLgJAvCD6dJl4FvRot0HjGavgyu2HTvge9+RmCIKzadALMM+IuHDJQwiOa4WgEkmGTIaXQJUG+YAm4VJaRcUPQ4KxKQ7S4U5yzw0u+YcqAfm3O6jn+VFhX7OEmKE/+ttAiDCPcZ4G5OpUUdsocQFmFSNKEIowgjNKKoIUUNEEJRzeInaTmLopPAws1tIt0yC7yjCDEgiiLKLDGvxd2AgICAgIBVzR8UibLdyBYx4AAAAABJRU5ErkJggg==">
        Youtube
    </a>
    </div>
     <div class="p-1">
    <a href="https://chat.whatsapp.com/HijFMUeQx8A5fcIj0eJnSB" target="_blank">
        <img 
          style="width: 24px;height: 24px;"
          src="data:image/png;base64,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">
        Community
    </a>
    </div>
     <div class="p-1">
    <a href="https://discord.gg/CFBa4QbY" target="_blank">
        <img 
          style="width: 24px;height: 24px;"
          src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAAErElEQVRoge2YXWwUVRiGn+/sD6YsJiAqIBQ1EbVV/i6AmABt/I2iGCUNphUoBWMgwVophgtwIjFAgYIYNIZCUdJeNCKicuFPIr1BikE0ERKjiaFYFUUwsjR2y87nxW67s92ZZne7S4juczXnO+c7877nzJw5c6BAgQIFCvyfkWySrDYNhsKUAw+LMkOFu1RYUF8tR9LJ39KsZaIcAH5AOS7Cp4Ewn61aJT2ZasnIwNYmnSg+alWpAkYDZ1A+xPBReDjtVoVE0uln504dFglRpjBf4AngFuACsB+b7auXyZmcGmhs0lG2sAFhORAATqqy6fJZ3ht+O6PlCnMEpgMlCsXAOCAIjIx3cRGIAL8IdKpyCuFkENovdPLniIk8rcpaYBrQK/CWEV55sVr+GrKBbXu1SmE7sRG/KEptj5/DgSiVwLNx4SadgXDBBk4g7I8YWgM2D4ryBjBa4Q+E2vpqac3awJYmfUwMH8eLn6vypggLgfnAsCxFe9EDHFJoNcIKVR4CUJt59cvksFeSpwHLUn9oAqcQJgHfAeeBshyL9uILlBsQJgPfF4coraiQqFtDv1cPoWIqgUnx4j15EDkY5Y6hvbPzEguBFreGgz279TkWNRTWeFW4GtjSrGVAad7kZIowuaFZZ7tVuRoQ5bn8Ksocn/K8WzzlJbbe1qJQgN+B4XlXlQEC3bafm+oXyWVnPGUGRgR4nGtMPIBCkYny6MB4igGFBVdHUuaopmpLMtDWpj7g/qumKHMesCxN0pxU+PkS00jsX9LhS1uYFgxzndhMB47lKaePUUXFTHUGkj5kUSjPYHv6bThEmWMHetJq07mhS3wV/4LmKicJo5QDX/eXnZVimJuuehXWDdw+WxUSUWF9LnNSkGSNyS+xJk/PoPjocAsPg6M5zRmAwBRnud9AY5OOIvZjMST+EXz5zFEo3tii/e9pYgYM92ZyU9PLLLe4KDNzmeOGL5LYXPYbsNN8ifpQ4VWrTYPOmNWmQYENucxxw2cntCZWIeW2TDoBpoTCtDfs1ZXdwumQUEqYXTDoTGaTk4JKQqtzGR2XmX4AZhk4EVJA85qThMDYvmvjiI51bX0Noo7BNo6ol4HTQFeeNblxLn7vVNTNAIzx6KgE5RDKfrKe9IxQhXcRDgIlri3E5RES2OzZpbAC4QrKHIGDgOsP9hCJAu/bhtkCiscPTFzPpsSlg23NWqfK1oFxB6fFpgrDeYXFwJPEzoWyOqIkNtonDHxwJco7fuFG29AicLdne6WuvkZ2uBoAaGzWR2xlD96rkg3sMz7W1y2Wrh279eZeH7MMzFS4Q+HW+CpRBFwfz/kb6Fb4VeAngR9t6AhEOVa7XM5t3q3jfX42oCzC+6ChC6hZvVQ+cQZdR25ji4709/CawFK8D7AiwAFbaFhTLd94tBmUhmadamxeRniK2FGkGz0ITb1B1q2tlIsDKwed+s27dbzx8YLAM7jskwS6xTCjbomcysZA4z4tVZvjGputgXQhtBrD63WLxXMVTOvZtSw1oQncJ1CuwgygRGAMysqXamRfNuL72LZHlyDsUviN2LLZgXIkfJajliX2UPouUKBAgQL/ff4FA2+KbGRpDxIAAAAASUVORK5CYII=">
        Community
    </a>
   
    </div>
    <div class="p-1">
      <a href="https://github.com/denyocrworld/flutter-hyper-ui" target="_blank">
          <img 
          style="width: 24px;height: 24px;"
          src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAADTklEQVRoge2ZS0hUURjHf2NmE9nCNHsohoFR4SKKoSBatKtNTwgNV1FQYaugF0RBrSp7QFCTItHDoLK2Qas2LQqCII2ohB6KZBaWPUSdaXHuhZkz555zz9x7J6L5w7fw3HP///93nPPNd85AEUX834hFxBsH5gPlzt+jQD8wFpFeYFQBu4AuoA+YBNJSTAJvnTk7gcq/4lRCAriDWFnZsCnGnHdXFNw1UAfcszBrirtAbaHMtwDfQzTvxjegOUrjJcD5CIzLcYYIiksJcLUA5t3oDDuJcwU078bpsMy3aER6CWc/9AMfFONNQc3XaQzed+aUAhuBp5amx4FLQIPDUwtMSHNGCFiddKXysDS3FDgLpIDnQBI4DrQC+4FTQDcwBAwDaxR67xQ6t/M1n9CYTwP7PN6rMPDGNHNeKHRSwHIvshKN0AGDkTke418N76U1c+YqxmLAQQNnDqowtwfdtqQGVGu0fgOzVC95/Qc2AWUGwfq8bHpjoebZNESh8I1bmCvIyrxs6tGp0bxhQ9SnIUoDHaFZzsZsRE+k0nzjlyRObj2WY1mYriV0eGhOON6MqPcgcGModMvZaNZoL5AnqzZxuWIsEwMBDZrwUfNspjygSmDcIDDDyo49dAuY402VgOkjUgNMt3FkiQbNs2E/BDFEprp9sCGYRy0eemhOoO8csvDag8SNJ0RzJbMa0fuoNF/aEF3xIMmMk2G5dlAFvNLoJW3ItmmIMqMNc8vhB41Aj0GrxYawEvjlM4keYDviPGCLWsRx9adB4wfmNj0H7T4TcOMLcBPYA6wFpio4a4CtwDHgMeobPFW025oHWELuhtoLrEd9cnJjEtjtwVkNPPJp2o0UAVqXLolsFFiFaDdUh/A0cMLAWQG8t0igM1/zICrDoET4DFFCGxFtReazAfw1XE0+zX92PATCFgWxeyAvcxJZijgO+q1IZcAng/kUYr+EgqMS+fUQOB+gT+BICBpZaCN7dXYE5NNVuYsBuZWIIcpfZunrBa4hviWTiIswv0ii/tgcCs+yGusQm0u1cjY/VsgJDCL2W0EwD7hMbteaTwIpRKlUXptEjUWIa/cRx0zC4t0LiEVYHIEva8SBzYhvb7+YEpGXIooo4l/CH+SPSIFr9wg2AAAAAElFTkSuQmCC">
          Flutter Hyper UI
      </a>
    </div>
    <div class="p-1">
      <a href="https://javiercbk.github.io/json_to_dart/" target="_blank">
          <img 
          style="width: 24px;height: 24px;"
          src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAADfElEQVRoge2Y3WtbdRyHn5OTtGkSkyZt05eFpmPt6jJauhe1TAcqqw6982IXm+CN7sY/QPEv0H/AGxVUNhAvRNhgiopDFGVzy9Y0bUxwTddXs7ZJ06anJyfn/LzILHQdLmmynRbOcxM4Oefz+T78OC/8wMKiJqRHnRD965x4HMVCkj46evDC+7Xm2OoxTLU47H4kId67mXzzw1qzTBEItZ/HYQ/URcKcFZB9hNrfqYuEKQJQPwnTBKA+EqYKQO0SpgtAbRK7QgB2LrFrBGBnErtKALZLPOp8+5MY6kGSdz+oW9auW4FqsQTMxhIwG0vAbPa8wI5eZJ98HEMIwfl3BxECbkczTIwtsa7otLQ6OfHCPoLtTQAkE1miNzLkV1S8vkaOHg/S1+8H4MLn4+glwchrYbq6PAgBX34WB+Cttw9XNEvNKzA+tsS13xcA6A4/xb3MOt9dukNR1ZmazHP1p2kURaM77EVRNH7+cZqpdB6AYtFAVXVGo4ubeaqqo6p6xf01C0zfXQXg5EshRk6H6dnvY0PVmZ1ZI3arPNipV8K8+noPL5/qBiB2e3FrxlSeXHZjR/01fwu5XOWIVCJLMOhm5HR487/ffplDkqAz5AFg3/3f3LK6JcPRIDN6a5GTL4aq7q95BYaOBXG7HaSSOb66OEH0RgZdNwBQFA3ZbkO2lbefZLsNWZZQFG1LxqFIgFQyx8YDx5+IgNfbwBtn+hgcaqNUElz/Y4Erl9MIAeJhW2KStO14ZKAVSYL42FLV/RUJaFr5ZjMMsVku3d/TW7ynUChoDD/fyZmz/fiaG5mbWeOf+QJOp4xeMjCM8kW6ITB0A2eTvCW/0WnjYH8z8djy4xH49eosX3waJ5nIsrpaRAiBy+UA4MrlNN98nUJZ1/B4HLQGy49PRSnhDzgRAuZnCwAszBYQAvx+57aOgaEgxSqePv9R0U0cCntIJbP8eW2Bplh58P29PgAOHfZz83qGS99O0trmJP33CnaHjWC7i8hAC/NzBX74forOLhfzc+sARAZatnX4fA2Ee7ykJ1fqL9Db5yefK5KYWGZttcjTkQDPPNcBwLHjHdhsEonxLJN38vgDTp4d7sDtcXCgtxlNM4iPLjEzXcDjtjN8opMDvc0P7Rk80la1gGm705VypP/i/86457+FLAGzsQTMxhIwG0vAbCwBC4s9zr/ivGPQR1k6awAAAABJRU5ErkJggg==">
          Json to Dart
      </a>
    </div>
    <div class="p-1">
      <a href="https://saweria.co/denyocr" target="_blank">
        <img 
          style="width: 24px;height: 24px;"
          src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAABmJLR0QA/wD/AP+gvaeTAAAEjElEQVRoge2YX2zTVRTHP7f9tSvdOtZ1bGODQIQQiWLYkCGYZWBiBCOI0ch0JkNCDBEfnDwY2ZOJQUmIhAR5gESnhgBq8F+WRZ+o8Q9MymSOBMeGgszBZP9C6Nquv14funal7VjvDdt86Pfpd3/3nHPP95x7zz2/H2SRRRZZzCSEivCmiooyrGbPVDkDYEhb2UmfrzdTeYuKcWGYK9RdUsOoDCutoURASqacgLDIh1XklQiAmnEtKAZJkQCVivLqECgFKaNDvPv59XukZBdg13JKHSGk2PfuFy2NkwlmlIFpdh7AjpC7MhHMdAtNp/Mx5GQipHoG/ndQusik134axKqpcmZslTOiJvRIptKqGehSlFeH5JKKuCIBy9QTEGpBUiQQUYqOJqYwAxbrNGRAKq1hqFkf6Zysul3rc+D1eei47OLmYLT6FrlDPHjfLWpW9DOvODCJR6NKBJSqEID0OvpBFia/D5uCoy3ldP6zgPpt61h4fxX2vPkAhG5d5a+LrTR9eIql86/wwhM9GFaZznq/qAkVTTWBMyCrkp3f9+kilq9aw/raBrA60yubflqOv0976y/seqk7DQm1EgpaF1nqQT7aUh51vm73xM4DWJ1sqGvkoarVHPuuLHVesYSC8hmAaCkdj9y1Pkd02zQ2EEvo8MAQ3544yaULFwFYvHQJ65/dxJzSYkCwobaBt17tpqevn/LEM6FYQkEnA0mLeH0e6reti0d+eGCIA2/vpcN3nmAgSDAQ5ELb7xzas5/hgaGokjWXrS+vxdvmSbauTEA5Ax99U2r76lR+fOxyOni0tjo+/uzjY/hv+1P0Rvx+Pv/kONtf3wGA3VNN84/NnPg+Ly6zsXrQDn8r+aOcgRxjxHuHAQElZSXx8ZXO7gl1r3aOB7h03lwsSau7coM/qPqjTKDuvRuXJQzExjK5jom7FLaEOSnvVJYwUPtO38TsJ4BWO+3IscW/D2QErvdcj8/NX7RwQr0FSxbHn2/09BKR48Ug0aYKtAhYLcbN2POoaXKu1Ref27jlGew5jhSdnFmz2Pzic/Gxr/Us4bCZaPNfLV90lJ5as9Jd5C5YO6fQjcvp5M+ubh7b8DiGYeDKd1G5eiXDg8MMDwxhGAYPVCyj/rXtuD3RCzwwEuDI/kO4Z+dT4vEwp9DN7LzcAz9d+MM7ydIp0LgHICIjl8RYzTcMg9u3/DR9cIRX3tiJEILZhQXU7diaVldKSdPBw5ihELaETAmL0Op0tQhYheiKJHQB+S4XZ39uBaB+53YcjtQtBNHINx08jO/0r3gK3HfMSVNodbpaBKQl3Ik5rioQFLoL+K3VR8f5dp7cvJFllcspnlsMQF9vH+3n2mj5shkzFIo6n1StRrFpEVBu5mJ4c8vT/UBqVxoO4w+MEAyGMM0wAFargd1uw+l0YrOmiZmgf+/xr5W60Bi0MjC2aBeSquTXhmGQn+eCvHRKE0Dqf2tr/1YRGp3jXYxp29L/LyT0Dl06yMgMZEBGIvfu+1ijjY5Bm4BFs26nRcQy/VsoYNrvGQHdEppFFllkMfP4D7CqaZuRGe7hAAAAAElFTkSuQmCC">
        Donation / Support
      </a>
    </div>
  </div>
</div>

<div class="row">
  <div class="col-md-12">
    ${docList.join("<br/>")}
  </div>
</div>

</div>

<div style="height: 140px;"></div>
    <script src="\${jqueryUri}"></script>
    <script type="module" src="\${toolkitUri}"></script>
    <script type="module" src="\${bootstrapJs}"></script>
    <script type="module" src="\${mainUri}"></script>

    <script>
    \$(function(){

      \$(".group-name").each(function(){
        \$(this).click(function(){
          if(\$(this).attr("hide-item")!="true"){
            \$(this).parent().find(".group-item").hide(); 
            \$(this).attr("hide-item","true");
            \$(this).css("background-color","grey !important");
          }
          else {
            \$(this).parent().find(".group-item").show();
            \$(this).attr("hide-item","false");
            \$(this).css("background-color","blue !important");
          }
            
        });
      });

      \$(".group-item").hide();
      
    });
    </script>

    <style>
    body {
      background: #252526;
      color: #FFF;
    }
    a {
      color: #dcdc8b;
    }
    .list-group-item {
      background-color: #3c3c3c !important;
      color: #FFF !important;
      border-radius: 0px solid transparent !important;
      border: 0px solid transparent !important;
    }
    .list-group-item.active {
      background-color: #0e639c !important;
    }
    .list-group-item.project_template {
      background-color: #EA820C !important;
    }
     .list-group-item.utility {
      background-color: #009B77 !important;
    }
    .getx {
      background-color: #BDC3C7 !important;
      float: left;
      width: 46%;
      font-size: 10px !important;
      color: #000;
    }

    .riverpod {
      background-color: #BDC3C7 !important;
      float: right;
      width: 46%;
      font-size: 10px !important;
      color: #000;
    }

    .title {
      background-color: #2B3E51 !important;
      float: left;
      width: 100%;
      font-size: 10px !important;
      color: #000;
    }

    .item {
      background-color: #BDC3C7 !important;
      float: left;
      width: 100%;
      font-size: 10px !important;
      color: #000;
    }

    .float-left {
      float: left;
    }
     .float-right {
      float: right;
    }

    vscode-button {
      width: 100%;
      margin-bottom: 6px;
    }
    </style>
    
</body>

</html>

`;

    }
}
""";

    file.writeAsStringSync(content);
    testFile.writeAsStringSync(content.replaceAll(
        "<!-- @TEST_MODE -->",
        testMode != true
            ? ""
            : """
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css"/>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>

    
    
"""));
  }
}
