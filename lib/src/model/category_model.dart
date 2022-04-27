import 'package:argear_flutter_plugin/src/model/item_model.dart';

class CategoryModel {
  String _uuid = '';
  String _title = '';
  String _description = '';
  bool _isBundle = false;
  String _status = '';
  num _updatedAt = 0;
  List<ItemModel> _items = [];

  CategoryModel(result) {
    if (result != null) {
      parse(result);
    }
  }

  CategoryModel.fromJson(Map<String, dynamic> parsedJson) {
    parse(parsedJson);
  }

  Map<String, dynamic> toJson() => {
    'uuid': _uuid,
    'title': _title,
    'description': _description,
    'is_bundle': _isBundle,
    'status' : _status,
    'updated_at': _updatedAt,
    'items': _items.map((i) => i.toJson()).toList(),
  };

  void parse(parsedJson) {
    _uuid = parsedJson['uuid'] ?? '';
    _title = parsedJson['title'] ?? '';
    _description = parsedJson['description'] ?? '';
    _isBundle = parsedJson['is_bundle'] ?? false;
    _status = parsedJson['status'] ?? '';
    _updatedAt = parsedJson['updated_at'] ?? 0;

    if (parsedJson['items'] != null) {
      for (int i = 0; i < parsedJson['items'].length; i++) {
        _items.add(ItemModel(parsedJson['items'][i]));
      }
    }
  }

  String get uuid => _uuid;

  String get title => _title;

  String get description => _description;

  bool get isBundle => _isBundle;

  String get status => _status;

  num get updatedAt => _updatedAt;

  List<ItemModel> get items => _items;
}
