import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_ingredients_list.dart';
import '../models/recipe_detail_model.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../../core/global_save_manager.dart';
import '../../user_profile_screen/controller/user_profile_controller.dart';

class RecipeDetailController extends GetxController {
  final recipeDetailModel = Rx<RecipeDetailModel?>(null);

  // UI status
  final isBookmarked = false.obs;
  final isSaved = false.obs;
  final isLoading = true.obs;

  // data bind to UI
  final recipeImageUrl = "".obs;

  final recipeTitle = "".obs;
  final recipeDescription = "".obs;

  final authorName = "".obs;

  // match user allergies to ingredients
  final allergyTags = <String>[].obs;
  final userAllergies = <String>[].obs;

  // Nutrition data (stored for local persistence on "Cook")
  final totalCalories = 0.0.obs;
  final totalProtein = 0.0.obs;
  final totalCarbs = 0.0.obs;
  final totalFat = 0.0.obs;

  // create date
  final updateDate = "".obs;

  // For scrolling app bar color change
  final scrollOffset = 0.0.obs;
  final imageHeight = 412.0; // Same as in the screen

  int recipeId = -1;

  @override
  void onInit() {
    super.onInit();
    // get id from prev page
    if (Get.arguments != null && Get.arguments['id'] != null) {
      recipeId = Get.arguments['id'];
      isSaved.value = Get.find<GlobalSaveManager>().savedIds.contains(recipeId);
      ever(Get.find<GlobalSaveManager>().savedIds, (Set<int> savedIds) {
        if (!isClosed) {
          isSaved.value = savedIds.contains(recipeId);
        }
      });
      _initializeData();
    } else {
      isLoading.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isClosed) {
          Get.snackbar("Error", "Cannot get recipe ID");
        }
      });
    }
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _loadUserAllergies(),
      _fetchRecipeDetail(recipeId),
    ]);
  }

  Future<void> _loadUserAllergies() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      if (userId == null) return;

      // get user allergy data
      final userData = await ApiClient.get('/users/$userId/');
      if (isClosed) return;

      if (userData != null) {
        var allergiesValue = userData['allergies'] ?? userData['allergy'];
        if (allergiesValue != null) {
          String allergyStr = allergiesValue.toString();
          userAllergies.value = allergyStr
              .split(',')
              .map((e) => e.trim().toLowerCase())
              .where((e) => e.isNotEmpty)
              .toList();
        }
      }
    } catch (e) {
      print("Error loading user allergies: $e");
    }
  }

  void updateScrollOffset(double offset) {
    scrollOffset.value = offset;
  }

  bool get isImageScrolledOut => scrollOffset.value >= imageHeight - (70.h);

  Future<void> _fetchRecipeDetail(int id) async {
    try {
      isLoading.value = true;

      // Fetch recipe, ingredients, and nutrition in parallel
      var responses = await Future.wait([
        ApiClient.get('/recipes/$id/'),
        ApiClient.get('/recipes/$id/ingredients/'),
        ApiClient.get('/recipes/$id/nutrition/'),
      ]);

      if (isClosed) return;

      var recipeData = responses[0];
      var ingredientsAssoc = responses[1];
      var nutritionData = responses[2];

      // recipe info
      recipeImageUrl.value = recipeData['img_url'] ?? "";

      recipeTitle.value = recipeData['title'] ?? 'Unknown Recipe';
      recipeDescription.value =
          "Cuisine Type: ${recipeData['cuisine_type'] ?? 'Default Type'} • Portion: ${recipeData['servings'] ?? 1} pax";

      // Fetch author name
      authorName.value = recipeData['creator_username'] ??
          "User ${recipeData['created_by'] ?? ''}";

      // Assign nutrition data
      totalCalories.value = (nutritionData['total_calories'] ?? 0.0).toDouble();
      totalProtein.value = (nutritionData['total_protein'] ?? 0.0).toDouble();
      totalCarbs.value = (nutritionData['total_carbs'] ?? 0.0).toDouble();
      totalFat.value = (nutritionData['total_fat'] ?? 0.0).toDouble();

      // Fetch created date
      if (recipeData['created_at'] != null) {
        DateTime date = DateTime.parse(recipeData['created_at']);
        updateDate.value =
            "Created on ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }

      // Separate steps from procedure string (1,2,3...)
      List<String> steps = [];
      String procedure = recipeData['procedure'] ?? '';
      if (procedure.isNotEmpty) {
        // Improved splitting logic to handle numbering and newlines
        steps = procedure
            .split(RegExp(r'\d+\.\s*|\n'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();

        if (steps.isEmpty && procedure.trim().isNotEmpty) {
          steps = [procedure.trim()];
        }
      }

      // Fetch ingredients in parallel
      var ingredientFutures =
          ingredientsAssoc.map<Future<Map<String, dynamic>>>((assoc) async {
        int ingId = assoc['ingredient_id'];
        var ingDetail = await ApiClient.get('/ingredients/$ingId/');
        return {
          'assoc': assoc,
          'detail': ingDetail,
        };
      }).toList();

      var results = await Future.wait(ingredientFutures);

      if (isClosed) return;

      List<CustomIngredientsItem> loadedIngredients = [];
      Set<String> allergiesSet = {};

      for (var result in results) {
        var assoc = result['assoc'];
        var ingDetail = result['detail'];

        loadedIngredients.add(CustomIngredientsItem(
          name: ingDetail['name']?.toString() ?? 'Unknown Ingredient',
          quantity: "${assoc['amount']} ${assoc['unit'] ?? ''}",
        ));

        if (ingDetail['allergy'] != null &&
            ingDetail['allergy'].toString().isNotEmpty) {
          String allergyField = ingDetail['allergy'].toString();
          List<String> splitAllergies = allergyField
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          allergiesSet.addAll(splitAllergies);
        }
      }

      allergyTags.value = allergiesSet.toList();

      recipeDetailModel.value = RecipeDetailModel(
        ingredientsList: loadedIngredients,
        instructionsList: steps,
      );
    } catch (e) {
      print("Failed to fetch recipe details: $e");
      if (!isClosed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!isClosed) {
            Get.snackbar("Failed to load", "Please check internet connections");
          }
        });
      }
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  // match user allergy to current recipe
  bool isUserAllergicTo(String tag) {
    String normalizedTag = tag.toLowerCase();
    return userAllergies.any((userAllergy) {
      return normalizedTag.contains(userAllergy) ||
          userAllergy.contains(normalizedTag);
    });
  }

  // cooked button
  Future<void> onBookmarkTap() async {
    isBookmarked.value = !isBookmarked.value;
    if (isBookmarked.value) {
      // Save "followed to cook" action locally
      final prefs = await SharedPreferences.getInstance();

      // Update heatmap data (cooked_dates)
      List<String> cookedDates = prefs.getStringList('cooked_dates') ?? [];
      String todayStr = DateTime.now().toIso8601String().split('T')[0];
      cookedDates.add(todayStr);
      await prefs.setStringList('cooked_dates', cookedDates);

      // Save detailed recipe JSON for weekly report
      List<String> followedRecipesJson =
          prefs.getStringList('followed_recipes') ?? [];

      // store cooked info locally, in a json form
      Map<String, dynamic> recipeInfo = {
        'id': recipeId,
        'title': recipeTitle.value,
        'description': recipeDescription.value,
        'image_path': recipeImageUrl.value,
        'cooked_at': DateTime.now().toIso8601String(),
        'nutrition': {
          'calories': totalCalories.value,
          'protein': totalProtein.value,
          'carbs': totalCarbs.value,
          'fat': totalFat.value,
        }
      };
      followedRecipesJson.add(jsonEncode(recipeInfo));
      await prefs.setStringList('followed_recipes', followedRecipesJson);

      Get.showSnackbar(
        GetSnackBar(
          message: 'Marked as cooked!',
          duration: Duration(milliseconds: 1500),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          margin: EdgeInsets.all(16.h),
          borderRadius: 8.h,
        ),
      );

      // Refresh UserProfileController to update the heatmap immediately
      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().refreshUserProfile();
      }
    }
  }

  // save button
  void onMainFabTap() {
    if (recipeId != -1) {
      bool willBeSaved = !isSaved.value;

      // request
      Get.find<GlobalSaveManager>().toggleSave(recipeId);

      Get.showSnackbar(
        GetSnackBar(
          message: willBeSaved
              ? 'Recipe saved to your collection'
              : 'Recipe removed from your collection',
          duration: Duration(milliseconds: 1000),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          margin: EdgeInsets.all(16.h),
          borderRadius: 8.h,
        ),
      );
    }
  }
}
