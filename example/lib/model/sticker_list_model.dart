import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';

class StickerListModel {
  StickerListModel({
    required this.uuid,
    required this.title,
    required this.description,
    required this.isBundle,
    required this.status,
    required this.updatedAt,
    required this.items,
    required this.selects,
  });

  String uuid;
  String title;
  String description;
  bool isBundle;
  String status;
  num updatedAt;
  List<ItemModel> items = [];
  List<bool> selects = [];

  dynamic toJson() => {
    'uuid': uuid,
    'title': title,
    'description': description,
    'isBundle': isBundle,
    'status': status,
    'updatedAt': updatedAt,
    'items': items.map((i) => i.toJson()).toList(),
    'selects': selects.map((i) => i.toString()).toList(),
  };

  @override
  String toString() {
    return toJson().toString();
  }
}
