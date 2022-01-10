import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:argear_flutter_plugin_example/component/contents/bottom_contents_viewpager.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomContents extends StatelessWidget {
  BottomContents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MainProvider mainProvider = Get.find();
    mainProvider.setStickersData();

    return Obx(() => SafeArea(
        child: mainProvider.stickers != null && mainProvider.stickers.length > 0
          ? DefaultTabController(
            length: mainProvider.stickers.length,
            child: Column(
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
                  height: 230.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0x80000000), Color(0x00000000)],
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTabBar(mainProvider),
                      Expanded(
                        child: _buildViewPager(mainProvider),
                      ),
                    ],
                  ),
                ),
              ],
            )
        ) : Center(
          child: CircularProgressIndicator(),
        )
    ));
  }

  Widget _buildTabBar(MainProvider mainProvider) {
    return Container(
        height: 52.0,
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              margin: EdgeInsets.fromLTRB(65.0, 0.0, 0.0, 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  // indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.0,
                  // indicatorColor: Color(0xff62e979),
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0x80ffffff),
                  tabs: [
                    ..._buildTabs(mainProvider)
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: InkWell(
                onTap: () {
                  mainProvider.setSelectStickers(-1, -1);
                  ARGearManager().arGearController.clearSticker();
                },
                child: Image.asset(
                  'assets/images/ic_disabled_white_disabled.png',
                  width: 52.0,
                  height: 52.0,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        )
    );
  }

  List<Widget> _buildTabs(MainProvider mainProvider) {
    var list = <Widget>[];
    mainProvider.stickers.forEach((element) {
      list.add(
        Tab(
          child: Text(
            element.title,
            style: TextStyle(
              fontSize: 12.0,
              shadows: [
                Shadow(
                  blurRadius: 0.5,
                  color: Color(0xff616161),
                ),
              ],
            ),
          )
        )
      );
    });
    return list;
  }

  Widget _buildViewPager(MainProvider mainProvider) {
    return TabBarView(
      // physics: NeverScrollableScrollPhysics(),
      children: [
        ..._buildViewPagerItems(mainProvider)
      ],
    );
  }

  List<Widget> _buildViewPagerItems(MainProvider mainProvider) {
    var list = <Widget>[];
    mainProvider.stickers.asMap().forEach((i, element) {
      list.add(
          BottomContentsViewPager(pageIndex: i)
      );
    });
    return list;
  }
}

