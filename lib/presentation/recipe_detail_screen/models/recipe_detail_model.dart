import 'package:get/get.dart';
import '../../../widgets/custom_ingredients_list.dart';
import '../../../core/app_export.dart';

/// This class is used in the [RecipeDetailScreen] screen with GetX.

class RecipeDetailModel {
  Rx<List<CustomIngredientsItem>>? ingredientsList;
  Rx<List<String>>? instructionsList;
  Rx<String>? recipeName;
  Rx<String>? userName;
  Rx<String>? description;
  Rx<String>? updatedDate;
  Rx<bool>? isBookmarked;

  RecipeDetailModel({
    List<CustomIngredientsItem>? ingredientsList,
    List<String>? instructionsList,
    String? recipeName,
    String? userName,
    String? description,
    String? updatedDate,
    bool? isBookmarked,
  }) {
    this.ingredientsList = Rx<List<CustomIngredientsItem>>(
      ingredientsList ?? [],
    ); // Modified: Fixed type assignment for Rx<List<CustomIngredientsItem>>
    this.instructionsList = Rx<List<String>>(
      instructionsList ?? [],
    ); // Modified: Fixed type assignment for Rx<List<String>>
    this.recipeName = (recipeName ?? "Stir-fried Tomato and Eggs").obs;
    this.userName = (userName ?? "User Name").obs;
    this.description =
        (description ??
                "This is a simple and classic dish that is easy to make and perfect for a quick meal.")
            .obs;
    this.updatedDate = (updatedDate ?? "Updated on 2026-02-11").obs;
    this.isBookmarked = (isBookmarked ?? false).obs;
  }
}
