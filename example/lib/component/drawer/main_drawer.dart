import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:argear_flutter_plugin_example/component/bitrate_switch.dart';
import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({
    Key? key,
    this.onTap
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {

    final MainProvider mainProvider = Get.find();
    mainProvider.getVideoBitrate();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 60.0,
        ),
        Image.asset(
          'assets/images/img_splash_logo.png',
          width: 80.0,
          height: 80.0,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0xff616161),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
          child: Column(
            children: [
              Container(
                height: 1.0,
                color: Color(0xffbdbdbd),
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bitrate',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xff707070),
                    ),
                  ),
                  mainProvider.videoBitrate >= 0 ? Obx(() => BitrateSwitch(
                    initValue: mainProvider.videoBitrate.value,
                    onSelect: (index) {
                      mainProvider.videoBitrate.value = index;

                      ARGVideoBitrate bitrate = ARGearManager().getBitrateValue(index);
                      saveBitrate(bitrate);

                      ARGearManager().arGearController.setVideoBitrate(bitrate);
                    },
                  )) : Container(),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Application Info',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xff707070),
                    ),
                  ),
                  Text(
                    'v0.1',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xffbdbdbd),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  saveBitrate(ARGVideoBitrate bitrate) {
    GetStorage box = GetStorage();
    box.write("videoBitrate", bitrate.index);
  }
}
