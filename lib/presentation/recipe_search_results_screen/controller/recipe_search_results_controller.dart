import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/recipe_item_model.dart';
import '../models/recipe_search_results_model.dart';

class RecipeSearchResultsController extends GetxController {
  Rx<RecipeSearchResultsModel> recipeSearchResultsModelObj =
      RecipeSearchResultsModel().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRecipeList();
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  void _initializeRecipeList() {
    List<RecipeItemModel> recipes = [
      RecipeItemModel(
        userInitial: "A".obs,
        userName: "Sarah Johnson".obs,
        userInfo: "Home Chef".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Creamy Pasta Carbonara".obs,
        isBookmarked: false.obs,
      ),
      RecipeItemModel(
        userInitial: "B".obs,
        userName: "Mark Thompson".obs,
        userInfo: "Professional Chef".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Grilled Salmon with Herbs".obs,
        isBookmarked: true.obs,
      ),
      RecipeItemModel(
        userInitial: "C".obs,
        userName: "Lisa Chen".obs,
        userInfo: "Food Blogger".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Chocolate Lava Cake".obs,
        isBookmarked: false.obs,
      ),
    ];

    recipeSearchResultsModelObj.value.recipeList = recipes;
    recipeSearchResultsModelObj.refresh();
  }

  void onSearchTextChanged(String searchText) {
    // Implement search functionality
    if (searchText.isEmpty) {
      _initializeRecipeList();
    } else {
      _filterRecipes(searchText);
    }
  }

  void _filterRecipes(String query) {
    List<RecipeItemModel> allRecipes = [
      RecipeItemModel(
        userInitial: "A".obs,
        userName: "Sarah Johnson".obs,
        userInfo: "Home Chef".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Creamy Pasta Carbonara".obs,
        isBookmarked: false.obs,
      ),
      RecipeItemModel(
        userInitial: "B".obs,
        userName: "Mark Thompson".obs,
        userInfo: "Professional Chef".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Grilled Salmon with Herbs".obs,
        isBookmarked: true.obs,
      ),
      RecipeItemModel(
        userInitial: "C".obs,
        userName: "Lisa Chen".obs,
        userInfo: "Food Blogger".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Chocolate Lava Cake".obs,
        isBookmarked: false.obs,
      ),
      RecipeItemModel(
        userInitial: "D".obs,
        userName: "Alex Rodriguez".obs,
        userInfo: "Pastry Chef".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Classic Tiramisu".obs,
        isBookmarked: false.obs,
      ),
      RecipeItemModel(
        userInitial: "E".obs,
        userName: "Emma Wilson".obs,
        userInfo: "Nutritionist".obs,
        recipeImage: ImageConstant.imgMedia188x364.obs,
        recipeName: "Quinoa Buddha Bowl".obs,
        isBookmarked: true.obs,
      ),
    ];

    List<RecipeItemModel> filteredRecipes = allRecipes.where((recipe) {
      return recipe.recipeName!.value.toLowerCase().contains(
            query.toLowerCase(),
          ) ||
          recipe.userName!.value.toLowerCase().contains(query.toLowerCase());
    }).toList();

    recipeSearchResultsModelObj.value.recipeList = filteredRecipes;
    recipeSearchResultsModelObj.refresh();
  }

  void performSearch() {
    String searchText = searchController.value.text;
    onSearchTextChanged(searchText);
  }

  String? validateSearchText(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return null;
  }

  void toggleBookmark(int index) {
    if (recipeSearchResultsModelObj.value.recipeList != null &&
        index < recipeSearchResultsModelObj.value.recipeList!.length) {
      var recipe = recipeSearchResultsModelObj.value.recipeList![index];
      recipe.isBookmarked?.value = !(recipe.isBookmarked?.value ?? false);
      recipeSearchResultsModelObj.refresh();
    }
  }
}
