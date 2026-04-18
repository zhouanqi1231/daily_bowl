import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class is used for ingredient items in the weekly nutrition report.

class IngredientItemModel {
  Rx<String>? name;
  Rx<String>? quantity;

  IngredientItemModel({this.name, this.quantity}) {
    name = name ?? Rx('');
    quantity = quantity ?? Rx('');
  }
}
