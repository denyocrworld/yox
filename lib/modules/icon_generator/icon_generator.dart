import 'package:yox/shared/helper/exec/exec.dart';

class IconGenerator {
  static create() async {
    exec("flutter pub get");
    exec("flutter pub run flutter_launcher_icons:main");

    writeSeparator();
    writeSeparator();
    print("Update Icon Completed");
    writeSeparator();
    writeSeparator();
  }
}
