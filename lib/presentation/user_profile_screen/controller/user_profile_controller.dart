import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../models/recipe_item_model.dart';
import '../models/user_profile_model.dart';

class UserProfileController extends GetxController {
  final isLoading = false.obs;
  final userProfileModel = Rx<UserProfileModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeUserProfile();
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

    if (userId != null) {
      try {
        int recipeCount = 0;
        int saveCount = 0;
        List<RecipeItemModel> userRecipes = [];

        // Fetch recipes created by user (My Recipes)
        final recipesResponse = await ApiClient.get('/users/$userId/recipes/');
        if (recipesResponse is List) {
          recipeCount = recipesResponse.length;
          userRecipes = recipesResponse.map((r) {
            return RecipeItemModel(
              title: (r['title'] as String? ?? "No Title").obs,
              description: (r['procedure'] as String? ?? "No Procedure").obs,
              imagePath: ImageConstant.imgMedia.obs,
            );
          }).toList();
        }

        // Fetch saved recipes for user (Saves)
        final savesResponse = await ApiClient.get('/users/$userId/saves/');
        if (savesResponse is List) {
          saveCount = savesResponse.length;
        }

        userProfileModel.value = UserProfileModel(
          userName: displayName.obs,
          recipeCount: recipeCount.obs,
          saveCount: saveCount.obs,
          recipes: userRecipes.obs,
        );
      } catch (e) {
        print("Error fetching profile details: $e");
        _loadMockData(displayName);
      }
    } else {
      _loadMockData(displayName);
    }
    isLoading.value = false;
  }
  
  void _loadMockData(String displayName) {
     userProfileModel.value = UserProfileModel(
      userName: displayName.obs,
      recipeCount: 4.obs,
      saveCount: 128.obs,
      recipes: [
        RecipeItemModel(
          title: "Stir-fried Tomato and Eggs".obs,
          description: "This is a simple and classic dish ...".obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: "Stir-fried Tomato and Eggs".obs,
          description: "This is a simple and classic dish ...".obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: "Stir-fried Tomato and Eggs".obs,
          description: "This is a simple and classic dish ...".obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
        RecipeItemModel(
          title: "Stir-fried Tomato and Eggs".obs,
          description: "This is a simple and classic dish ...".obs,
          imagePath: ImageConstant.imgMedia.obs,
        ),
      ].obs,
    );
  }

  void onSharePressed() async {
    try {
      await Share.share(
        'Check out ${userProfileModel.value?.userName?.value ?? "Amy Perkins"}\'s amazing recipes on Recipe Master! 🍳👨‍🍳',
        subject: 'Recipe Master - User Profile',
      );
    } catch (e) {
      Get.snackbar(
        'Share Error',
        'Unable to share at the moment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.redCustom,
        colorText: appTheme.whiteCustom,
      );
    }
  }

  void onRecipeTap(int index) {
    final recipe = userProfileModel.value?.recipes?[index];
    if (recipe != null) {
      Get.toNamed(AppRoutes.recipeDetailScreen);
    }
  }

  void refreshUserProfile() {
    _initializeUserProfile();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
