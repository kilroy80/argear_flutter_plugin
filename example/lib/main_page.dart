import 'dart:io';

import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:argear_flutter_plugin_example/component/beauty/bottom_beauty.dart';
import 'package:argear_flutter_plugin_example/component/bottom_function_main.dart';
import 'package:argear_flutter_plugin_example/component/bulge/bottom_bulge.dart';
import 'package:argear_flutter_plugin_example/component/contents/bottom_contents.dart';
import 'package:argear_flutter_plugin_example/component/drawer/main_drawer.dart';
import 'package:argear_flutter_plugin_example/component/filter/bottom_filter.dart';
import 'package:argear_flutter_plugin_example/config.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late ARGearController arGearController;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final MainProvider mainProvider = Get.put(MainProvider());

  var loadingDialog;

  @override
  void initState() {
    super.initState();
    mainProvider.getContents();
  }

  @override
  void dispose() {
    arGearController.dispose();
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (!kIsWeb && !Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    }

    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () {
          if (mainProvider.selectTab.value == 0) {
            return Future(() => true);
          } else {
            mainProvider.selectTab.value = 0;
          }
          return Future(() => false);
        },
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: Stack(
              children: [
                ARGearView(
                  onArGearViewCreated: _onArGearViewCreated,
                  apiUrl : Config.apiUrl,
                  apiKey: Config.apiKey,
                  secretKey: Config.secretKey,
                  authKey: Config.authKey,
                  onCallback: (method, arguments) {
                    Fluttertoast.showToast(
                        msg: method.toString() + ' / ' + arguments.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0
                    );
                  },
                  onPre: (method, arguments) {
                    ARGearManager().showLoadingDialog(context);
                  },
                  onComplete: (method, arguments) {
                    Navigator.of(context).pop();
                  }
                ),
                Column(
                  children: [
                    _buildTopWidget(),
                    Expanded(
                        child: Obx(() => _buildBottomWidget())
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Container(
        width: 240.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(12.0),
            bottomRight: const Radius.circular(12.0),
          ),
          color: Colors.white,
        ),
        child: MainDrawer(
            onTap: () async => {
              _toggleDrawer()
            }
        ),
      ),
    );
  }

  _onArGearViewCreated(ARGearController controller) {
    arGearController = controller;
    ARGearManager().arGearController = arGearController;
    // init beauty apply
    ARGearManager().arGearController.setDefaultBeauty();
  }

  void _toggleDrawer() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  Widget _buildTopWidget() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 55.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x80000000), Color(0x00000000)],
          ),
        ),
        padding: EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async => {
                _toggleDrawer()
              },
              child: Image.asset(
                'assets/images/ic_settings_white.png',
                width: 52.0,
                height: 52.0,
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: () async {
                if (mainProvider.screenRatio.value == 0) {
                  ARGearManager().arGearController.changeCameraRatio(ARGCameraRatio.RATIO_4_3);
                  mainProvider.screenRatio.value = 1;
                } else if (mainProvider.screenRatio.value == 1) {
                  ARGearManager().arGearController.changeCameraRatio(ARGCameraRatio.RATIO_1_1);
                  mainProvider.screenRatio.value = 2;
                } else {
                  ARGearManager().arGearController.changeCameraRatio(ARGCameraRatio.RATIO_FULL);
                  mainProvider.screenRatio.value = 0;
                }
              },
              child: Obx(() => Image.asset(
                _getScreenRatioAssetName(mainProvider),
                width: 52.0,
                height: 52.0,
                fit: BoxFit.cover,
                color: mainProvider.screenRatio == null ||
                    mainProvider.screenRatio.value == 0 || mainProvider.screenRatio.value == 1 ?
                      null : Colors.white,
              )),
            ),
            InkWell(
              onTap: () async => {
                arGearController.changeCameraFacing()
              },
              child: Image.asset(
                'assets/images/ic_rotate_white.png',
                width: 52.0,
                height: 52.0,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomWidget() {
    if (mainProvider.contents != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: _buildFunctions(),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
        ),
      );
    }
  }

  Widget _buildFunctions() {
    if (mainProvider.selectTab.value == 0) {
      return BottomFunctionMain();
    } else if (mainProvider.selectTab.value == 1) {
      return BottomBeauty();
    } else if (mainProvider.selectTab.value == 2) {
      return BottomFilter();
    } else if (mainProvider.selectTab.value == 3) {
      return BottomContents();
    } else {
      return BottomBulge();
    }
  }

  String _getScreenRatioAssetName(MainProvider provider) {
    if (provider.screenRatio == null || provider.screenRatio.value == 0) {
      return 'assets/images/ic_full_white.png';
    } else if (provider.screenRatio.value == 1) {
      return 'assets/images/ic_4_3_white.png';
    } else {
      return 'assets/images/ic_1_1_black.png';
    }
  }
}
