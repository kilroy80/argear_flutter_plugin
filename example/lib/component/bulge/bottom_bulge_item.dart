import 'package:flutter/material.dart';

typedef void BulgeItemCallback(int index);

class BottomBulgeItem extends StatelessWidget {
  BottomBulgeItem({
    Key? key,
    required this.index,
    required this.title,
    required this.assetUrl,
    this.onTap,
    required this.isSelect,
  }) : super(key: key);

  final int index;
  final String title;
  final String assetUrl;
  final BulgeItemCallback? onTap;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        this.onTap?.call(this.index);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
        width: 52.0,
        height: 52.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              this.assetUrl,
              width: 26.0,
              height: 26.0,
              fit: BoxFit.cover,
              color: this.isSelect ? Colors.white : Color(0xffbdbdbd),
            ),
            Text(
              this.title,
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

