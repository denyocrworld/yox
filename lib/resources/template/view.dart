var viewTemplate = '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var count = 0.obs;
  var nama = "Deniansyah";
  var alamat = "Bogor";

  updateName() {
    count++;
    nama = "SEs \${DateTime.now()}";
    update();
  }

  updateAlamat() {
    alamat = "Depok";
    update();
  }
}

class MainNavigationView extends StatelessWidget {
  final controller = Get.put(MainNavigationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainNavigationController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Test"),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\${controller.count} | \${controller.nama}"),
                Container(
                  child: FlatButton(
                    child: Text("Button"),
                    onPressed: () {
                      controller.updateName();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

''';
