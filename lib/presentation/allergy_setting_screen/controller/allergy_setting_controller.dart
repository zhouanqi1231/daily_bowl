import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/allergy_setting_model.dart';
import '../models/allergy_item_model.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';

class AllergySettingController extends GetxController {
  Rx<AllergySettingModel> allergySettingModelObj = AllergySettingModel().obs;
  RxList<AllergyItemModel> allergyItems = <AllergyItemModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAllergyItems();
    _loadUserAllergies();
  }

  void _initializeAllergyItems() {
    // Standard list of common allergies
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

  Future<void> _loadUserAllergies() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      
      if (userId == null) return;

      final userData = await ApiClient.get('/users/$userId/');
      if (userData != null && userData['allergy'] != null) {
        String allergyStr = userData['allergy'].toString();
        List<String> userAllergies = allergyStr.split(',').map((e) => e.trim()).toList();

        for (var item in allergyItems) {
          if (userAllergies.contains(item.name?.value)) {
            item.isSelected?.value = true;
          }
        }
        allergyItems.refresh();
      }
    } catch (e) {
      print("Error loading allergies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleAllergy(int index, bool value) {
    if (index >= 0 && index < allergyItems.length) {
      allergyItems[index].isSelected?.value = value;
      allergyItems.refresh();
      // Auto-save when toggled
      saveAllergySettings();
    }
  }

  Future<void> saveAllergySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      String? username = prefs.getString('user_name');
      String? email = prefs.getString('user_email');
      
      if (userId == null) {
        Get.snackbar("Error", "Please login to save settings");
        return;
      }

      if (email == null || email.isEmpty) {
        Get.snackbar("Error", "User email not found. Please login again.");
        return;
      }

      List<String> selectedAllergies = getSelectedAllergies();
      String allergyString = selectedAllergies.join(', ');

      // Update the user profile with email, username and allergy
      Map<String, dynamic> updateBody = {
        'email': email,
        'allergy': allergyString,
      };

      // If we have a username, include it in the update body
      if (username != null && username.isNotEmpty) {
        updateBody['username'] = username;
      }

      await ApiClient.put('/users/$userId/', updateBody);

    } catch (e) {
      print("Error saving allergies: $e");
      Get.snackbar("Error", "Failed to update allergy settings");
    }
  }

  List<String> getSelectedAllergies() {
    return allergyItems
        .where((item) => item.isSelected?.value ?? false)
        .map((item) => item.name?.value ?? "")
        .toList();
  }
}
