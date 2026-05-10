import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _loadFollowedRecipes();
  }

  void updateScrollOffset(double offset) {
    scrollOffset.value = offset;
  }

  void _initializeData() {
    // Initial mock data for nutrition stats, but we'll load recipes from local storage
    weeklyNutritionReportModel.value = WeeklyNutritionReportModel(
      weekNumber: 'W16'.obs,
      totalCalories: 3564.obs,
      recipesList: [], // Will be loaded from local storage
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

  Future<void> _loadFollowedRecipes() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      List<String> followedRecipesJson = prefs.getStringList('followed_recipes') ?? [];
      
      // We can reverse the list to show the most recent ones first
      List<RecipeItemModel> followedRecipes = followedRecipesJson.reversed.map((jsonStr) {
        Map<String, dynamic> data = jsonDecode(jsonStr);
        return RecipeItemModel(
          title: (data['title'] ?? 'Unknown Recipe').toString().obs,
          description: (data['description'] ?? '').toString().obs,
          imagePath: (data['image_path'] ?? ImageConstant.imgMedia).toString().obs,
        );
      }).toList();

      if (weeklyNutritionReportModel.value != null) {
        weeklyNutritionReportModel.value!.recipesList = followedRecipes;
        weeklyNutritionReportModel.refresh();
      }
    } catch (e) {
      print("Error loading followed recipes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onRecipeCardTapped(RecipeItemModel recipe) {
    // If we had the ID, we could navigate to details. 
    // Since we only saved minimal info, we show a notice or navigate with defaults.
    Get.snackbar("Notice", "Viewing detailed report for ${recipe.title?.value}");
  }

  void onShareTap() {
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
