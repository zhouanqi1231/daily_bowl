import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../widgets/custom_ingredients_list.dart';
import '../models/recipe_detail_model.dart';
import '../../../core/app_export.dart';

class RecipeDetailController extends GetxController {
  final recipeDetailModel = Rx<RecipeDetailModel?>(null);
  final isBookmarked = false.obs;
  final isSaved = false.obs;
  
  // For scrolling app bar color change
  final scrollOffset = 0.0.obs;
  final imageHeight = 412.0; // Same as in the screen

  @override
  void onInit() {
    super.onInit();
    _initializeRecipeData();
  }

  void updateScrollOffset(double offset) {
    scrollOffset.value = offset;
  }

  bool get isImageScrolledOut => scrollOffset.value >= imageHeight - (70.h); // 70.h is app bar height

  void _initializeRecipeData() {
    recipeDetailModel.value = RecipeDetailModel(
      ingredientsList: [
        CustomIngredientsItem(name: "Tomato", quantity: "200 g"),
        CustomIngredientsItem(name: "Cucumber", quantity: "150 g"),
        CustomIngredientsItem(name: "Bell Pepper", quantity: "120 g"),
        CustomIngredientsItem(name: "Carrot", quantity: "100 g"),
      ],
      instructionsList: [
        "Wash the tomatoes, remove the core, and cut them into bite-sized wedges.",
        "Crack the eggs into a bowl, add a small pinch of salt, and beat them thoroughly until smooth.",
        "Heat 1 tablespoon of cooking oil in a wok or skillet over medium-high heat.",
        "Pour the beaten eggs into the hot oil and gently scramble them until just set, then remove them from the pan and set aside in a bowl.",
      ],
    );
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
    isSaved.value = !isSaved.value;
    if (isSaved.value) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'saved',
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
