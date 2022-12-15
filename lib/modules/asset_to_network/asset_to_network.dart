import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

extension StringCleaner on String {
  clean() {
    var value = this;
    value = value.replaceAll("\\", "/");
    value = value.replaceAll("./", "");
    return value;
  }
}

class AssetToNetwork {
  static void testUpload() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://capekngoding.com/upload.php'),
      );

      request.fields.addAll({'key': 'upload-from-err45'});
      request.files.add(await http.MultipartFile.fromPath(
          'file', 'C:/Users/denyo/OneDrive/Desktop/capek_ngoding.jpg'));

      http.StreamedResponse response = await request.send();
      var data = jsonDecode(await response.stream.bytesToString());
      print(data["data"]["url"]);
      print("Success?:");
    } on Exception catch (_) {
      //----
      print("ERROR");
      print(_.toString());
    }

    exit(0);
  }

  static Future<String> uploadFile(path) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://capekngoding.com/upload.php'),
      );

      request.fields.addAll({'key': 'upload-from-err45'});
      request.files.add(await http.MultipartFile.fromPath('file', path));

      http.StreamedResponse response = await request.send();
      var data = jsonDecode(await response.stream.bytesToString());
      print(data["data"]["url"]);
      print("Success?:");

      return data["data"]["url"];
    } on Exception catch (_) {
      //----
      print("ERROR");
      print(_.toString());
    }
    return null;
  }

  static void run() async {
    var dir = Directory("./assets");
    var dirs = dir.listSync(
      recursive: true,
    );

    for (var file in dirs) {
      if (file is File) {
        var path = file.path.toString().clean();
        String format1 = '"${path}"';
        String format2 = "'${path}'";
        String format3 = '"./${path}"';
        String format4 = "'./${path}'";

        String newSource = await uploadFile(file.path);

        findInLin([
          '${path}',
          './${path}',
        ], newSource);
      }
      if (file is Directory) {}
    }
  }

  static void findInLin(List<String> values, String newSource) {
    var dir = Directory("./lib");
    var dirs = dir.listSync(
      recursive: true,
    );

    for (var file in dirs) {
      if (file is File) {
        var content = File(file.path).readAsStringSync();
        content = content.replaceAll("AssetImage", "NetworkImage");
        content = content.replaceAll("Image.asset", "Image.network");
        content = content.replaceAll("SvgPicture.asset", "SvgPicture.network");

        for (var i = 0; i < values.length; i++) {
          var key = values[i];

          if (content.contains(key)) {
            content = content.replaceAll(key, newSource);
          }
        }

        File(file.path).writeAsStringSync(content);
      }
    }
  }
}
