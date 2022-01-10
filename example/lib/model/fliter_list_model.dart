import 'package:argear_flutter_plugin/argear_flutter_plugin.dart';

class FilterListModel {
  FilterListModel({
    required this.itemModel,
    required this.isSelect,
    required this.filterValue,
  });

  ItemModel itemModel;
  bool isSelect;
  double filterValue;

  dynamic toJson() => {
    'itemModel': itemModel.toJson(),
    'isSelect': isSelect,
    'filterValue': filterValue,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}
