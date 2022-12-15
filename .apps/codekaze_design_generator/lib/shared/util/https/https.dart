import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Https {
  defaultHeader() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }

  Future<http.Response> get({
    String url,
    Map<String, String> headers,
  }) async {
    var response = await http.get(
      Uri.parse(url),
      headers: headers ?? defaultHeader(),
    );

    print("---------");
    print("[GET]    ");
    print(url);
    print("---------");
    print("Headers:");
    print(defaultHeader());
    print("---------");
    print("Response:");
    print(response.body.length > 200 ? "BIG DATA" : response.body);
    print("---------");

    return response;
  }

  Future<http.Response> post({
    String url,
    dynamic data,
    Map<String, String> headers,
  }) async {
    var response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: headers ?? defaultHeader(),
    );

    print("---------");
    print("[POST]");
    print(url);
    print("---------");
    print("Headers:");
    print(defaultHeader());
    print("---------");
    print("Data:");
    print(data);
    print("---------");
    print("Response:");
    print(response.body);
    print("---------");

    return response;
  }

  Future<http.Response> put({
    String url,
    dynamic data,
    Map<String, String> headers,
  }) async {
    var response = await http.put(
      Uri.parse(url),
      body: json.encode(data),
      headers: headers ?? defaultHeader(),
    );

    print("---------");
    print("[PUT]");
    print(url);
    print("---------");
    print("Headers:");
    print(defaultHeader());
    print("---------");
    print("Data:");
    print(data);
    print("---------");
    print("Response:");
    print(response.body);
    print("---------");

    return response;
  }

  Future<http.Response> delete({
    String url,
    dynamic data,
    Map<String, String> headers,
  }) async {
    var response = await http.delete(
      Uri.parse(url),
      body: json.encode(data),
      headers: headers ?? defaultHeader(),
    );

    print("---------");
    print("[DELETE]");
    print(url);
    print("---------");
    print("Headers:");
    print(defaultHeader());
    print("---------");
    print("Data:");
    print(data);
    print("---------");
    print("Response:");
    print(response.body);
    print("---------");

    return response;
  }

  Future<StreamedResponse> uploadFile({
    @required File file,
    @required String name,
    @required String url,
    Map headers,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath(
      '$name',
      file.path,
    ));

    if (headers != null) {
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    return response;
  }
}

extension MirrorUrlExtension on String {
  String get mirror {
    var value = this;
    var mirrorUrl = "http://35.227.79.23:3000/mirror?url=";
    return "$mirrorUrl$value";
  }
}

var https = Https();
