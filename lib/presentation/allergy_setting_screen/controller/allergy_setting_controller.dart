import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/allergy_setting_model.dart';
import '../models/allergy_item_model.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../user_profile_screen/controller/user_profile_controller.dart';

/// A controller class for the AllergySettingScreen to manage the state of the allergy settings.
///
/// This class manages the state of the allergy settings, including the list of allergy items,
/// loading status, and syncing with the backend and local storage.
class AllergySettingController extends GetxController {
  /// Observable object for allergy setting model.
  Rx<AllergySettingModel> allergySettingModelObj = AllergySettingModel().obs;

  /// Observable list of allergy items.
  RxList<AllergyItemModel> allergyItems = <AllergyItemModel>[].obs;

  /// Observable boolean to track loading state.
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAllergyItems();
    _loadAllergies();
  }

  /// Initializes the preset allergy items list.
  void _initializeAllergyItems() {
    allergyItems.value = [
      AllergyItemModel(name: "Peanut".obs, isSelected: false.obs),
      AllergyItemModel(name: "Tree Nut".obs, isSelected: false.obs),
      AllergyItemModel(name: "Egg".obs, isSelected: false.obs),
      AllergyItemModel(name: "Milk".obs, isSelected: false.obs),
      AllergyItemModel(name: "Fish".obs, isSelected: false.obs),
      AllergyItemModel(name: "Shellfish".obs, isSelected: false.obs),
      AllergyItemModel(name: "Soy".obs, isSelected: false.obs),
      AllergyItemModel(name: "Wheat".obs, isSelected: false.obs),
      AllergyItemModel(name: "Sesame".obs, isSelected: false.obs),
      AllergyItemModel(name: "Mustard".obs, isSelected: false.obs),
      AllergyItemModel(name: "Sulfite".obs, isSelected: false.obs),
      AllergyItemModel(name: "Celery".obs, isSelected: false.obs),
      AllergyItemModel(name: "Lupin".obs, isSelected: false.obs),
      AllergyItemModel(name: "Mollusc".obs, isSelected: false.obs),
    ];
  }

  /// Loads the user's allergy settings from local storage and the API.
  Future<void> _loadAllergies() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      
      // 1. Try to load from local cache first for speed
      String? cachedAllergies = prefs.getString('user_allergies');
      if (cachedAllergies != null && cachedAllergies.isNotEmpty) {
        _applyAllergiesToItems(cachedAllergies);
      }

      // 2. Then sync with API
      int? userId = prefs.getInt('user_id');
      if (userId != null) {
        final userData = await ApiClient.get('/users/$userId/');
        if (userData != null) {
          var allergiesValue = userData['allergies'] ?? userData['allergy'];
          if (allergiesValue != null) {
            String allergyStr = allergiesValue.toString();
            _applyAllergiesToItems(allergyStr);
            // Update cache with latest server data
            await prefs.setString('user_allergies', allergyStr);
          }
        }
      }
    } catch (e) {
      // print("Error loading allergies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Parses a comma-separated string of allergies and updates the [allergyItems] list.
  ///
  /// [allergyStr] A comma-separated string of allergy names.
  void _applyAllergiesToItems(String allergyStr) {
    List<String> userAllergies = allergyStr.split(',').map((e) => e.trim().toLowerCase()).toList();
    for (var item in allergyItems) {
      item.isSelected?.value = userAllergies.contains(item.name?.value.toLowerCase());
    }
    allergyItems.refresh();
  }

  /// Toggles the selection state of an allergy item at the given index.
  ///
  /// [index] The index of the allergy item in the list.
  /// [value] The new selection state.
  void toggleAllergy(int index, bool value) {
    if (index >= 0 && index < allergyItems.length) {
      allergyItems[index].isSelected?.value = value;
      allergyItems.refresh();
      saveAllergySettings();
    }
  }

  /// Saves the current allergy settings to local storage and the API.
  Future<void> saveAllergySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      String? username = prefs.getString('user_name');
      String? email = prefs.getString('user_email');
      
      if (userId == null || email == null) return;

      List<String> selectedAllergies = getSelectedAllergies();
      String allergyString = selectedAllergies.join(', ');

      // 1. Update local storage immediately
      await prefs.setString('user_allergies', allergyString);

      // 2. Update the user profile on backend
      Map<String, dynamic> updateBody = {
        'email': email,
        'allergies': allergyString,
      };

      if (username != null && username.isNotEmpty) {
        updateBody['username'] = username;
      }

      await ApiClient.put('/users/$userId/', updateBody);

      // 3. Refresh other controllers
      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().refreshUserProfile();
      }

      // 4. Success feedback
      Get.showSnackbar(GetSnackBar(
        message: 'Allergy settings updated',
        duration: const Duration(milliseconds: 800),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        borderRadius: 8.h,
        margin: EdgeInsets.all(16.h),
      ));

    } catch (e) {
      // print("Error saving allergies: $e");
      Get.snackbar("Error", "Failed to sync settings with server", 
        backgroundColor: Colors.red[900], colorText: Colors.white);
    }
  }

  /// Returns a list of the names of all selected allergies.
  List<String> getSelectedAllergies() {
    return allergyItems
        .where((item) => item.isSelected?.value ?? false)
        .map((item) => item.name?.value ?? "")
        .toList();
  }
}
