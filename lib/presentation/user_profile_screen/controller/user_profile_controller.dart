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
        String allergiesStr = "";

        // Fetch user detail
        final userData = await ApiClient.get('/users/$userId/');
        if (isClosed) return;
        if (userData != null) {
          allergiesStr = (userData['allergies'] ?? userData['allergy'] ?? "").toString();
        }

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
            allergies: allergiesStr.obs,
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
    if (!isClosed) isLoading.value = false;
  }
  
  void _loadMockData(String displayName) {
     userProfileModel.value = UserProfileModel(
      userName: displayName.obs,
      recipeCount: 4.obs,
      saveCount: 128.obs,
      allergies: "".obs,
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

  void refreshUserProfile() {
    _initializeUserProfile();
  }

  @override
  void onClose() {
    _popupTimer?.cancel();
    super.onClose();
  }
}
