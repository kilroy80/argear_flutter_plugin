import 'dart:core';
import 'package:argear_flutter_plugin/src/model/category_model.dart';

class ContentsModel {
  String _apiKey = '';
  String _name = '';
  String _description = '';
  String _status = '';
  num _lastUpdatedAt = 0;
  List<CategoryModel> _categories = [];

  ContentsModel(result) {
    if (result != null) {
      parse(result);
    }
  }

  ContentsModel.fromJson(Map<String, dynamic> parsedJson) {
    parse(parsedJson);
  }

  Map<String, dynamic> toJson() => {
    'api_key': _apiKey,
    'name': _name,
    'description': _description,
    'status' : _status,
    'last_updated_at': _lastUpdatedAt,
    'categories': _categories.map((i) => i.toJson()).toList(),
  };

  void parse(parsedJson) {
    _apiKey = parsedJson['api_key'] ?? '';
    _name = parsedJson['name'] ?? '';
    _description = parsedJson['description'] ?? '';
    _status = parsedJson['status'] ?? '';

    var updateAt = parsedJson['last_updated_at'];
    if (parsedJson['last_updated_at'] != null) {
      if (updateAt is String) {
        _lastUpdatedAt = DateTime.parse(updateAt).millisecondsSinceEpoch;
      } else {
        _lastUpdatedAt = updateAt;
      }
    } else {
      _lastUpdatedAt = 0;
    }

    if (parsedJson['categories'] != null) {
      for (int i = 0; i < parsedJson['categories'].length; i++) {
        _categories.add(CategoryModel(parsedJson['categories'][i]));
      }
    }
  }

  String get apiKey => _apiKey;

  String get name => _name;

  String get description => _description;

  String get status => _status;

  num get lastUpdatedAt => _lastUpdatedAt;

  List<CategoryModel> get categories => _categories;
}
