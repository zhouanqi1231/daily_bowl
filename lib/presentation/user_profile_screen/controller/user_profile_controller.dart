import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../../core/global_save_manager.dart';
import '../models/recipe_item_model.dart';
import '../models/user_profile_model.dart';

class DailyActivity {
  int created = 0;
  int saved = 0;
  int cooked = 0;

  int get total => created + saved + cooked;
}

class UserProfileController extends GetxController {
  final isLoading = false.obs;
  final userProfileModel = Rx<UserProfileModel?>(null);
  final GlobalSaveManager _saveManager = Get.find<GlobalSaveManager>();
  
  // Detailed activity data
  final activityData = <DateTime, DailyActivity>{}.obs;

  // Popup state
  final showPopup = false.obs;
  final popupActivity = Rx<DailyActivity?>(null);
  final popupDate = Rx<DateTime?>(null);
  Timer? _popupTimer;

  // Heatmap scrolling
  final heatmapScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _initializeUserProfile();
    
    // Listen to changes in savedIds
    ever(_saveManager.savedIds, (Set<int> ids) {
      if (userProfileModel.value != null && !isClosed) {
        userProfileModel.value!.saveCount?.value = ids.length;
        _initializeUserProfile(); 
      }
    });
  }

  Future<void> _initializeUserProfile() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('user_name');
    String? email = prefs.getString('user_email');
    int? userId = prefs.getInt('user_id');
    
    String displayName = "Amy Perkins";
    
    if (storedName != null && storedName.isNotEmpty) {
      displayName = storedName;
    } else if (email != null && email.isNotEmpty) {
      displayName = email.split('@')[0];
      displayName = displayName[0].toUpperCase() + displayName.substring(1);
    }

    Map<DateTime, DailyActivity> tempActivity = {};

    // Load cooked dates from local storage
    List<String> cookedDates = prefs.getStringList('cooked_dates') ?? [];
    for (var dateStr in cookedDates) {
      try {
        DateTime date = DateTime.parse(dateStr);
        DateTime day = DateTime(date.year, date.month, date.day);
        tempActivity.putIfAbsent(day, () => DailyActivity()).cooked++;
      } catch (e) {}
    }

    if (userId != null) {
      try {
        int recipeCount = 0;
        List<RecipeItemModel> userRecipes = [];

        // Fetch created recipes
        final recipesResponse = await ApiClient.get('/users/$userId/recipes/');
        if (isClosed) return;
        if (recipesResponse is List) {
          recipeCount = recipesResponse.length;
          userRecipes = recipesResponse.map((r) {
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

        // Fetch saved recipes
        final savesResponse = await ApiClient.get('/users/$userId/saves/');
        if (isClosed) return;
        if (savesResponse is List) {
          for (var s in savesResponse) {
             if (s['created_at'] != null) {
              DateTime date = DateTime.parse(s['created_at']).toLocal();
              DateTime day = DateTime(date.year, date.month, date.day);
              tempActivity.putIfAbsent(day, () => DailyActivity()).saved++;
            }
          }
        }
        
        if (!isClosed) {
          activityData.value = tempActivity;
          userProfileModel.value = UserProfileModel(
            userName: displayName.obs,
            recipeCount: recipeCount.obs,
            saveCount: _saveManager.savedIds.length.obs,
            recipes: userRecipes.obs,
          );
        }
      } catch (e) {
        print("Error fetching profile details: $e");
        if (!isClosed) {
          activityData.value = tempActivity;
          _loadMockData(displayName);
        }
      }
    } else {
      if (!isClosed) {
        activityData.value = tempActivity;
        _loadMockData(displayName);
      }
    }
    
    if (!isClosed) {
      isLoading.value = false;
      // After loading data, wait for frame and scroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToCurrentWeek();
      });
    }
  }

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
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
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

  void onActivityTap(DateTime date, DailyActivity activity) {
    _popupTimer?.cancel();
    popupDate.value = date;
    popupActivity.value = activity;
    showPopup.value = true;

    _popupTimer = Timer(Duration(seconds: 4), () {
      if (!isClosed) {
        showPopup.value = false;
      }
    });
  }

  void onSharePressed() async {
    try {
      await Share.share(
        'Check out ${userProfileModel.value?.userName?.value ?? "Amy Perkins"}\'s amazing recipes on Recipe Master! 🍳👨‍🍳',
        subject: 'Recipe Master - User Profile',
      );
    } catch (e) {
      if (isClosed) return;
      Get.snackbar('Share Error', 'Unable to share at the moment.');
    }
  }

  void onRecipeTap(int index) {
    final recipe = userProfileModel.value?.recipes?[index];
    if (recipe != null && recipe.id != null) {
      Get.toNamed(AppRoutes.recipeDetailScreen, arguments: {'id': recipe.id});
    }
  }

  void onEditRecipe(int index) {
    final recipe = userProfileModel.value?.recipes?[index];
    if (recipe != null && recipe.id != null) {
      Get.toNamed(AppRoutes.recipeCreationScreen, arguments: {'id': recipe.id});
    }
  }

  void onDeleteRecipe(int index) {
    final recipe = userProfileModel.value?.recipes?[index];
    if (recipe == null || recipe.id == null) return;

    Get.dialog(
      AlertDialog(
        title: Text('Delete Recipe'),
        content: Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: appTheme.blue_gray_400)),
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
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void refreshUserProfile() {
    _initializeUserProfile();
  }

  @override
  void onClose() {
    _popupTimer?.cancel();
    heatmapScrollController.dispose();
    super.onClose();
  }
}
