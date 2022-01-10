import 'dart:convert';

import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:argear_flutter_plugin_example/argear_manager.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

typedef void ContentsItemCallback(int index);

class BottomContentsItem extends StatelessWidget {
  BottomContentsItem({
    Key? key,
    required this.index,
    required this.data,
    required this.isSelect,
    this.onTap,
  }) : super(key: key);

  final int index;
  final ItemModel data;
  final bool isSelect;
  final ContentsItemCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () async {
          onTap?.call(this.index);
          ARGearManager().arGearController.setSticker(data);
        },
        child: Stack(
          children: [
            ClipOval(
              // borderRadius: BorderRadius.all(
              //   Radius.circular(48.0),
              // ),
              child: FadeInImage.assetNetwork(
                // width: 48.0,
                // height: 48.0,
                fit: BoxFit.cover,
                placeholder: 'assets/images/ic_item_placeholder.png',
                image: this.data.thumbnail,
              ),
            ),
            this.isSelect != null && this.isSelect ? ClipOval(
              // borderRadius: BorderRadius.all(
              //   Radius.circular(48.0),
              // ),
              child: Image.asset(
                'assets/images/ic_select_filter.png',
                // width: 48.0,
                // height: 48.0,
              ),
            ) :
            Container(),
          ],
        )
      ),
    );
  }
}

