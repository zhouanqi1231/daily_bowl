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
    // Navigate to user profile screen
    Get.toNamed(AppRoutes.userProfileScreen);
  }

  void onMyAllergiesTap() {
    // Navigate to allergy setting screen
    Get.toNamed(AppRoutes.allergySettingScreen);
  }
}
