import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:argear_flutter_plugin_example/component/loading_dialog.dart';
import 'package:flutter/material.dart';

class ARGearManager {

  static final ARGearManager _instance = ARGearManager._internal();
  factory ARGearManager() {
    return _instance;
  }

  ARGearManager._internal();

  late ARGearController arGearController;

  showLoadingDialog(
      BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext buildContext) => AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(0.0),
        content: LoadingDialog(),
      ),
    );
  }

  getBitrateValue(int type) {
    ARGVideoBitrate bitrate;
    if (type == 0) {
      bitrate = ARGVideoBitrate.VideoBitrate_4M;
    } else if (type == 1) {
      bitrate = ARGVideoBitrate.VideoBitrate_2M;
    } else {
      bitrate = ARGVideoBitrate.VideoBitrate_1M;
    }
    return bitrate;
  }
}
