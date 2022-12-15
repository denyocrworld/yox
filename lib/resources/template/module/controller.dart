import 'package:yox/shared/helper/name_parser/name_parser.dart';

class ModuleControllerTemplate {
  static get(ParsedName m) {
    var template = '''
    import 'package:get/get.dart';
    ${m.viewImportScript}

    class ExampleController extends GetxController {
      ExampleView view;
      
      @override
      void onInit() {
        super.onInit();
      }

      @override
      void onReady() {
        super.onReady();
      }

      @override
      void onClose() {
        super.onClose();
      }
    }
    ''';

    template = template.replaceAll("Example", m.className);
    template = template.replaceAll("example", m.fileName);

    return template;
  }
}
