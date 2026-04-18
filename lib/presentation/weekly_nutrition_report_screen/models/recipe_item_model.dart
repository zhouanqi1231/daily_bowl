import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class is used for recipe items in the weekly nutrition report.

class RecipeItemModel {
  Rx<String>? title;
  Rx<String>? description;
  Rx<String>? imagePath;

  RecipeItemModel({this.title, this.description, this.imagePath}) {
    title = title ?? Rx('');
    description = description ?? Rx('');
    imagePath = imagePath ?? Rx('');
  }
}
