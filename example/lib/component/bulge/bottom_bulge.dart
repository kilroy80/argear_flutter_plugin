import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:argear_flutter_plugin_example/component/bulge/bottom_bulge_item.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBulge extends StatelessWidget {
  BottomBulge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MainProvider mainProvider = Get.find();
    mainProvider.initBulgeList();

    final _scrollController = ScrollController();
    Future.delayed(Duration.zero, () {
      if (mainProvider.selectBeulgeIndex > 0) {
        _scrollController.animateTo((52.0 * mainProvider.selectBeulgeIndex),
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
          padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 70.0),
          height: 190,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0x80000000), Color(0x00000000)],
            ),
          ),
          child: Row(
            children: [
              _buildClearBulge(mainProvider),
              Expanded(
                child: _buildList(mainProvider, _scrollController),
              )
            ],
          )
        )
      ],
    ));
  }

  Widget _buildList(MainProvider mainProvider, ScrollController scrollController) {
    if (mainProvider.bulgeList != null) {
      return ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: mainProvider.bulgeList.length,
        itemBuilder: (BuildContext context, int index) {
          return BottomBulgeItem(
            index: index,
            title: mainProvider.bulgeList[index].title,
            assetUrl: mainProvider.bulgeList[index].assetUrl,
            isSelect: mainProvider.bulgeList[index].isSelect,
            onTap: (selectIndex) {
              mainProvider.selectBeulgeIndex = selectIndex.toDouble();
              mainProvider.selectBulgeList(selectIndex);
              ARGearManager().arGearController.setBulge(
                mainProvider.bulgeList[selectIndex].bulgeType!
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
    }
  }

  Widget _buildClearBulge(MainProvider mainProvider) {
    return InkWell(
      onTap: () {
        mainProvider.selectBeulgeIndex = -1.0;
        mainProvider.selectBulgeList(-1);
        ARGearManager().arGearController.clearBulge();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(12.0, 0.0, 6.0, 0.0),
        child: Image.asset(
          'assets/images/ic_disabled_white_shadowx.png',
          width: 52.0,
          height: 52.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
