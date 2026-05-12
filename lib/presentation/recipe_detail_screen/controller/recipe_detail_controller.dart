import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_ingredients_list.dart';
import '../models/recipe_detail_model.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../../core/global_save_manager.dart';
import '../../user_profile_screen/controller/user_profile_controller.dart';

/// A controller class for the RecipeDetailScreen.
///
/// This class manages the state of the recipe details, including fetching data
/// from multiple API endpoints (recipe, ingredients, nutrition), matching user
/// allergies, and handling user interactions like "cooking" or "saving" a recipe.
class RecipeDetailController extends GetxController {
  /// Observable object for the recipe detail model.
  final recipeDetailModel = Rx<RecipeDetailModel?>(null);

  /// Observable boolean to track if the recipe is marked as cooked.
  final isBookmarked = false.obs;

  /// Observable boolean to track if the recipe is saved in the user's collection.
  final isSaved = false.obs;

  /// Observable boolean to track loading state.
  final isLoading = true.obs;

  /// Observable string for the recipe's main image URL.
  final recipeImageUrl = "".obs;

  /// Observable string for the recipe title.
  final recipeTitle = "".obs;

  /// Observable string for the recipe description (cuisine type and servings).
  final recipeDescription = "".obs;

  /// Observable string for the author's name.
  final authorName = "".obs;

  /// Observable list of allergy tags associated with the recipe's ingredients.
  final allergyTags = <String>[].obs;

  /// Observable list of the user's own allergies.
  final userAllergies = <String>[].obs;

  /// Observable value for total calories in the recipe.
  final totalCalories = 0.0.obs;

  /// Observable value for total protein in the recipe.
  final totalProtein = 0.0.obs;

  /// Observable value for total carbohydrates in the recipe.
  final totalCarbs = 0.0.obs;

  /// Observable value for total fat in the recipe.
  final totalFat = 0.0.obs;

  /// Observable string for the recipe's creation date.
  final updateDate = "".obs;

  /// Observable value for the current scroll position of the screen.
  final scrollOffset = 0.0.obs;

  /// The height of the top image, used for parallax/app bar effects.
  final imageHeight = 412.0;

  /// The unique ID of the recipe being displayed.
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

  /// Initial data fetch sequence: user allergies and recipe details.
  Future<void> _initializeData() async {
    await Future.wait([
      _loadUserAllergies(),
      _fetchRecipeDetail(recipeId),
    ]);
  }

  /// Loads the current user's allergies from the backend and updates [userAllergies].
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

  /// Updates the current [scrollOffset] as the user scrolls.
  ///
  /// [offset] The new scroll position.
  void updateScrollOffset(double offset) {
    scrollOffset.value = offset;
  }

  /// Returns true if the top image has been scrolled past the app bar.
  bool get isImageScrolledOut => scrollOffset.value >= imageHeight - (70.h);

  /// Fetches all necessary details for a recipe, including ingredients and nutrition.
  ///
  /// [id] The ID of the recipe to fetch.
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

  /// Checks if the user is allergic to a specific [tag].
  ///
  /// Compares the ingredient's allergy tag with the user's allergy list.
  bool isUserAllergicTo(String tag) {
    String normalizedTag = tag.toLowerCase();
    return userAllergies.any((userAllergy) {
      return normalizedTag.contains(userAllergy) ||
          userAllergy.contains(normalizedTag);
    });
  }

  /// Handles the action when the "Mark as Cooked" button is tapped.
  ///
  /// Persists the cooking event locally, updates heatmap data, and refreshes the profile.
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
          duration: const Duration(milliseconds: 1500),
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

  /// Handles the action when the "Save Recipe" button is tapped.
  ///
  /// Uses [GlobalSaveManager] to toggle the recipe's saved status.
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
          duration: const Duration(milliseconds: 1000),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          margin: EdgeInsets.all(16.h),
          borderRadius: 8.h,
        ),
      );
    }
  }
}
