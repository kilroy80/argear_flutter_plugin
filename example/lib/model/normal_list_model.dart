import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';

class NormalListModel {
  NormalListModel({
    required this.title,
    required this.assetUrl,
    this.beutyType,
    this.bulgeType,
    required this.isSelect,
  });

  String title;
  String assetUrl;
  ARGBeauty? beutyType;
  ARGBulge? bulgeType;
  bool isSelect;

  dynamic toJson() => {
    'title': title,
    'assetUrl': assetUrl,
    'beutyType': beutyType,
    'bulgeType': bulgeType,
    'isSelect': isSelect,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}
