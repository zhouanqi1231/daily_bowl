import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class is used in the [RecipeCreationScreen] screen with GetX.

class RecipeCreationModel {
  Rx<String>? title;
  Rx<String>? imagePath;
  Rx<List<Map<String, String>>>? ingredients;
  Rx<List<String>>? steps;
  Rx<bool>? isCompleted;

  RecipeCreationModel({
    this.title,
    this.imagePath,
    this.ingredients,
    this.steps,
    this.isCompleted,
  }) {
    title = title ?? Rx("");
    imagePath = imagePath ?? Rx("");
    ingredients = ingredients ?? Rx(<Map<String, String>>[]);
    steps = steps ?? Rx(<String>[]);
    isCompleted = isCompleted ?? Rx(false);
  }
}
