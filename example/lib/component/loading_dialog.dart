import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _dialogContent(context);
  }

  _dialogContent(BuildContext context) {
    return Center(
      child: Container(
        width: 60.0,
        height: 60.0,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: CircularProgressIndicator(),
      )
    );
  }
}
