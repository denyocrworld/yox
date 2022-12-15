import 'package:design_generator/core.dart';
import 'package:design_generator/module/home/widget/feature_box.dart';
import 'package:design_generator/shared/widget/downloadable/downloadable.dart';
import 'package:flutter/material.dart';
import 'package:design_generator/module/home/controller/home_controller.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:screenshot/screenshot.dart';

class HomeView extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    controller.view = this;

    return GetBuilder<HomeController>(
      builder: (_) {
        var sidePadding = 60.0;
        var spacing = 20.0;
        var w = 760;
        var boxWidth = (w - (sidePadding * 2) - (spacing * 3)) / 4;
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Design Generator"),
              actions: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () => controller.generate(),
                    child: Text("Generate"),
                  ),
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
            ),
            body: Column(
              children: [
                Container(
                  color: Colors.grey[900],
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Wrap(
                      runSpacing: 10.0,
                      spacing: 10.0,
                      children: List.generate(39, (index) {
                        return InkWell(
                          onTap: () {
                            controller.imageIndex = index;
                            controller.update();
                          },
                          child: Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/image/gradient/$index.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Downloadable(
                                                id: "icon",
                                                child: Container(
                                                  width: 120,
                                                  height: 120,
                                                  constraints: BoxConstraints(
                                                      maxWidth: 120.0,
                                                      maxHeight: 120.0),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/image/gradient/${controller.imageIndex}.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${controller.iconName}",
                                                        style: TextStyle(
                                                          fontSize: 60.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Downloadable(
                                                id: "preview",
                                                child: Container(
                                                  width: Get.width,
                                                  constraints: BoxConstraints(
                                                    maxWidth: 900.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/image/gradient/${controller.imageIndex}.png"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        right: 20.0,
                                                        top: 30.0,
                                                        child: Container(
                                                          height: 460.0,
                                                          width: 240.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                "assets/image/gradient/phone_frame.png",
                                                              ),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 270.0,
                                                        top: 20.0,
                                                        child: Container(
                                                          height: 460.0,
                                                          width: 240.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                "assets/image/gradient/phone_frame.png",
                                                              ),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 30.0,
                                                        top: 60.0,
                                                        child: Text(
                                                          "${controller.promotionalTag}",
                                                          style: TextStyle(
                                                            fontSize: 30.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 30.0,
                                                        top: 90.0,
                                                        child: Text(
                                                          "${controller.applicationName1}",
                                                          style: TextStyle(
                                                            fontSize: 50.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 30.0,
                                                        top: 140.0,
                                                        child: Text(
                                                          "${controller.applicationName2}",
                                                          style: TextStyle(
                                                            fontSize: 50.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 30.0,
                                                        top: 200.0,
                                                        child: Text(
                                                          "Flutter + Getx",
                                                          style: TextStyle(
                                                            fontSize: 26.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        child: Container(
                                                          height: 70.0,
                                                          width: 300.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      100.0),
                                                            ),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                "assets/icon/flutter.png",
                                                              ),
                                                              SizedBox(
                                                                width: 10.0,
                                                              ),
                                                              Image.asset(
                                                                "assets/icon/firebase.png",
                                                              ),
                                                              SizedBox(
                                                                width: 10.0,
                                                              ),
                                                              Image.asset(
                                                                "assets/icon/getx.png",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/image/gradient/${controller.imageIndex}.png"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Downloadable(
                                  id: "features",
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 760.0,
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/image/gradient/${controller.imageIndex}.png"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: sidePadding,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: sidePadding,
                                                right: sidePadding,
                                              ),
                                              child: Wrap(
                                                spacing: spacing,
                                                runSpacing: spacing,
                                                children: [
                                                  Container(
                                                    width: Get.width,
                                                    child: Text(
                                                      "Key Features",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 26.0,
                                                      ),
                                                    ),
                                                  ),
                                                  ...List.generate(
                                                      controller.features
                                                          .length, (index) {
                                                    var item = controller
                                                        .features[index];

                                                    return FeatureBox(
                                                      height: boxWidth,
                                                      width: boxWidth,
                                                      icon: item["icon"],
                                                      label: item["label"],
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: sidePadding,
                                                right: sidePadding,
                                              ),
                                              child: Wrap(
                                                spacing: spacing,
                                                runSpacing: spacing,
                                                children: [
                                                  Container(
                                                    width: Get.width,
                                                    child: Text(
                                                      "Main Features",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 26.0,
                                                      ),
                                                    ),
                                                  ),
                                                  ...List.generate(
                                                      controller.mainFeatures
                                                          .length, (index) {
                                                    var item = controller
                                                        .mainFeatures[index];

                                                    return LongPressDraggable(
                                                      data: item,
                                                      dragAnchorStrategy:
                                                          pointerDragAnchorStrategy,
                                                      feedback: Material(
                                                        child: FeatureBox(
                                                          height: boxWidth,
                                                          width: boxWidth,
                                                          icon: item["icon"],
                                                          label: item["label"],
                                                        ),
                                                      ),
                                                      child: FeatureBox(
                                                        height: boxWidth,
                                                        width: boxWidth,
                                                        icon: item["icon"],
                                                        label: item["label"],
                                                      ),
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              ExTextField(
                                id: "promotional_tag",
                                label: "Promotional Tag",
                                value: controller.promotionalTag,
                                onChanged: (value) {
                                  controller.promotionalTag = value;
                                  controller.update();
                                },
                              ),
                              ExTextField(
                                id: "application_name_1",
                                label: "Application Name (1)",
                                value: controller.applicationName1,
                                onChanged: (value) {
                                  controller.applicationName1 = value;
                                  controller.update();
                                },
                              ),
                              ExTextField(
                                id: "application_name_2",
                                label: "Application Name (2)",
                                value: controller.applicationName2,
                                onChanged: (value) {
                                  controller.applicationName2 = value;
                                  controller.update();
                                },
                              ),
                              ExTextField(
                                id: "icon_name",
                                label: "Icon Name",
                                value: controller.iconName,
                                onChanged: (value) {
                                  controller.iconName = value;
                                  controller.update();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 700.0,
                            height: 800.0,
                            padding: EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/image/gradient/${controller.imageIndex}.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          GlassContainer(
                                            width: Get.width,
                                            blur: 1,
                                            opacity: 0.3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Installation Service",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    "Start From",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "\$5",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 40.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          GlassContainer(
                                            width: Get.width,
                                            blur: 1,
                                            opacity: 0.3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "- Firebase Setup",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "- Change Package Name",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "- Change Icon & Application Name",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "- Stripe Server Setup (NodeJS)",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          GlassContainer(
                                            width: Get.width,
                                            blur: 1,
                                            opacity: 0.3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Customize App",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Text(
                                                    "Start From",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "\$150",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 40.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          GlassContainer(
                                            width: Get.width,
                                            blur: 1,
                                            opacity: 0.3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "- Firebase Setup",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "- Change Package Name",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "- Change Icon & Application Name",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "- Stripe Server Setup (NodeJS)",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
