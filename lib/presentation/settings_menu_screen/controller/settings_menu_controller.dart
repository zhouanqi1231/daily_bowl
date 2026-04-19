import '../../main_container_screen/controller/main_container_controller.dart';
import 'package:daily_bowl/presentation/user_profile_screen/controller/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_export.dart';
import '../models/settings_menu_model.dart';
import '../../../core/network/api_client.dart';
import '../../explore_screen/controller/explore_controller.dart';

class SettingsMenuController extends GetxController {
  Rx<SettingsMenuModel> settingsMenuModelObj = SettingsMenuModel().obs;
  RxBool isLoggedIn = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
  }

  void _checkInitialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getString('api_key') != null;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onProfileSettingsTap() {
    // Show "under development" snackbar as requested
    Get.snackbar(
      'Notice',
      'Under development',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16.h),
    );
  }

  void onMyAllergiesTap() {
    // Navigate to allergy setting screen
    Get.toNamed(AppRoutes.allergySettingScreen);
  }

  Future<void> onLogoutTap() async {
    try {
      // delete token
      await ApiClient.delete('/tokens/');
    } catch (e) {
      print("Logout API call failed: $e");
    } finally {
      // clear locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      isLoggedIn.value = false;

      // refresh login status
      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().refreshUserProfile();
      }
      if (Get.isRegistered<ExploreController>()) {
        Get.find<ExploreController>().checkLoginStatus();
      }

      if (Get.isRegistered<MainContainerController>()) {
        Get.find<MainContainerController>().checkLoginStatus();
      }
      
      Get.back();
      Get.snackbar('Success', 'Logged out successfully');
    }
  }
}
