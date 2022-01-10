import 'dart:convert';

import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:argear_flutter_plugin_example/component/beauty/bottom_beauty_list_item.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';

class BottomBeauty extends StatelessWidget {
  BottomBeauty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MainProvider mainProvider = Get.find();
    mainProvider.initBeautyList();
    mainProvider.initBeautyValue(
        ARGearManager().arGearController.getDefaultBeauty()
    );

    return Obx(() => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => {
              mainProvider.selectTab.value = 0
            },
            child: Container(),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          height: 190,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0x80000000), Color(0x00000000)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: _buildSlider(mainProvider)
                  ),
                  _buildButtonContrast(mainProvider),
                  _buildButtonReset(mainProvider),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 52.0, minHeight: 52.0),
                child: _buildList(mainProvider),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildSlider(MainProvider mainProvider) {
    if (mainProvider.beautyData != null && mainProvider.beautyData.length > 0) {
      ARGearManager().arGearController.setBeautyValues(
        mainProvider.beautyData.map((e) => e.value).toList()
      );
    }
    return mainProvider.beautyData != null && mainProvider.beautyData.length > 0 ?
      FlutterSlider(
        values: [mainProvider.beautyData[getIndexByListType(mainProvider)].value],
        max: mainProvider.beautyData[getIndexByListType(mainProvider)].max,
        min: mainProvider.beautyData[getIndexByListType(mainProvider)].min,
        tooltip: FlutterSliderTooltip(
          positionOffset: FlutterSliderTooltipPositionOffset(top: 20.0),
          format: (String value) {
            return double.parse(value).toInt().toString();
          },
          textStyle: TextStyle(fontSize: 10, color: Colors.white),
          boxStyle: FlutterSliderTooltipBox(
            decoration: BoxDecoration(
                color: Colors.transparent
            ),
          ),
        ),
        handler: FlutterSliderHandler(
          decoration: BoxDecoration(),
          child: Container(
            width: 18.0,
            height: 18.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: Color(0xff3063e6),
            ),
          ),
        ),
        trackBar: FlutterSliderTrackBar(
          inactiveTrackBar: BoxDecoration(
            color: Color(0xff3063e6).withOpacity(0.2),
          ),
          activeTrackBar: BoxDecoration(
              color: Color(0xff3063e6)
          ),
        ),
        onDragging: (handlerIndex, lowerValue, upperValue) {
          mainProvider.beautyData[getIndexByListType(mainProvider)].value = lowerValue;

          ARGearManager().arGearController.setBeauty(
            mainProvider.beautyData[getIndexByListType(mainProvider)].type,
            lowerValue
          );
        },
      ) :
      Container();
  }

  getIndexByListType(MainProvider mainProvider) {
    var index = mainProvider.beautyData.indexWhere((element) {
      return element.type == mainProvider.beautyList[mainProvider.selectBeautyIndex.value].beutyType;
    });
    return index >= 0 ? index : 0;
  }

  Widget _buildList(MainProvider mainProvider) {
    if (mainProvider.beautyList != null && mainProvider.beautyList.length > 0) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mainProvider.beautyList.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 || index == mainProvider.beautyList.length + 1) {
            return SizedBox(
              width: 6.0,
            );
          } else {
            return BottomBeautyListItem(
              index: index - 1,
              title: mainProvider.beautyList[index - 1].title,
              url: mainProvider.beautyList[index - 1].assetUrl,
              isSelect: mainProvider.beautyList[index - 1].isSelect,
              onTap: (selectIndex) {
                mainProvider.selectBeautyIndex.value = selectIndex;
                mainProvider.selectBeautyList(selectIndex);
              },
            );
          }
        }
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
        ),
      );
    }
  }

  Widget _buildButtonContrast(MainProvider mainProvider) {
    return GestureDetector(
      onTapUp: (details) {
        ARGearManager().arGearController.setBeautyValues(
            mainProvider.beautyData.map((e) => e.value).toList()
        );
      },
      onTapDown: (details) {
        ARGearManager().arGearController.setBeautyValues(
          mainProvider.defaultDeautyData.map((e) => e.value).toList()
        );
      },
      child: Container(
        child: Center(
          child: Image.asset(
            'assets/images/ic_contrast_white.png',
            width: 52.0,
            height: 52.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonReset(MainProvider mainProvider) {
    return InkWell(
      onTap: () {
        mainProvider.resetBeautyValue();
      },
      child: Container(
        child: Center(
          child: Image.asset(
            'assets/images/ic_refresh_white.png',
            width: 52.0,
            height: 52.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
