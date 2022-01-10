import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ARGearIOSView extends UiKitView {
  final String type;
  final PlatformViewCreatedCallback? onViewCreated;

  ARGearIOSView({
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
