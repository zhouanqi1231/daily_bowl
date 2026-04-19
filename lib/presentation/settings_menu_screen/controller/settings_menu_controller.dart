import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/settings_menu_model.dart';

class SettingsMenuController extends GetxController {
  Rx<SettingsMenuModel> settingsMenuModelObj = SettingsMenuModel().obs;

  @override
  void onInit() {
    super.onInit();
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
}
