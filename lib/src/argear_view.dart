import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef ARGearViewCreatedCallback = void Function(ARGearController controller);
typedef PlatformViewCreatedCallback = void Function(int id);

class ARGearView extends StatefulWidget {

  final ARGearViewCreatedCallback onArGearViewCreated;
  final String? apiUrl;
  final String? apiKey;
  final String? secretKey;
  final String? authKey;
  final ARGearControllerCallback? onPre;
  final ARGearControllerCallback? onCallback;
  final ARGearControllerCallback? onComplete;

  const ARGearView({
    Key? key,
    required this.onArGearViewCreated,
    this.apiUrl,
    this.apiKey,
    this.secretKey,
    this.authKey,
    this.onCallback,
    this.onPre,
    this.onComplete,
  }) : super(key: key);

  @override
  _ARGearViewState createState() => _ARGearViewState();
}

class _ARGearViewState extends State<ARGearView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // return ARGearAndroidView(
      //   type: 'argear_flutter_plugin',
      //   onViewCreated: _onPlatformViewCreated,
      // );
      return PlatformViewLink(
        viewType: 'argear_flutter_plugin',
        surfaceFactory: (
            BuildContext context,
            PlatformViewController controller,
            ) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          final ExpensiveAndroidViewController controller =
          PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'argear_flutter_plugin',
            layoutDirection: TextDirection.ltr,
            // creationParams: creationParams,
            creationParams: <String, dynamic>{
            },
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged(true),
          );
          controller
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
            ..create();

          return controller;
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ARGearIOSView(
        type: 'argear_flutter_plugin',
        onViewCreated: _onPlatformViewCreated,
      );
    }
    return Center(
      child: Text(
        '$defaultTargetPlatform is not supported by the argear_view plugin'),
    );
  }

  void _onPlatformViewCreated(int id) {
    // if (widget.onArGearViewCreated == null) {
    //   return;
    // }
    widget.onArGearViewCreated(ARGearController(
      id: id,
      apiUrl: widget.apiUrl,
      apiKey: widget.apiKey,
      secretKey: widget.secretKey,
      authKey: widget.authKey,
      onCallback: widget.onCallback,
      onPre: widget.onPre,
      onComplete: widget.onComplete,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
