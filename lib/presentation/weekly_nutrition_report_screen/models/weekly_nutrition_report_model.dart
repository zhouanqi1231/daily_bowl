import 'package:get/get.dart';

import '../../../core/app_export.dart';
import './ingredient_item_model.dart';
import './recipe_item_model.dart';

/// This class is used in the [WeeklyNutritionReportScreen] screen with GetX.

class WeeklyNutritionReportModel {
  Rx<String>? weekNumber;
  Rx<int>? totalCalories;
  List<RecipeItemModel>? recipesList;
  List<IngredientItemModel>? ingredientsList;
  Rx<double>? proteinPercentage;
  Rx<double>? carbsPercentage;
  Rx<double>? fatPercentage;

  WeeklyNutritionReportModel({
    this.weekNumber,
    this.totalCalories,
    this.recipesList,
    this.ingredientsList,
    this.proteinPercentage,
    this.carbsPercentage,
    this.fatPercentage,
  }) {
    weekNumber = weekNumber ?? Rx('W16');
    totalCalories = totalCalories ?? Rx(3564);
    recipesList = recipesList ?? [];
    ingredientsList = ingredientsList ?? [];
    proteinPercentage = proteinPercentage ?? Rx(32.0);
    carbsPercentage = carbsPercentage ?? Rx(35.0);
    fatPercentage = fatPercentage ?? Rx(33.0);
  }
}
