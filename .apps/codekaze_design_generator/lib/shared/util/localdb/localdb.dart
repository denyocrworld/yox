import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class LocalDatabase {
  static dynamic db = {};
}

class LocalDB {
  Box storage;

  add(
    String key,
    Map value,
  ) {
    print("Add To LocalDB: ${uuid.v4()}");
    print("Value: $value");
    print("---------------");

    var documentId = uuid.v4();
    print("key: $key");
    print("value: $value");
    print("---");
    print("value is List : ${value is List}");
    print("value is Map : ${value is Map}");
    value["id"] = documentId;

    if (LocalDatabase.db["$key"] == null) LocalDatabase.db["$key"] = [];

    LocalDatabase.db["$key"].add(value);
    return documentId;
  }

  bool update(
    String key,
    String documentId,
    Map value,
  ) {
    print("Update To LocalDB: ${uuid.v4()}");
    print("Document ID: $documentId");
    print("Value: $value");
    print("---------------");

    if (LocalDatabase.db["$key"] == null) LocalDatabase.db["$key"] = [];

    var search =
        LocalDatabase.db[key].where((i) => i["id"] == documentId).toList();

    if (search.isNotEmpty) {
      var index = LocalDatabase.db[key].indexOf(search[0]);

      value.forEach((key, rowValue) {
        search[0][key] = rowValue;
      });
      LocalDatabase.db[key][index] = search[0];
      return true;
    }
    return false;
  }

  bool delete(
    String key,
    String documentId,
  ) {
    print("Delete From LocalDB: ${uuid.v4()}");
    print("Document ID: $documentId");
    print("---------------");

    if (LocalDatabase.db["$key"] == null) LocalDatabase.db["$key"] = [];

    var search =
        LocalDatabase.db[key].where((i) => i["id"] == documentId).toList();

    if (search.isNotEmpty) {
      var index = LocalDatabase.db[key].indexOf(search[0]);
      LocalDatabase.db[key].removeAt(index);
      print("DELETE ENTRIES SUCCESS!");
      return true;
    }
    print("DELETE ENTRIES FAILED!");
    return false;
  }

  Future save() async {
    var decoded = jsonEncode(LocalDatabase.db);
    await storage.put("my_storage", decoded);
  }

  Future load() async {
    print("load Hive Storage");
    if (!kIsWeb) {
      var appDocDir = await getApplicationDocumentsDirectory();
      storage = await Hive.openBox("myBox", path: appDocDir.path);
    } else {
      storage = await Hive.openBox("myBox");
    }
    print("::#1");
    var decodedString = storage.get("my_storage");
    print("::#2");
    if (decodedString != null) {
      LocalDatabase.db = jsonDecode(decodedString);
    }
    print("Done..");
  }

  LocalDbCollection collection(String collectionName) {
    return LocalDbCollection(
      collectionName: collectionName,
    );
  }
}

class LocalDbCollection {
  String collectionName;
  LocalDbCollection({
    this.collectionName,
  });

  get() {
    List values = LocalDatabase.db[collectionName];
    if (values == null) return [];

    return values;
  }

  Future add(values) async {
    var result = db.add(collectionName, values);
    await db.save();
    return result;
  }

  LocalDbCollectionWhere where(
    String field, {
    dynamic isEqualTo,
    dynamic isGreaterThan,
    dynamic isLessThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic isLessThanOrEqualTo,
  }) {
    return LocalDbCollectionWhere(
      collectionName: collectionName,
      field: field,
      isEqualTo: isEqualTo,
      isGreaterThan: isGreaterThan,
      isLessThan: isLessThan,
      isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
      isLessThanOrEqualTo: isLessThanOrEqualTo,
    );
  }

  LocalDbDocument doc(String documentId) {
    return LocalDbDocument(
      collectionName: collectionName,
      documentId: documentId,
    );
  }
}

class LocalDbCollectionOrderBy extends LocalDbCollection {}

class LocalDbCollectionWhere {
  String collectionName;
  String field;

  dynamic isEqualTo;
  dynamic isGreaterThan;
  dynamic isLessThan;
  dynamic isGreaterThanOrEqualTo;
  dynamic isLessThanOrEqualTo;

  LocalDbCollectionWhere({
    this.collectionName,
    this.field,
    this.isEqualTo,
    this.isGreaterThan,
    this.isLessThan,
    this.isGreaterThanOrEqualTo,
    this.isLessThanOrEqualTo,
  });

  List get() {
    List values;
    if (LocalDatabase.db[collectionName] == null) return [];

    if (isEqualTo != null) {
      values = LocalDatabase.db[collectionName]
          .where((i) => i[field] == isEqualTo)
          .toList();
    } else if (isGreaterThan != null) {
      print("Select Where GreaterThan");
      values = LocalDatabase.db[collectionName]
          .where((i) =>
              double.parse("${i[field]}") > double.parse("$isGreaterThan"))
          .toList();
    } else if (isLessThan != null) {
      values = LocalDatabase.db[collectionName]
          .where(
              (i) => double.parse("${i[field]}") < double.parse("$isLessThan"))
          .toList();
    } else if (isGreaterThanOrEqualTo != null) {
      values = LocalDatabase.db[collectionName]
          .where((i) =>
              double.parse("${i[field]}") >=
              double.parse("$isGreaterThanOrEqualTo"))
          .toList();
    } else if (isLessThanOrEqualTo != null) {
      values = LocalDatabase.db[collectionName]
          .where((i) =>
              double.parse("${i[field]}") <=
              double.parse("$isLessThanOrEqualTo"))
          .toList();
    }
    return values ?? [];
  }

  Future add(values) async {
    var result = db.add(collectionName, values);
    await db.save();
    return result;
  }

  LocalDbDocument doc(String documentId) {
    return LocalDbDocument(
      collectionName: collectionName,
      documentId: documentId,
    );
  }
}

class LocalDbDocument {
  String collectionName;
  String documentId;

  LocalDbDocument({
    this.collectionName,
    this.documentId,
  });

  List get() {
    List values;
    if (LocalDatabase.db[collectionName] == null) return [];

    values = LocalDatabase.db[collectionName]
        .where((i) => i["id"] == documentId)
        .toList();

    return values ?? [];
  }

  Future<bool> update(dynamic value) async {
    var result = db.update(
      collectionName,
      documentId,
      value,
    );
    await db.save();
    return result;
  }

  Future<bool> delete() async {
    var result = db.delete(
      collectionName,
      documentId,
    );
    await db.save();
    return result;
  }
}

var db = LocalDB();
