import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

typedef void FilterListItemCallback(int index);

class BottomFilterListItem extends StatelessWidget {
  BottomFilterListItem({
    Key? key,
    required this.index,
    required this.title,
    required this.url,
    this.onTap,
    required this.isSelect,
  }) : super(key: key);

  final int index;
  final String title;
  final String url;
  final FilterListItemCallback? onTap;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.onTap?.call(this.index);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(66.0),
                  ),
                  child: FadeInImage.assetNetwork(
                    width: 66.0,
                    height: 66.0,
                    fit: BoxFit.cover,
                    placeholder: 'assets/images/ic_item_placeholder.png',
                    image: this.url,
                  ),
                ),
                this.isSelect != null && this.isSelect ?
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(66.0),
                    ),
                    child: Image.asset(
                      'assets/images/ic_select_filter.png',
                      width: 66.0,
                      height: 66.0,
                    ),
                  ) :
                  Container(),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              this.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10.0,
                color: this.isSelect ? Colors.white : Color(0xffbdbdbd),
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
}

