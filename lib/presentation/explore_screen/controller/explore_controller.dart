import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../recipe_search_results_screen/models/recipe_item_model.dart';
import '../models/explore_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreController extends GetxController {
  Rx<ExploreModel> exploreModelObj = ExploreModel().obs;

  // load and pagination
  RxBool isLoading = false.obs; // is loading
  RxBool hasMoreData = true.obs; // is db have more data
  int limit = 10; // request <limit> recipes each time
  int offset = 0; // offset

  // user login status vars
  RxBool isLoggedIn = false.obs;
  int currentUserId = 0;
  RxSet<int> savedRecipeIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    exploreModelObj.value.recipeList = [];
    _initializeData();
  }

  Future<void> _initializeData() async {
    await checkLoginStatus();
    await fetchRecipes();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');
    bool newStatus = token != null && token.isNotEmpty;

    if (newStatus != isLoggedIn.value || newStatus == true) {
      isLoggedIn.value = newStatus;

      if (isLoggedIn.value) {
        currentUserId = prefs.getInt('user_id') ?? 0;
        await _fetchUserSaves();

        offset = 0;
        hasMoreData.value = true;
        exploreModelObj.value.recipeList?.clear();
        await fetchRecipes();
      } else {
        currentUserId = 0;
        savedRecipeIds.clear();
        exploreModelObj.refresh();
      }
    }
  }

  Future<void> _fetchUserSaves() async {
    if (currentUserId == 0) return;
    try {
      var response = await ApiClient.get('/users/$currentUserId/saves/');

      if (response is List) {
        final Set<int> fetchedIds = {};
        for (var item in response) {
          if (item is Map && item['recipe_id'] != null) {
            fetchedIds.add(int.parse(item['recipe_id'].toString()));
          }
        }
        savedRecipeIds.value = fetchedIds;
      }
    } catch (e) {
      print("Error fetching saves: $e");
      savedRecipeIds.clear();
    }
  }

  Future<void> fetchRecipes() async {
    // dont request if is loading or there are not more data
    if (isLoading.value || !hasMoreData.value) return;

    try {
      isLoading.value = true;
      var response =
          await ApiClient.get('/recipes/?limit=$limit&offset=$offset');
      List<dynamic> data = response;

      if (data.isEmpty) {
        hasMoreData.value = false;
      } else {
        List<RecipeItemModel> newRecipes = data.map((json) {
          int rId = json['id'];
          return RecipeItemModel(
            id: rId,
            recipeName: (json['title'] ?? 'Unknown Recipe').toString().obs,
            userName: "User ${json['created_by']}".obs,
            userInitial: "U".obs,
            userInfo: (json['cuisine_type'] ?? 'Home Chef').toString().obs,
            recipeImage: ImageConstant.imgMedia188x364.obs,
            isBookmarked: (savedRecipeIds.contains(rId)).obs,
          );
        }).toList();

        exploreModelObj.value.recipeList!.addAll(newRecipes);
        exploreModelObj.refresh();
        offset += limit;

        // if length less than single page, stop loading
        if (data.length < limit) {
          hasMoreData.value = false;
        }
      }
    } catch (e) {
      print("Error fetching recipes: $e");
      Get.snackbar("Fail to load",
          "Cannot get recipe data, please check internet connection.");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleBookmark(int index) async {
    // if not logged in, disable this button
    if (!isLoggedIn.value) return;

    var recipe = exploreModelObj.value.recipeList?[index];
    if (recipe == null || recipe.id == null) return;

    int rId = recipe.id!;
    bool isCurrentlySaved = recipe.isBookmarked?.value ?? false;

    try {
      if (isCurrentlySaved) {
        await ApiClient.delete('/users/$currentUserId/saves/$rId/');
        recipe.isBookmarked?.value = false;
        savedRecipeIds.remove(rId);
      } else {
        try {
          await ApiClient.post(
              '/users/$currentUserId/saves/', {'recipe_id': rId});
        } catch (e) {
          // if return 409 means repeat request
          if (e.toString().contains('409')) {
            print("Server already has this save, syncing UI...");
          } else {
            rethrow;
          }
        }
        recipe.isBookmarked?.value = true;
        savedRecipeIds.add(rId);
      }
      exploreModelObj.refresh();
    } catch (e) {
      Get.snackbar("Error", "Failed to save this: {$e}");
    }
  }
}
