import 'package:get/get.dart';
import '../../../core/app_export.dart';
import './recipe_item_model.dart';

/// This class is used in the [UserProfileScreen] screen with GetX.
class UserProfileModel {
  Rx<String>? userName;
  Rx<int>? recipeCount;
  Rx<int>? saveCount;
  Rx<String>? allergies;
  RxList<RecipeItemModel>? recipes;

  UserProfileModel({
    this.userName,
    this.recipeCount,
    this.saveCount,
    this.allergies,
    this.recipes,
  }) {
    userName = userName ?? Rx("Amy Perkins");
    recipeCount = recipeCount ?? Rx(4);
    saveCount = saveCount ?? Rx(128);
    allergies = allergies ?? Rx("");
    recipes = recipes ?? RxList<RecipeItemModel>([]);
  }
}
