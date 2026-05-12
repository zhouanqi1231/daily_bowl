import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../../core/global_save_manager.dart';
import '../models/recipe_item_model.dart';
import '../models/categorized_recipe_model.dart';

class CategorizedRecipeController extends GetxController {
  Rx<CategorizedRecipeModel> categorizedRecipeModelObj =
      CategorizedRecipeModel().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxBool isLoading = false.obs;
  Rx<String?> cuisineType = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();

    // Check for arguments from CategoryScreen or other screens
    if (Get.arguments != null && Get.arguments is Map) {
      cuisineType.value = Get.arguments['cuisine_type'];
      if (cuisineType.value != null) {
        searchController.value.text = cuisineType.value!;
      }
    }

    fetchRecipes();

    // Listen to global save changes
    ever(Get.find<GlobalSaveManager>().savedIds, (Set<int> globalSavedIds) {
      if (categorizedRecipeModelObj.value.recipeList != null) {
        for (var recipe in categorizedRecipeModelObj.value.recipeList!) {
          if (recipe.id != null) {
            recipe.isBookmarked?.value = globalSavedIds.contains(recipe.id);
          }
        }
      }
    });
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }

  Future<void> fetchRecipes({String? query}) async {
    try {
      isLoading.value = true;

      String endpoint = '/recipes/';
      List<String> params = [];

      if (query != null && query.isNotEmpty) {
        params.add('title=$query');
      } else if (cuisineType.value != null) {
        params.add('cuisine_type=${cuisineType.value}');
      }

      if (params.isNotEmpty) {
        endpoint += '?' + params.join('&');
      }

      final response = await ApiClient.get(endpoint);

      if (response is List) {
        List<RecipeItemModel> recipes = response.map((json) {
          int rId = json['id'];
          String displayName = json['creator_username'] ?? "User ${json['created_by']}";

          return RecipeItemModel(
            id: rId,
            recipeName: (json['title'] ?? 'Unknown Recipe').toString().obs,
            userName: displayName.obs,
            userInitial: (displayName.isNotEmpty ? displayName[0].toUpperCase() : "U").obs,
            userInfo: (json['cuisine_type'] ?? 'Home Chef').toString().obs,
            recipeImage: (json['img_url']?.toString() ?? ImageConstant.imgMedia188x364).obs,
            isBookmarked: Get.find<GlobalSaveManager>().savedIds.contains(rId).obs,
          );
        }).toList();

        categorizedRecipeModelObj.value.recipeList = recipes;
        categorizedRecipeModelObj.refresh();
      }
    } catch (e) {
      print("Error fetching recipes: $e");
      Get.snackbar("Error", "Failed to load recipes");
    } finally {
      isLoading.value = false;
    }
  }

  void performSearch() {
    String searchText = searchController.value.text;
    cuisineType.value = null; // Clear cuisine type filter when performing a manual search
    fetchRecipes(query: searchText);
  }

  void toggleBookmark(int index) {
    if (categorizedRecipeModelObj.value.recipeList != null &&
        index < categorizedRecipeModelObj.value.recipeList!.length) {
      var recipe = categorizedRecipeModelObj.value.recipeList![index];
      if (recipe.id != null) {
        Get.find<GlobalSaveManager>().toggleSave(recipe.id!);
      }
    }
  }
}
