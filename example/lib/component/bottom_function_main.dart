import 'dart:async';

import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomFunctionMain extends StatelessWidget {
  BottomFunctionMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Get.find();
    mainProvider.getVideoBitrate();

    final pageController = PageController(
      viewportFraction: 0.18,
      initialPage: mainProvider.cameraButtonStatus.value.index > 1 ? 1 : mainProvider.cameraButtonStatus.value.index
    );

    late Timer timer;

    return Container(
      height: 160.0,
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0x80000000), Color(0x00000000)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 2,
              controller: pageController,
              onPageChanged: (int index) {
                if (index == 0) {
                  if (mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordFadeIn ||
                    mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordFadeOut) {

                    ARGearManager().arGearController.stopRecording();
                    timer.cancel();
                  }
                  mainProvider.cameraButtonStatus.value = CameraButtonStauts.CaptureIdle;
                } else {
                  mainProvider.cameraButtonStatus.value = CameraButtonStauts.RecordIdle;
                }
              },
              itemBuilder: (_, i) {
                if (i == 0) {
                  return _buildPhotoAndVideoItem('Photo', () {
                    if (mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordFadeIn ||
                        mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordFadeOut) {
                      mainProvider.cameraButtonStatus.value = CameraButtonStauts.CaptureIdle;
                      ARGearManager().arGearController.stopRecording();
                    }
                    pageController.animateToPage(i,
                        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                  });
                } else {
                  return _buildPhotoAndVideoItem('Video', () {
                    pageController.animateToPage(i,
                        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                  });
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 45.0,
              height: 2.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItem(
                      'assets/images/ic_beauty_white.png',
                      'Beauty',
                          () {
                        mainProvider.selectTab.value = 1;
                      }
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  _buildItem(
                      'assets/images/ic_filter_white.png',
                      'Filter',
                          () {
                        mainProvider.selectTab.value = 2;
                      }
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  if (mainProvider.cameraButtonStatus.value == CameraButtonStauts.CaptureIdle) {
                    ARGearManager().arGearController.takePicture();
                  } else if (mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordIdle) {

                    mainProvider.cameraButtonStatus.value = CameraButtonStauts.RecordFadeOut;

                    var bitrate = ARGearManager().getBitrateValue(mainProvider.videoBitrate.value);
                    ARGearManager().arGearController.setVideoBitrate(bitrate);
                    ARGearManager().arGearController.startRecording();

                    timer = Timer.periodic(Duration(milliseconds: 700), (timer) {
                      if (mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordFadeOut) {
                        mainProvider.cameraButtonStatus.value = CameraButtonStauts.RecordFadeIn;
                      } else if (mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordFadeIn) {
                        mainProvider.cameraButtonStatus.value = CameraButtonStauts.RecordFadeOut;
                      }
                    });
                  } else {
                    mainProvider.cameraButtonStatus.value = CameraButtonStauts.RecordIdle;
                    ARGearManager().arGearController.stopRecording();
                    if (timer != null) {
                      timer.cancel();
                    }
                  }
                },
                child: Obx(() => Container(
                  margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    color: Color(0x4dffffff),
                    borderRadius: BorderRadius.circular(64.0),
                    border: Border.all(
                        width: 5.0,
                        color: Colors.white
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29616161),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: AnimatedOpacity(
                    opacity: mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordIdle ||
                        mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordFadeIn ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 250),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          color: mainProvider.cameraButtonStatus.value == CameraButtonStauts.CaptureIdle ||
                              mainProvider.cameraButtonStatus.value == CameraButtonStauts.RecordIdle
                              ? Colors.white : Colors.red,
                          borderRadius: BorderRadius.circular(64.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x29616161),
                              spreadRadius: 0.5,
                              blurRadius: 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItem(
                      'assets/images/ic_contents_white.png',
                      'Content',
                          () {
                        mainProvider.selectTab.value = 3;
                      }
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  _buildItem(
                      'assets/images/ic_bulge_white.png',
                      'Bulge',
                          () {
                        mainProvider.selectTab.value = 4;
                      }
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }

  _buildItem(String url, String title, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap.call();
        }
      },
      child: Container(
        width: 54.0,
        height: 54.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              url,
              width: 28.0,
              height: 28.0,
              fit: BoxFit.cover
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 0.5,
                    color: Color(0xff616161),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildPhotoAndVideoItem(String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        height: 25.0,
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

