import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class is used in the [settings_menu_screen] screen with GetX.

class SettingsMenuModel {
  Rx<String>? profileSettingsText;
  Rx<String>? myAllergiesText;
  Rx<String>? logoutText;

  SettingsMenuModel({
    this.profileSettingsText,
    this.myAllergiesText,
    this.logoutText,
  }) {
    profileSettingsText = profileSettingsText ?? Rx("Profile Settings");
    myAllergiesText = myAllergiesText ?? Rx("My Allergies");
    logoutText = logoutText ?? Rx("Logout");
  }
}
