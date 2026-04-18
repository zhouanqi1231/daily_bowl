import 'package:share_plus/share_plus.dart';

import '../../../core/app_export.dart';
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

  void _initializeUserProfile() {
    userProfileModel.value = UserProfileModel(
      userName: "Amy Perkins".obs,
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
      Get.snackbar(
        'Recipe Selected',
        'Opening ${recipe.title?.value ?? "recipe"}...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.deep_purple_800,
        colorText: appTheme.whiteCustom,
        duration: Duration(seconds: 2),
      );

      // Navigate to recipe details or creation screen
      Get.toNamed(AppRoutes.recipeCreationScreen);
    }
  }

  void refreshUserProfile() {
    isLoading.value = true;

    // Simulate API call
    Future.delayed(Duration(seconds: 1), () {
      _initializeUserProfile();
      isLoading.value = false;

      Get.snackbar(
        'Profile Updated',
        'Your profile has been refreshed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: appTheme.deep_purple_800,
        colorText: appTheme.whiteCustom,
      );
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
