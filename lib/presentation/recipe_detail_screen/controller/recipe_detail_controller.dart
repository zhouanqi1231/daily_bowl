import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/custom_ingredients_list.dart';
import '../models/recipe_detail_model.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../../core/global_save_manager.dart';

class RecipeDetailController extends GetxController {
  final recipeDetailModel = Rx<RecipeDetailModel?>(null);

  // UI status
  final isBookmarked = false.obs;
  final isSaved = false.obs;
  final isLoading = true.obs;

  // data bind to UI
  final recipeTitle = "".obs;
  final recipeDescription = "".obs;
  final authorName = "".obs;
  final updateDate = "".obs;
  final allergyTags = <String>[].obs;
  final userAllergies = <String>[].obs;
  final recipeImageUrl = "".obs;

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
        isSaved.value = savedIds.contains(recipeId);
      });
      _initializeData();
    } else {
      isLoading.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", "Cannot get recipe ID");
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

      final userData = await ApiClient.get('/users/$userId/');
      if (userData != null && userData['allergy'] != null) {
        String allergyStr = userData['allergy'].toString();
        userAllergies.value = allergyStr.split(',').map((e) => e.trim().toLowerCase()).where((e) => e.isNotEmpty).toList();
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

      var responses = await Future.wait([
        ApiClient.get('/recipes/$id/'),
        ApiClient.get('/recipes/$id/ingredients/'),
      ]);

      var recipeData = responses[0];
      var ingredientsAssoc = responses[1];

      recipeTitle.value = recipeData['title'] ?? 'Unknown Recipe';
      recipeDescription.value = "Cuisine Type: ${recipeData['cuisine_type'] ?? 'Default Type'} • Portion: ${recipeData['servings'] ?? 1} pax";
      recipeImageUrl.value = recipeData['img_url'] ?? "";

      // Fetch author name
      authorName.value = recipeData['creator_username'] ?? "User ${recipeData['created_by'] ?? ''}";

      if (recipeData['created_at'] != null) {
        DateTime date = DateTime.parse(recipeData['created_at']);
        updateDate.value = "Updated on ${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      }

      List<String> steps = [];
      String procedure = recipeData['procedure'] ?? '';
      if (procedure.isNotEmpty) {
        steps = procedure.split(RegExp(r'\d+\.\s*')).where((s) => s.trim().isNotEmpty).toList();
        if (steps.isEmpty) steps = [procedure];
      }

      var ingredientFutures = ingredientsAssoc.map<Future<Map<String, dynamic>>>((assoc) async {
        int ingId = assoc['ingredient_id'];
        var ingDetail = await ApiClient.get('/ingredients/$ingId/');
        return {
          'assoc': assoc,
          'detail': ingDetail,
        };
      }).toList();

      var results = await Future.wait(ingredientFutures);

      List<CustomIngredientsItem> loadedIngredients = [];
      Set<String> allergiesSet = {};

      for (var result in results) {
        var assoc = result['assoc'];
        var ingDetail = result['detail'];

        loadedIngredients.add(CustomIngredientsItem(
          name: ingDetail['name']?.toString() ?? 'Unknown Ingredient',
          quantity: "${assoc['amount']} ${assoc['unit'] ?? ''}",
        ));

        if (ingDetail['allergy'] != null && ingDetail['allergy'].toString().isNotEmpty) {
          String allergyField = ingDetail['allergy'].toString();
          // Split by comma in case there are multiple allergies for one ingredient
          List<String> splitAllergies = allergyField.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Failed to load", "Please check internet connections");
      });
    } finally {
      isLoading.value = false;
    }
  }

  bool isUserAllergicTo(String tag) {
    String normalizedTag = tag.toLowerCase();
    // Simple match or partial match for safety (e.g., "Nut" matches "Peanut" or "Tree Nut")
    return userAllergies.any((userAllergy) {
      return normalizedTag.contains(userAllergy) || userAllergy.contains(normalizedTag);
    });
  }

  void onShareTap() {
    Share.share(
      'Check out this amazing recipe: ${recipeTitle.value}\n\n${recipeDescription.value}',
      subject: '${recipeTitle.value} Recipe',
    );
  }

  void onUserProfileTap() {
    // No-op or minimal action as requested previously
  }

  void onAllergyTagTap(String allergen) {
    bool isMatch = isUserAllergicTo(allergen);
    Get.snackbar(
      isMatch ? 'Allergy Warning!' : 'Allergy Alert',
      'This recipe contains $allergen.${isMatch ? " This matches your allergy profile!" : ""}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isMatch ? appTheme.red_900 : appTheme.deep_orange_200,
      colorText: isMatch ? appTheme.whiteCustom : appTheme.black_900,
      duration: Duration(seconds: 3),
    );
  }

  void onBookmarkTap() {
    isBookmarked.value = !isBookmarked.value;
    if (isBookmarked.value) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'cooked',
          duration: Duration(milliseconds: 1000),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          margin: EdgeInsets.all(16.h),
          borderRadius: 8.h,
        ),
      );
    }
  }

  void onMainFabTap() {
    if (recipeId != -1) {
      bool willBeSaved = !isSaved.value;

      Get.find<GlobalSaveManager>().toggleSave(recipeId);

      Get.showSnackbar(
        GetSnackBar(
          message: willBeSaved ? 'Recipe saved to your collection' : 'Recipe removed from your collection',
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
