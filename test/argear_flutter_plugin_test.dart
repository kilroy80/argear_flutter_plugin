import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('argear_flutter_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
