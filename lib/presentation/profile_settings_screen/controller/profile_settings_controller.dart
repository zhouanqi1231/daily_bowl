import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';
import '../../user_profile_screen/controller/user_profile_controller.dart';

class ProfileSettingsController extends GetxController {
  final isLoading = false.obs;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  final obscureCurrentPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  int? userId;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    nameController.text = prefs.getString('user_name') ?? '';
    emailController.text = prefs.getString('user_email') ?? '';
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? validateNewPassword(String? value) {
    // Only validate if user is trying to change password
    if (currentPasswordController.text.isEmpty &&
        newPasswordController.text.isEmpty &&
        confirmPasswordController.text.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) return 'New password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (currentPasswordController.text.isEmpty &&
        newPasswordController.text.isEmpty &&
        (value == null || value.isEmpty)) {
      return null;
    }
    if (value != newPasswordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> saveProfile() async {
    if (userId == null) {
      Get.snackbar('Error', 'User not found. Please log in again.');
      return;
    }

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final currentPwd = currentPasswordController.text;
    final newPwd = newPasswordController.text;

    // Validate required fields
    if (name.isEmpty) {
      Get.snackbar('Error', 'Name is required');
      return;
    }
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email is required');
      return;
    }

    // Validate password fields if user is changing password
    final isChangingPassword = currentPwd.isNotEmpty || newPwd.isNotEmpty;
    if (isChangingPassword) {
      if (currentPwd.isEmpty) {
        Get.snackbar('Error', 'Current password is required to set a new password');
        return;
      }
      if (newPwd.isEmpty) {
        Get.snackbar('Error', 'New password is required');
        return;
      }
      if (newPwd != confirmPasswordController.text) {
        Get.snackbar('Error', 'New passwords do not match');
        return;
      }
    }

    try {
      isLoading.value = true;

      final updateBody = <String, dynamic>{
        'email': email,
        'username': name,
      };

      if (isChangingPassword) {
        updateBody['current_pwd'] = currentPwd;
        updateBody['pwd'] = newPwd;
      }

      await ApiClient.put('/users/$userId/', updateBody);

      // Update local preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);

      // Refresh user profile controller
      if (Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().refreshUserProfile();
      }

      Get.showSnackbar(GetSnackBar(
        message: 'Profile updated successfully',
        duration: Duration(milliseconds: 1500),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        borderRadius: 8.h,
        margin: EdgeInsets.all(16.h),
      ));

      Get.back();
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar('Error', 'Failed to update profile. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
