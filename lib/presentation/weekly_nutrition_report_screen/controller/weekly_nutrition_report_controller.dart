import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/ingredient_item_model.dart';
import '../models/recipe_item_model.dart';
import '../models/weekly_nutrition_report_model.dart';

class WeeklyNutritionReportController extends GetxController {
  final weeklyNutritionReportModel = Rx<WeeklyNutritionReportModel?>(null);
  final isLoading = false.obs;
  
  // For scrolling app bar color change
  final scrollOffset = 0.0.obs;
  final headerHeight = 200.0;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void updateScrollOffset(double offset) {
    scrollOffset.value = offset;
  }

  void _initializeData() {
    weeklyNutritionReportModel.value = WeeklyNutritionReportModel(
      weekNumber: 'W16'.obs,
      totalCalories: 3564.obs,
      recipesList: [
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: 'Stir-fried Tomato and Eggs'.obs,
          description: 'This is a simple and classic dish ...'.obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
      ],
      ingredientsList: [
        IngredientItemModel(name: 'Tomato'.obs, quantity: '200 g'.obs),
        IngredientItemModel(name: 'Cucumber'.obs, quantity: '150 g'.obs),
        IngredientItemModel(name: 'Bell Pepper'.obs, quantity: '120 g'.obs),
        IngredientItemModel(name: 'Carrot'.obs, quantity: '100 g'.obs),
      ],
      proteinPercentage: 32.0.obs,
      carbsPercentage: 35.0.obs,
      fatPercentage: 33.0.obs,
    );
  }

  void onRecipeCardTapped(RecipeItemModel recipe) {
    Get.toNamed(AppRoutes.recipeDetailScreen);
  }

  void onShareTap() {
    // Basic share functionality for the report
    Get.snackbar(
      'Share',
      'Sharing your weekly nutrition report...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }

  void onBackPressed() {
    Get.back();
  }
}
