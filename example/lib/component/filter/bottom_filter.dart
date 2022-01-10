import 'dart:convert';

import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:argear_flutter_plugin_example/component/filter/bottom_filter_list_item.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';

class BottomFilter extends StatelessWidget {
  BottomFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MainProvider mainProvider = Get.find();
    mainProvider.initFiltersData();

    final _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      if (mainProvider.selectFilterIndex > 0) {
        _scrollController.animateTo((52.0 * mainProvider.selectFilterIndex),
            duration: const Duration(milliseconds: 150),
            curve: Curves.ease);
      }
    });

    return Obx(() => Column(
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
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(75.0, 0.0, 75.0, 0.0),
                child: _buildSlider(mainProvider),
              ),
              SizedBox(
                height: 5.0,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 86.0, minHeight: 86.0),
                child: Row(
                  children: [
                    _buildClearFilter(mainProvider),
                    Expanded(
                        child: _buildList(mainProvider, _scrollController)
                    ),
                  ],
                ),
              ),
            ],
          )
        )
      ],
    ));
  }

  Widget _buildSlider(MainProvider mainProvider) {
    return mainProvider.filters != null && mainProvider.filters.length > 0 ?
    FlutterSlider(
      values: mainProvider.selectFilterIndex >= 0 ?
        [mainProvider.filters[mainProvider.selectFilterIndex.toInt()].filterValue] : [0.0],
      max: 100.0,
      min: 0.0,
      disabled: mainProvider.selectFilterIndex >= 0 ? false : true,
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
        mainProvider.filters[mainProvider.selectFilterIndex.toInt()].filterValue = lowerValue;

        ARGearManager().arGearController.setFilterLevel(
            lowerValue
        );
      },
    ) :
    Container();
  }

  Widget _buildList(MainProvider mainProvider, ScrollController scrollController) {
    if (mainProvider.filters != null && mainProvider.filters.length > 0) {
      return ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: mainProvider.filters.length,
        itemBuilder: (BuildContext context, int index) {
          return BottomFilterListItem(
            index: index,
            title: mainProvider.filters[index].itemModel.title,
            url: mainProvider.filters[index].itemModel.thumbnail,
            isSelect: mainProvider.filters[index].isSelect,
            onTap: (selectIndex) {
              mainProvider.selectFilterIndex = selectIndex.toDouble();
              mainProvider.setSelectFilters(selectIndex);

              ARGearManager().arGearController.setFilter(
                mainProvider.filters[index].itemModel
              );
            },
          );
        }
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
        ),
      );
      // return Center(
      //   child: Text(
      //     'Error, No Filter Contents.',
      //     overflow: TextOverflow.ellipsis,
      //     maxLines: 1,
      //     style: TextStyle(
      //       fontSize: 18.0,
      //       color: Colors.white,
      //       shadows: [
      //         Shadow(
      //           blurRadius: 0.5,
      //           color: Color(0xff616161),
      //         ),
      //       ],
      //     ),
      //   ),
      // );
    }
  }

  Widget _buildClearFilter(MainProvider mainProvider) {
    return InkWell(
      onTap: () {
        mainProvider.selectFilterIndex = -1.0;
        mainProvider.setSelectFilters(-1);

        ARGearManager().arGearController.clearFilter();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(12.0, 0.0, 6.0, 20.0),
        child: Center(
          child: Image.asset(
            'assets/images/ic_disabled_white_shadowx.png',
            width: 52.0,
            height: 52.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
