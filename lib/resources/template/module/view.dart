import 'package:yox/shared/helper/name_parser/name_parser.dart';

class ModuleViewTemplate {
  static get(ParsedName m) {
    var template = '''
    import 'package:flutter/material.dart';
    ${m.controllerImportScript}
    import 'package:get/get.dart';

    class ExampleView extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return GetBuilder<ExampleController>(
          init: ExampleController(),
          builder: (controller) {
            controller.view = this;

            return Scaffold(
              appBar: AppBar(
                title: Text("ModuleTitle"),
              ),
            );
          },
        );
      }
    }
    ''';

    template = template.replaceAll("Example", m.className);
    template = template.replaceAll("example", m.fileName);
    template = template.replaceAll("ModuleTitle", m.title);

    return template;
  }
}
