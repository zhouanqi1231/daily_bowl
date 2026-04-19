import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../recipe_search_results_screen/models/recipe_item_model.dart';
import '../models/explore_model.dart';

class ExploreController extends GetxController {
  Rx<ExploreModel> exploreModelObj = ExploreModel().obs;

  // load and pagination
  RxBool isLoading = false.obs;    // is loading
  RxBool hasMoreData = true.obs;   // is db have more data
  int limit = 10;                  // request <limit> recipes each time
  int offset = 0;                  // offset

  @override
  void onInit() {
    super.onInit();
    exploreModelObj.value.recipeList = [];
    fetchRecipes(); // get first page when init
  }

  Future<void> fetchRecipes() async {
    // dont request if is loading or there are not more data
    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      
      var response = await ApiClient.get('/recipes/?limit=$limit&offset=$offset');
      
      List<dynamic> data = response;

      if (data.isEmpty) {
        hasMoreData.value = false;
      } else {
        List<RecipeItemModel> newRecipes = data.map((json) {
          return RecipeItemModel(
            recipeName: (json['title'] ?? 'Unknown Recipe').toString().obs,
            
            userName: "User ${json['created_by']}".obs,
            userInitial: "U".obs,
            userInfo: (json['cuisine_type'] ?? 'Home Chef').toString().obs, 
            recipeImage: ImageConstant.imgMedia188x364.obs,
            isBookmarked: false.obs,
          );
        }).toList();


        exploreModelObj.value.recipeList!.addAll(newRecipes);
        exploreModelObj.refresh();
        
        offset += limit;
      }
    } catch (e) {
      print("Error fetching recipes: $e");
      Get.snackbar("Fail to load", "Cannot get recipe data, please check internet connection.");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleBookmark(int index) {
    if (exploreModelObj.value.recipeList != null &&
        index < exploreModelObj.value.recipeList!.length) {
      var recipe = exploreModelObj.value.recipeList![index];
      recipe.isBookmarked?.value = !(recipe.isBookmarked?.value ?? false);
      exploreModelObj.refresh();

      // TODO: add saved status
    }
  }
}
