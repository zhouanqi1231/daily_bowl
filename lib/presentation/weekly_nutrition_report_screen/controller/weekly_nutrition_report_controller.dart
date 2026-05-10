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

  /// Calculates the week of the year (1-53)
  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }

  /// Checks if two dates are in the same week of the same year
  bool _isSameWeek(DateTime date1, DateTime date2) {
    return date1.year == date2.year && _getWeekOfYear(date1) == _getWeekOfYear(date2);
  }

  String _getWeekdayName(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (day < 1 || day > 7) return '';
    return days[day - 1];
  }

  void _initializeData() {
    final now = DateTime.now();
    final weekNum = _getWeekOfYear(now);
    
    weeklyNutritionReportModel.value = WeeklyNutritionReportModel(
      weekNumber: 'W$weekNum'.obs,
      totalCalories: 0.obs,
      recipesList: [], 
      ingredientsList: [],
      proteinPercentage: 0.0.obs,
      carbsPercentage: 0.0.obs,
      fatPercentage: 0.0.obs,
    );
  }

  Future<void> _loadFollowedRecipes() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      List<String> followedRecipesJson = prefs.getStringList('followed_recipes') ?? [];
      
      final now = DateTime.now();
      
      // Filter recipes followed THIS week
      List<RecipeItemModel> currentWeekRecipes = [];
      Map<String, double> aggregatedIngredients = {};

      for (var jsonStr in followedRecipesJson) {
        try {
          Map<String, dynamic> data = jsonDecode(jsonStr);
          String? cookedAtStr = data['cooked_at'];
          if (cookedAtStr == null) continue;

          DateTime cookedAt = DateTime.parse(cookedAtStr).toLocal();
          
          if (_isSameWeek(now, cookedAt)) {
            String timeStr = "${_getWeekdayName(cookedAt.weekday)} ${cookedAt.hour}:${cookedAt.minute.toString().padLeft(2, '0')}";
            
            // We add every instance as a separate item in the list
            currentWeekRecipes.add(RecipeItemModel(
              title: (data['title'] ?? 'Unknown Recipe').toString().obs,
              // Update description to show precisely when it was cooked
              description: "Cooked on $timeStr • ${data['description'] ?? ''}".obs,
              imagePath: (data['image_path'] ?? ImageConstant.imgMedia).toString().obs,
            ));

            // Aggregate ingredients for nutrition consumption display (Total summary)
            if (data['ingredients'] != null && data['ingredients'] is List) {
              for (var ing in data['ingredients']) {
                String name = ing['name'] ?? 'Unknown';
                aggregatedIngredients[name] = (aggregatedIngredients[name] ?? 0) + 1; 
              }
            }
          }
        } catch (e) {
          print("Error parsing followed recipe: $e");
        }
      }

      if (weeklyNutritionReportModel.value != null) {
        // Show most recent first (don't merge duplicates, keep them as separate records)
        weeklyNutritionReportModel.value!.recipesList = currentWeekRecipes.reversed.toList();
        
        // Update ingredients list in model (Aggregate for total consumption view)
        weeklyNutritionReportModel.value!.ingredientsList = aggregatedIngredients.entries.map((e) {
          return IngredientItemModel(
            name: e.key.obs,
            quantity: '${e.value.toInt()} servings'.obs,
          );
        }).toList();

        // Total calories account for every time you cooked (e.g. 2 times = double calories)
        int count = currentWeekRecipes.length;
        weeklyNutritionReportModel.value!.totalCalories?.value = count * 450; 
        
        if (count > 0) {
          weeklyNutritionReportModel.value!.proteinPercentage?.value = 30.0;
          weeklyNutritionReportModel.value!.carbsPercentage?.value = 40.0;
          weeklyNutritionReportModel.value!.fatPercentage?.value = 30.0;
        }

        weeklyNutritionReportModel.refresh();
      }
    } catch (e) {
      print("Error loading followed recipes for current week: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onRecipeCardTapped(RecipeItemModel recipe) {
    Get.snackbar("Activity Log", "You recorded this session: ${recipe.title?.value}");
  }

  void onShareTap() {
    final week = weeklyNutritionReportModel.value?.weekNumber?.value ?? "this week";
    Get.snackbar(
      'Share Report',
      'Preparing to share your $week nutrition summary...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: appTheme.deep_purple_800,
      colorText: Colors.white,
    );
  }

  void onBackPressed() {
    Get.back();
  }
}
