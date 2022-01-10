import 'package:argear_flutter_plugin_example/component/contents/bottom_contents_item.dart';
import 'package:argear_flutter_plugin_example/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomContentsViewPager extends StatelessWidget {
  BottomContentsViewPager({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {

    ScrollController _scrollController = ScrollController();
    final MainProvider mainProvider = Get.find();

    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Obx(() => CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10.0,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 18.0,
              mainAxisSpacing: 18.0,
            ),
            delegate: SliverChildBuilderDelegate((context, i) {
              return BottomContentsItem(
                index: i,
                data: mainProvider.stickers[this.pageIndex].items[i],
                isSelect: mainProvider.stickers[this.pageIndex].selects[i],
                onTap: (itemIndex) {
                  mainProvider.setSelectStickers(this.pageIndex, itemIndex);
                },
              );
            },
              childCount: mainProvider.stickers[this.pageIndex].items.length,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20.0,
            ),
          ),
        ],
      )),
    );
  }
}

