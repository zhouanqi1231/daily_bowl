import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class is used in the [saved_recipe_list_screen] screen with GetX.
class SavedRecipeListModel {
  Rx<String>? title;
  Rx<String>? description;
  Rx<String>? imagePath;

  SavedRecipeListModel({this.title, this.description, this.imagePath}) {
    title = title ?? Rx("");
    description = description ?? Rx("");
    imagePath = imagePath ?? Rx("");
  }
}
