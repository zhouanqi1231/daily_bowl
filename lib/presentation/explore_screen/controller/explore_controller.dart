import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../categorized_recipe_page/models/recipe_item_model.dart';
import '../models/explore_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/global_save_manager.dart';

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

  // Map to store userId -> username for quick lookup
  final Map<int, String> _userMap = {};

  @override
  void onInit() {
    super.onInit();
    exploreModelObj.value.recipeList = [];
    _initializeData();

    ever(Get.find<GlobalSaveManager>().savedIds, (Set<int> globalSavedIds) {
      if (exploreModelObj.value.recipeList != null) {
        for (var recipe in exploreModelObj.value.recipeList!) {
          if (recipe.id != null) {
            recipe.isBookmarked?.value = globalSavedIds.contains(recipe.id);
          }
        }
      }
    });
  }

  Future<void> _initializeData() async {
    await _fetchUsers(); // Fetch users first to populate names
    await checkLoginStatus();
    await fetchRecipes();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await ApiClient.get('/users/');
      if (response is List) {
        for (var user in response) {
          int? id = user['id'];
          String? name = user['username'];
          if (id != null && name != null) {
            _userMap[id] = name;
          }
        }
      }
    } catch (e) {
      print("Error fetching users for map: $e");
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('api_key');
    bool newStatus = token != null && token.isNotEmpty;

    if (newStatus != isLoggedIn.value || newStatus == true) {
      isLoggedIn.value = newStatus;

      if (isLoggedIn.value) {
        currentUserId = prefs.getInt('user_id') ?? 0;

        offset = 0;
        hasMoreData.value = true;
        exploreModelObj.value.recipeList?.clear();
        await fetchRecipes();
      } else {
        currentUserId = 0;
        Get.find<GlobalSaveManager>().savedIds.clear();
        exploreModelObj.refresh();
      }
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
          int creatorId = json['created_by'] ?? 0;
          
          // Use the fetched user name or fallback to ID
          String displayName = _userMap[creatorId] ?? "User $creatorId";
          String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : "U";
          
          // Use img_url if available, otherwise use default image
          String imageUrl = json['img_url']?.toString() ?? "";
          if (imageUrl.isEmpty) {
            imageUrl = ImageConstant.imgMedia188x364;
          }

          return RecipeItemModel(
            id: rId,
            recipeName: (json['title'] ?? 'Unknown Recipe').toString().obs,
            userName: displayName.obs,
            userInitial: initial.obs,
            userInfo: (json['cuisine_type'] ?? 'Home Chef').toString().obs,
            recipeImage: imageUrl.obs,
            isBookmarked: Get.find<GlobalSaveManager>().savedIds.contains(rId).obs,
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
      // Use addPostFrameCallback to avoid LateInitializationError if triggered during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Fail to load",
            "Cannot get recipe data, please check internet connection.");
      });
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> refreshData() async {
    offset = 0;
    hasMoreData.value = true;
    
    exploreModelObj.value.recipeList?.clear();
    await _fetchUsers(); // Refresh users map too
    await fetchRecipes();
  }

  void toggleBookmark(int index) async {
    // if not logged in, disable this button
    if (!isLoggedIn.value) return;

    var recipe = exploreModelObj.value.recipeList?[index];
    if (recipe == null || recipe.id == null) return;

    Get.find<GlobalSaveManager>().toggleSave(recipe.id!);
  }
}
