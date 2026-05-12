import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
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

  /// Calculates the week of the year (1-53) based on ISO 8601 (starts on Monday)
  int _getWeekOfYear(DateTime date) {
    // Find the Thursday of the week (ISO 8601 week belongs to the year of its Thursday)
    DateTime thursday = date.add(Duration(days: 4 - date.weekday));
    DateTime firstDayOfYear = DateTime(thursday.year, 1, 1);
    int daysSinceFirstDay = thursday.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }

  /// Checks if a date falls in the current calendar week (Monday to Sunday)
  bool _isDateInCurrentWeek(DateTime date) {
    final now = DateTime.now();
    // Find Monday of the current week
    final startOfMonday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    // Check if date is on or after Monday 00:00:00
    return date.isAfter(startOfMonday.subtract(const Duration(seconds: 1)));
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
      // read json storage
      List<String> followedRecipesJson = prefs.getStringList('followed_recipes') ?? [];
      
      // Filter recipes followed THIS week
      List<RecipeItemModel> currentWeekRecipes = [];
      Map<String, double> aggregatedIngredients = {};

      for (var jsonStr in followedRecipesJson) {
        try {
          Map<String, dynamic> data = jsonDecode(jsonStr);
          String? cookedAtStr = data['cooked_at'];
          if (cookedAtStr == null) continue;

          DateTime cookedAt = DateTime.parse(cookedAtStr).toLocal();
          
          // Filter by cooking date, including only data on this week
          if (_isDateInCurrentWeek(cookedAt)) {
            int? recipeId = data['id'];
            if (recipeId == null) continue;

            String title;
            String imagePath;

            try {
              // Fetch latest info from server
              final recipeDetail = await ApiClient.get('/recipes/$recipeId/');
              if (recipeDetail == null) {
                // If ID is missing in the server, don't show the item
                continue;
              }
              title = recipeDetail['title'] ?? 'Unknown Recipe';
              imagePath = recipeDetail['img_url'] ?? ImageConstant.imgMedia;
            } catch (e) {
              print("Failed to fetch info for recipe $recipeId: $e");
              // If server request fails (e.g. 404), don't show the item
              continue;
            }

            // Show the cooked_time
            String cookedTime = "${cookedAt.hour.toString().padLeft(2, '0')}:${cookedAt.minute.toString().padLeft(2, '0')}";
            String cookedDay = _getWeekdayName(cookedAt.weekday);
            
            currentWeekRecipes.add(RecipeItemModel(
              id: recipeId,
              title: title.obs,
              description: "Cooked at $cookedTime on $cookedDay".obs,
              imagePath: imagePath.obs,
            ));

            // Aggregate ingredients for nutrition consumption display
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
        // Show most recent first
        weeklyNutritionReportModel.value!.recipesList = currentWeekRecipes.reversed.toList();
        
        // Update ingredients list in model
        weeklyNutritionReportModel.value!.ingredientsList = aggregatedIngredients.entries.map((e) {
          return IngredientItemModel(
            name: e.key.obs,
            quantity: '${e.value.toInt()} servings'.obs,
          );
        }).toList();

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
    if (recipe.id != null) {
      Get.toNamed(AppRoutes.recipeDetailScreen, arguments: {'id': recipe.id});
    }
  }

  final isGeneratingReport = false.obs;

  /// POSTs to the aux service with ?wait=true — the server blocks until the
  /// worker finishes, then the download URL is returned and opened in a new tab.
  Future<void> generateReport() async {
    final recipes = weeklyNutritionReportModel.value?.recipesList;
    if (recipes == null || recipes.isEmpty) {
      Get.snackbar('No recipes', 'No recipes this week to generate a report.');
      return;
    }

    final recipeIds = recipes.map((r) => r.id).whereType<int>().toList();
    if (recipeIds.isEmpty) {
      Get.snackbar('Error', 'Could not collect recipe IDs.');
      return;
    }

    final auxBase = ApiClient.auxBaseUrl;
    if (auxBase.isEmpty) {
      Get.snackbar('Error', 'Aux service URL not configured.');
      return;
    }

    try {
      isGeneratingReport.value = true;

      final resp = await http.post(
        Uri.parse('$auxBase/reports/?wait=true'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'recipe_ids': recipeIds}),
      );

      if (resp.statusCode == 500) {
        final data = jsonDecode(resp.body);
        throw Exception(data['error_message'] ?? 'Report generation failed');
      }
      if (resp.statusCode == 504) {
        throw Exception('Report generation timed out — try again.');
      }
      if (resp.statusCode != 200) {
        throw Exception('Unexpected response: ${resp.statusCode}');
      }

      final job = jsonDecode(resp.body);
      final jobId = job['id'];
      final downloadUrl = '$auxBase/reports/$jobId/download/';
      html.window.open(downloadUrl, '_blank');

      Get.snackbar('Success', 'Report downloaded.');
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isGeneratingReport.value = false;
    }
  }

  void onBackPressed() {
    Get.back();
  }
}
