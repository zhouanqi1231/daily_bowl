import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../../core/global_save_manager.dart';
import '../models/recipe_item_model.dart';
import '../models/user_profile_model.dart';

/// Represents the daily activity counts for a user.
class DailyActivity {
  /// Number of recipes created on this day.
  int created = 0;

  /// Number of recipes saved on this day.
  int saved = 0;

  /// Number of recipes cooked on this day.
  int cooked = 0;

  /// Total count of all activities for the day.
  int get total => created + saved + cooked;
}

/// A controller class for the UserProfileScreen.
///
/// This class manages the user's profile information, activity history (heatmap),
/// and the list of recipes they have created. It handles fetching data from
/// both local storage (cooked dates) and the backend API.
class UserProfileController extends GetxController {
  /// Observable boolean to track loading state.
  final isLoading = false.obs;

  /// Observable object for the user profile model.
  final userProfileModel = Rx<UserProfileModel?>(null);

  final GlobalSaveManager _saveManager = Get.find<GlobalSaveManager>();
  
  /// Observable map of dates to daily activity data, used for the heatmap.
  final activityData = <DateTime, DailyActivity>{}.obs;

  /// Observable boolean to show/hide the activity detail popup.
  final showPopup = false.obs;

  /// Observable object for the activity data currently shown in the popup.
  final popupActivity = Rx<DailyActivity?>(null);

  /// Observable object for the date currently shown in the popup.
  final popupDate = Rx<DateTime?>(null);

  Timer? _popupTimer;

  /// Scroll controller for the activity heatmap.
  final heatmapScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initializeUserProfile();
    
    // Listen to changes in savedIds to update save count and profile data.
    ever(_saveManager.savedIds, (Set<int> ids) {
      if (userProfileModel.value != null && !isClosed) {
        userProfileModel.value!.saveCount?.value = ids.length;
        _initializeUserProfile(); 
      }
    });
  }

  /// Main initialization flow to load all profile data.
  Future<void> _initializeUserProfile() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    
    final displayName = _getDisplayName(prefs);
    final userId = prefs.getInt('user_id');
    final Map<DateTime, DailyActivity> tempActivity = {};

    _loadLocalCookedActivity(prefs, tempActivity);

    if (userId != null) {
      await _loadServerData(userId, displayName, tempActivity);
    } else {
      _setMockProfile(displayName, tempActivity);
    }
    
    _completeLoading();
  }

  /// Determines the user's display name from preferences (username or email).
  String _getDisplayName(SharedPreferences prefs) {
    String? storedName = prefs.getString('user_name');
    String? email = prefs.getString('user_email');
    
    if (storedName != null && storedName.isNotEmpty) {
      return storedName;
    } else if (email != null && email.isNotEmpty) {
      String name = email.split('@')[0];
      return name[0].toUpperCase() + name.substring(1);
    }
    return "UserName";
  }

  /// Loads cooked dates from local storage and populates the [tempActivity] map.
  void _loadLocalCookedActivity(SharedPreferences prefs, Map<DateTime, DailyActivity> tempActivity) {
    List<String> cookedDates = prefs.getStringList('cooked_dates') ?? [];
    for (var dateStr in cookedDates) {
      try {
        DateTime date = DateTime.parse(dateStr);
        DateTime day = DateTime(date.year, date.month, date.day);
        tempActivity.putIfAbsent(day, () => DailyActivity()).cooked++;
      } catch (e) {
        // Ignore parsing errors for individual dates
      }
    }
  }

  /// Fetches recipes and saves from the server to populate the profile and activity map.
  Future<void> _loadServerData(int userId, String displayName, Map<DateTime, DailyActivity> tempActivity) async {
    try {
      // 0. Fetch basic user details (including allergies)
      String allergyStr = "";
      try {
        final userData = await ApiClient.get('/users/$userId/');
        if (userData != null) {
          allergyStr = (userData['allergies'] ?? userData['allergy'] ?? "").toString();
          // Update local cache
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_allergies', allergyStr);
        }
      } catch (e) {
        // print("Error fetching user details: $e");
      }

      // 1. Fetch created recipes and update activity
      final recipes = await _fetchCreatedRecipes(userId, tempActivity);
      
      // 2. Fetch saved recipes and update activity
      await _fetchSavedRecipes(userId, tempActivity);

      if (!isClosed) {
        activityData.value = tempActivity;
        userProfileModel.value = UserProfileModel(
          userName: displayName.obs,
          recipeCount: recipes.length.obs,
          saveCount: _saveManager.savedIds.length.obs,
          recipes: recipes.obs,
          allergies: allergyStr.obs,
        );
      }
    } catch (e) {
      // print("Error fetching profile details: $e");
      if (!isClosed) {
        activityData.value = tempActivity;
        _loadMockData(displayName);
      }
    }
  }

  /// Fetches recipes created by the user and updates the [tempActivity] map.
  Future<List<RecipeItemModel>> _fetchCreatedRecipes(int userId, Map<DateTime, DailyActivity> tempActivity) async {
    final response = await ApiClient.get('/users/$userId/recipes/');
    if (isClosed || response is! List) return [];

    return response.map<RecipeItemModel>((r) {
      if (r['created_at'] != null) {
        DateTime date = DateTime.parse(r['created_at']).toLocal();
        DateTime day = DateTime(date.year, date.month, date.day);
        tempActivity.putIfAbsent(day, () => DailyActivity()).created++;
      }
      
      String? imageUrl = r['img_url'];
      return RecipeItemModel(
        id: r['id'],
        title: (r['title'] as String? ?? "No Title").obs,
        description: (r['procedure'] as String? ?? "No Procedure").obs,
        imagePath: (imageUrl != null && imageUrl.isNotEmpty 
            ? imageUrl 
            : ImageConstant.imgMedia).obs,
      );
    }).toList();
  }

  /// Fetches recipes saved by the user and updates the [tempActivity] map.
  Future<void> _fetchSavedRecipes(int userId, Map<DateTime, DailyActivity> tempActivity) async {
    final response = await ApiClient.get('/users/$userId/saves/');
    if (isClosed || response is! List) return;

    for (var s in response) {
      if (s['created_at'] != null) {
        DateTime date = DateTime.parse(s['created_at']).toLocal();
        DateTime day = DateTime(date.year, date.month, date.day);
        tempActivity.putIfAbsent(day, () => DailyActivity()).saved++;
      }
    }
  }

  /// Sets up mock profile data for unauthenticated users.
  void _setMockProfile(String displayName, Map<DateTime, DailyActivity> tempActivity) {
    if (!isClosed) {
      activityData.value = tempActivity;
      _loadMockData(displayName);
    }
  }

  /// Cleans up the loading state and scrolls the heatmap to the current week.
  void _completeLoading() {
    if (!isClosed) {
      isLoading.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToCurrentWeek();
      });
    }
  }

  /// Animates the heatmap scroll position to the current week.
  void scrollToCurrentWeek() {
    if (!heatmapScrollController.hasClients) return;

    final today = DateTime.now();
    final firstDayOfYear = DateTime(today.year, 1, 1);
    int startOffset = firstDayOfYear.weekday % 7;
    DateTime startDate = firstDayOfYear.subtract(Duration(days: startOffset));
    
    int daysDiff = today.difference(startDate).inDays;
    int currentWeekIndex = daysDiff ~/ 7;

    double weekColumnWidth = 18.h; // matches the width in UI
    double viewportWidth = Get.width - 32.h; // section padding/margins subtracted

    double targetOffset = (currentWeekIndex * weekColumnWidth) + (weekColumnWidth / 2) - (viewportWidth / 2);
    
    // Clamp to valid range
    double maxScroll = heatmapScrollController.position.maxScrollExtent;
    if (targetOffset < 0) targetOffset = 0;
    if (targetOffset > maxScroll) targetOffset = maxScroll;

    heatmapScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  /// Loads static mock data for the profile.
  void _loadMockData(String displayName) {
     userProfileModel.value = UserProfileModel(
      userName: displayName.obs,
      recipeCount: 4.obs,
      saveCount: 128.obs,
      recipes: [
        RecipeItemModel(
          id: 1,
          title: "Stir-fried Tomato and Eggs".obs,
          description: "This is a simple and classic dish ...".obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
      ].obs,
    );
  }

  /// Shows the activity detail popup for a specific [date] and [activity].
  void onActivityTap(DateTime date, DailyActivity activity) {
    _popupTimer?.cancel();
    popupDate.value = date;
    popupActivity.value = activity;
    showPopup.value = true;

    _popupTimer = Timer(const Duration(seconds: 4), () {
      if (!isClosed) {
        showPopup.value = false;
      }
    });
  }

  /// Navigates to the recipe detail screen for the selected recipe.
  void onRecipeTap(int index) {
    final recipe = userProfileModel.value?.recipes?[index];
    if (recipe != null && recipe.id != null) {
      Get.toNamed(AppRoutes.recipeDetailScreen, arguments: {'id': recipe.id});
    }
  }

  /// Navigates to the recipe creation/edit screen for the selected recipe.
  void onEditRecipe(int index) {
    final recipe = userProfileModel.value?.recipes?[index];
    if (recipe != null && recipe.id != null) {
      Get.toNamed(AppRoutes.recipeCreationScreen, arguments: {'id': recipe.id});
    }
  }

  /// Shows a confirmation dialog and deletes the selected recipe if confirmed.
  void onDeleteRecipe(int index) {
    final recipe = userProfileModel.value?.recipes?[index];
    if (recipe == null || recipe.id == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: appTheme.blueGray_400)),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              try {
                await ApiClient.delete('/recipes/${recipe.id}/');
                userProfileModel.value?.recipes?.removeAt(index);
                userProfileModel.value?.recipeCount?.value--;
                userProfileModel.refresh();
                Get.snackbar('Success', 'Recipe deleted successfully');
              } catch (e) {
                Get.snackbar('Error', 'Failed to delete recipe');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Refreshes the user profile data.
  Future<void> refreshUserProfile() async {
    await _initializeUserProfile();
  }

  @override
  void onClose() {
    _popupTimer?.cancel();
    heatmapScrollController.dispose();
    super.onClose();
  }
}
