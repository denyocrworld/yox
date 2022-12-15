import 'package:yox/resources/session/package_info.dart';

class ModulePath {
  String moduleDir;
  String viewPath;
  String controllerPath;
  String widgetDir;

  ModulePath({
    this.moduleDir,
    this.viewPath,
    this.controllerPath,
    this.widgetDir,
  });
}

class ParsedName {
  String className;
  String variableName;
  String fileName;
  String controllerName;
  String viewName;
  String controllerFileName;
  String viewFileName;
  String controllerImportScript;
  String viewImportScript;
  String title;
  ModulePath path;

  ParsedName({
    this.className,
    this.variableName,
    this.fileName,
    this.controllerName,
    this.viewName,
    this.controllerFileName,
    this.viewFileName,
    this.controllerImportScript,
    this.viewImportScript,
    this.title,
    this.path,
  });
}

class NameParser {
  static ParsedName parseModuleName(String moduleQuery) {
    var moduleName = "";
    var group = "";

    if (moduleQuery.contains("/")) {
      moduleName = moduleQuery.split("/")[1];
      group = moduleQuery.split("/")[0];
    } else {
      moduleName = moduleQuery;
    }

    String className = getClassName(moduleName);
    String variableName = getVariableName(moduleName);
    String fileName = getFileName(moduleName);
    String controllerName = getControllerName(moduleName);
    String viewName = getViewName(moduleName);
    String controllerFileName = getControllerFileName(moduleName);
    String viewFileName = getViewFileName(moduleName);

    String controllerImportScript = getControllerImportScript(
      moduleName: moduleName,
      group: group,
    );
    String viewImportScript = getViewImportScript(
      moduleName: moduleName,
      group: group,
    );

    String title = getTitle(moduleName);

    return ParsedName(
      className: className,
      variableName: variableName,
      fileName: fileName,
      controllerName: controllerName,
      viewName: viewName,
      controllerFileName: controllerFileName,
      viewFileName: viewFileName,
      controllerImportScript: controllerImportScript,
      viewImportScript: viewImportScript,
      title: title,
      path: ModulePath(
        moduleDir: PathParser.getModuleDir(
          moduleName: moduleName,
          group: group,
        ),
        viewPath: PathParser.getViewPath(
          moduleName: moduleName,
          group: group,
        ),
        controllerPath: PathParser.getControllerPath(
          moduleName: moduleName,
          group: group,
        ),
        widgetDir: PathParser.getWidgetDir(
          moduleName: moduleName,
          group: group,
        ),
      ),
    );
  }

  static getClassName(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i][0].toUpperCase() + arr[i].substring(1);
    }
    return arr.join("");
  }

  static getVariableName(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i][0].toLowerCase() + arr[i].substring(1);
    }
    return arr.join("");
  }

  static getFileName(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i].toLowerCase();
    }
    return arr.join("_");
  }

  static getControllerFileName(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i].toLowerCase();
    }
    return arr.join("_") + "_controller.dart";
  }

  static getViewFileName(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i].toLowerCase();
    }
    return arr.join("_") + "_view.dart";
  }

  static getControllerName(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i][0].toUpperCase() + arr[i].substring(1);
    }
    return arr.join("") + "Controller";
  }

  static getViewName(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i][0].toUpperCase() + arr[i].substring(1);
    }
    return arr.join("") + "View";
  }

  static getTitle(String moduleName) {
    var arr = moduleName.split("_");
    for (var i = 0; i < arr.length; i++) {
      arr[i] = arr[i][0].toUpperCase() + arr[i].substring(1);
    }
    return arr.join(" ");
  }

  static getControllerImportScript({
    String moduleName,
    String group,
  }) {
    if (group.isNotEmpty) group = group + "/";
    return '''
      import 'package:${packageName}/module/$group${moduleName}/controller/${moduleName}_controller.dart';
    ''';
  }

  static getViewImportScript({
    String moduleName,
    String group,
  }) {
    if (group.isNotEmpty) group = group + "/";
    return '''
      import 'package:${packageName}/module/$group${moduleName}/view/${moduleName}_view.dart';
    ''';
  }
}

class PathParser {
  static getViewPath({
    String moduleName,
    String group,
  }) {
    if (group.isNotEmpty) group = group + "/";
    return "lib/module/$group$moduleName/view/${moduleName}_view.dart";
  }

  static getControllerPath({
    String moduleName,
    String group,
  }) {
    if (group.isNotEmpty) group = group + "/";
    return "lib/module/$group$moduleName/controller/${moduleName}_controller.dart";
  }

  static getWidgetDir({
    String moduleName,
    String group,
  }) {
    if (group.isNotEmpty) group = group + "/";
    return "lib/module/$group$moduleName/widget/";
  }

  static getModuleDir({
    String moduleName,
    String group,
  }) {
    if (group.isNotEmpty) group = group + "/";
    return "lib/module/$group$moduleName/";
  }
}
