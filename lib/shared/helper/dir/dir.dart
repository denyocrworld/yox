import 'dart:io';

File dir(String path) {
  var dir = Directory.current;
  var dirPath = dir.path.replaceAll("'", "");
  var file = File("${dirPath}\\$path");
  return file;
}
