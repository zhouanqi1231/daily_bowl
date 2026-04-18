import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class represents an individual allergy item in the allergy setting screen.
class AllergyItemModel {
  Rx<String>? name;
  Rx<bool>? isSelected;

  AllergyItemModel({this.name, this.isSelected}) {
    name = name ?? Rx("");
    isSelected = isSelected ?? Rx(false);
  }
}
