import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../widgets/custom_ingredients_list.dart';
import '../models/recipe_detail_model.dart';
import '../../../core/app_export.dart';

class RecipeDetailController extends GetxController {
  final recipeDetailModel = Rx<RecipeDetailModel?>(null);
  final isBookmarked = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRecipeData();
  }

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
    Get.snackbar(
      'Profile',
      'User profile tapped',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: appTheme.whiteCustom,
    );
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
    Get.snackbar(
      'Recipe',
      isBookmarked.value ? 'Recipe bookmarked!' : 'Bookmark removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: appTheme.whiteCustom,
      duration: Duration(seconds: 2),
    );
  }

  void onMainFabTap() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.h),
            topRight: Radius.circular(20.h),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.favorite_outline),
              title: Text('Add to Favorites'),
              onTap: () {
                Get.back();
                onBookmarkTap();
              },
            ),
            ListTile(
              leading: Icon(Icons.share_outlined),
              title: Text('Share Recipe'),
              onTap: () {
                Get.back();
                onShareTap();
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit Recipe'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Edit',
                  'Edit functionality coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black87,
                  colorText: appTheme.whiteCustom,
                );
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
