import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../categorized_recipe_page/models/recipe_item_model.dart';
import '../models/explore_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/global_save_manager.dart';

/// A controller class for the ExploreScreen to manage the state of recipe exploration.
///
/// This class handles fetching recipes from the backend, pagination (infinite scroll),
/// checking user login status, and managing bookmarks (saves).
class ExploreController extends GetxController {
  /// Observable object for the explore model.
  Rx<ExploreModel> exploreModelObj = ExploreModel().obs;

  /// Observable boolean to track loading state for pagination.
  RxBool isLoading = false.obs;

  /// Observable boolean to track if more data is available on the server.
  RxBool hasMoreData = true.obs;

  /// Number of recipes to fetch per request.
  int limit = 10;

  /// Current offset for recipe pagination.
  int offset = 0;

  /// Observable boolean for the user's login status.
  RxBool isLoggedIn = false.obs;

  /// The ID of the currently logged-in user.
  int currentUserId = 0;

  /// Map to store userId -> username for quick lookup during recipe display.
  final Map<int, String> _userMap = {};

  @override
  void onInit() {
    super.onInit();
    exploreModelObj.value.recipeList = [];
    _initializeData();

    // Listen to global save manager changes to update local bookmark status.
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

  /// Initial data fetch sequence: users map, login status, and initial recipes.
  Future<void> _initializeData() async {
    await _fetchUsers(); // Fetch users first to populate names
    await checkLoginStatus();
    await fetchRecipes();
  }

  /// Fetches the list of all users to populate the [_userMap] for displaying creator names.
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
      // print("Error fetching users for map: $e");
    }
  }

  /// Checks the local storage for an API key to determine if the user is logged in.
  ///
  /// Updates [isLoggedIn] and [currentUserId], and refreshes recipe data if necessary.
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

  /// Fetches recipes from the backend API with pagination support.
  ///
  /// Uses [limit] and [offset] to manage data loading. Updates [exploreModelObj]
  /// with the new recipes and handles the [hasMoreData] state.
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
      // print("Error fetching recipes: $e");
      // Use addPostFrameCallback to avoid LateInitializationError if triggered during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Fail to load",
            "Cannot get recipe data, please check internet connection.");
      });
    } finally {
      isLoading.value = false;
    }
  }

  /// Resets the pagination and re-fetches the initial set of recipes and users.
  Future<void> refreshData() async {
    offset = 0;
    hasMoreData.value = true;
    
    exploreModelObj.value.recipeList?.clear();
    await _fetchUsers(); // Refresh users map too
    await fetchRecipes();
  }

  /// Toggles the bookmark status for a recipe at the given [index].
  ///
  /// Uses [GlobalSaveManager] to persist the change.
  void toggleBookmark(int index) async {
    // if not logged in, disable this button
    if (!isLoggedIn.value) return;

    var recipe = exploreModelObj.value.recipeList?[index];
    if (recipe == null || recipe.id == null) return;

    Get.find<GlobalSaveManager>().toggleSave(recipe.id!);
  }
}
