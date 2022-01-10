import 'package:flutter/material.dart';

typedef BitrateSwitchCallbak = void Function(int index);

class BitrateSwitch extends StatefulWidget {
  BitrateSwitch({
    Key? key,
    required this.initValue,
    this.onSelect,
  }) : super(key: key);

  final int initValue;
  final BitrateSwitchCallbak? onSelect;

  @override
  _BitrateSwitchState createState() => _BitrateSwitchState();
}

class _BitrateSwitchState extends State<BitrateSwitch> {
  late int selectValue;

  void _onTap() {
    setState(() {
      if (selectValue == 0) {
        selectValue = 1;
      } else if (selectValue == 2) {
        selectValue = 1;
      }
    });

    widget.onSelect?.call(selectValue);
  }

  @override
  void initState() {
    super.initState();
    selectValue = widget.initValue != null ? widget.initValue : 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: 78.0,
        height: 28.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          color: Color(0xff293450),
        ),
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectValue == 1) {
                          selectValue = 0;
                        } else if (selectValue == 2) {
                          selectValue = 1;
                        }
                      });

                      widget.onSelect?.call(selectValue);
                    },
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      color: Colors.transparent,
                    )
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectValue == 1) {
                            selectValue = 2;
                          } else if (selectValue == 0) {
                            selectValue = 1;
                          }
                        });

                        widget.onSelect?.call(selectValue);
                      },
                      child: Container(
                        width: 24.0,
                        height: 24.0,
                        color: Colors.transparent,
                      )
                  ),
                ],
              ),
              AnimatedAlign(
                alignment: getPosistion(selectValue),
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      getText(selectValue),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            blurRadius: 0.5,
                            color: Color(0xff616161),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  getPosistion(int value) {
    if (value == 0) {
      return Alignment.centerLeft;
    } else if (value == 1){
      return Alignment.center;
    } else {
      return Alignment.centerRight;
    }
  }

  getText(int value) {
    if (value == 0) {
      return '4M\nbps';
    } else if (value == 1){
      return '2M\nbps';
    } else {
      return '1M\nbps';
    }
  }
}
