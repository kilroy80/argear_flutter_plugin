import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ARGearAndroidView extends AndroidView {
  final String type;
  final PlatformViewCreatedCallback? onViewCreated;

  ARGearAndroidView({
    Key? key,
    required this.type,
    this.onViewCreated,
  }) : super(
    key: key,
    viewType: type,
    onPlatformViewCreated: onViewCreated,
    creationParams: <String, dynamic> {
    },
    creationParamsCodec: const StandardMessageCodec(),
  );
}
