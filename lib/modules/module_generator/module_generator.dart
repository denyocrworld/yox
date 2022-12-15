import 'dart:io';
import 'package:yox/core.dart';
import 'package:yox/resources/template/module/controller.dart';
import 'package:yox/resources/template/module/view.dart';
import 'package:yox/shared/helper/name_parser/name_parser.dart';
import 'package:yox/shared/helper/template/template.dart';

class ModuleGenerator {
  static create(moduleName) async {
    var m = NameParser.parseModuleName(moduleName);

    if (Directory(m.path.moduleDir).existsSync() == true) {
      print("This module already exists");
      return;
    }

    await Template.create(m.path.viewPath, ModuleViewTemplate.get(m));
    await Template.create(
        m.path.controllerPath, ModuleControllerTemplate.get(m));

    //! [Deprecreated - Remove generated_router.dart Support]
    // if (File("lib/xgenerated/generated_router.dart").existsSync()) {
    //   await Template.appendCodeBeforeTag(
    //     fileName: "lib/xgenerated/generated_router.dart",
    //     tag: "//@EndOfImport",
    //     code: m.viewImportScript,
    //     validator: m.viewImportScript,
    //     disableFormat: true,
    //   );
    // }

    // if (File("lib/xgenerated/generated_router.dart").existsSync()) {
    //   await Template.appendCodeBeforeTag(
    //     fileName: "lib/xgenerated/generated_router.dart",
    //     tag: "//@EndOfRouterName",
    //     code: '''
    //     static const String ${m.variableName}View = '/module/${m.fileName}';
    //   ''',
    //     validator: "String ${m.variableName}View =",
    //     disableFormat: true,
    //   );

    //   await Template.appendCodeBeforeTag(
    //     fileName: "lib/xgenerated/generated_router.dart",
    //     tag: "//@EndOfRouterItem",
    //     code: '''
    //     RouteItem(
    //       routeName: ${m.variableName}View,
    //       layout: ${m.viewName}(),
    //     ),
    //   ''',
    //     validator: "routeName: ${m.variableName}View",
    //     disableFormat: true,
    //     tabCount: 2,
    //   );

    // await Template.format("lib/xgenerated/generated_router.dart");

    //! End of Deprecreated

    // await Template.appendCodeBeforeTag(
    //   fileName: "lib/xgenerated/generated_sidebar_menu.dart",
    //   tag: "//@EndOfMenuList",
    //   code: '''
    //   Menu(
    //     title: '${m.title}',
    //     icon: Icons.tune,
    //     navRoute: GeneratedRouter.${m.variableName}View,
    //   ),
    // ''',
    //   validator: "GeneratedRouter.${m.variableName}View",
    // );
  }
}
