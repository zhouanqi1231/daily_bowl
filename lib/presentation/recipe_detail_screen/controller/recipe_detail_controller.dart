import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
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
      _fetchRecipeDetail(recipeId);
    } else {
      isLoading.value = false;
      Get.snackbar("Error", "Cannot get recipe ID");
    }
  }

  void updateScrollOffset(double offset) {
    scrollOffset.value = offset;
  }

  bool get isImageScrolledOut => scrollOffset.value >= imageHeight - (70.h); // 70.h is app bar height

  Future<void> _fetchRecipeDetail(int id) async {
    try {
      isLoading.value = true;

      var recipeData = await ApiClient.get('/recipes/$id/');
      
      recipeTitle.value = recipeData['title'] ?? 'Unknown Recipe';
      recipeDescription.value = "Cuisine Type: ${recipeData['cuisine_type'] ?? 'Default Type'} • Portion: ${recipeData['servings'] ?? 1} pax";
      authorName.value = "User ${recipeData['created_by']}";

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

      var ingredientsAssoc = await ApiClient.get('/recipes/$id/ingredients/');
      
      List<CustomIngredientsItem> loadedIngredients = [];
      Set<String> allergies = {};

      for (var assoc in ingredientsAssoc) {
        int ingId = assoc['ingredient_id'];
        var ingDetail = await ApiClient.get('/ingredients/$ingId/');

        loadedIngredients.add(CustomIngredientsItem(
          name: ingDetail['name'].toString(),
          quantity: "${assoc['amount']} ${assoc['unit'] ?? ''}",
        ));

        if (ingDetail['allergy'] != null && ingDetail['allergy'].toString().isNotEmpty) {
          allergies.add(ingDetail['allergy'].toString());
        }
      }

      allergyTags.value = allergies.toList();

      recipeDetailModel.value = RecipeDetailModel(
        ingredientsList: loadedIngredients,
        instructionsList: steps,
      );

    } catch (e) {
      print("Failed to fetch recipe details: $e");
      Get.snackbar("Failed to load", "Please check internet connections");
    } finally {
      isLoading.value = false;
    }
  }

  void onShareTap() {
    Share.share(
      'Check out this amazing recipe: Stir-fried Tomato and Eggs\n\nA simple and classic dish that is easy to make and perfect for a quick meal!',
      subject: 'Stir-fried Tomato and Eggs Recipe',
    );
  }

  void onUserProfileTap() {
    // No-op or minimal action as requested previously
  }

  void onAllergyTagTap(String allergen) {
    Get.snackbar(
      'Allergy Alert',
      'This recipe contains $allergen. Please be careful if you have allergies.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: appTheme.red_900,
      colorText: appTheme.whiteCustom,
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
