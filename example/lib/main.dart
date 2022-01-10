
import 'package:argear_flutter_plugin_example/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => MainPage(),
      },
      fallbackLocale: Locale('en', 'US'),
    );
  }
}
