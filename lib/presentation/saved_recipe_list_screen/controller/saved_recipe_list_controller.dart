import 'package:daily_bowl/core/global_save_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../core/app_export.dart';
import '../models/saved_recipe_list_model.dart';

class SavedRecipeListController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final recipeList = <SavedRecipeListModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    ever(Get.find<GlobalSaveManager>().savedIds, (_) {
      initializeRecipeList();
    });

    initializeRecipeList();
  }

  Future<void> initializeRecipeList() async {
    final savedIds = Get.find<GlobalSaveManager>().savedIds.toList();
    
    if (savedIds.isEmpty) {
      recipeList.clear(); 
      return;
    }

    isLoading.value = true;
    try {
      List<SavedRecipeListModel> fetchedRecipes = [];

      for (int recipeId in savedIds) {
        try {
          final recipeDetail = await ApiClient.get('/recipes/$recipeId/');
          if (recipeDetail != null) {
            fetchedRecipes.add(
              SavedRecipeListModel(
                id: recipeDetail['id'], 
                title: (recipeDetail['title'] as String? ?? "No Title").obs,
                description: (recipeDetail['procedure'] as String? ?? "").obs, 
                imagePath: ImageConstant.imgMedia.obs,
              )
            );
          }
        } catch (e) {
          print("Failed to load details for recipe $recipeId: $e");
        }
      }

      recipeList.value = fetchedRecipes;
    } catch (e) {
      print("Error fetching saved recipes details: $e");
    } finally {
      isLoading.value = false;
    }
  }
  void onRecipeTap(int index) {
    final recipe = recipeList[index];
    if (recipe.id != null) {
      Get.toNamed(AppRoutes.recipeDetailScreen, arguments: {'id': recipe.id});
    }
  }

  Future<void> refreshRecipes() async {
    await Get.find<GlobalSaveManager>().fetchInitialSaves();
  }
}