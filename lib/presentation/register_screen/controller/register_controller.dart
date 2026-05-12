import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';

/// A controller class for the RegisterScreen.
///
/// This class manages the registration process, including text controllers
/// for user input, validation, and interaction with the backend API.
class RegisterController extends GetxController {
  /// Controller for the username input field.
  TextEditingController usernameController = TextEditingController();

  /// Controller for the email input field.
  TextEditingController emailController = TextEditingController();

  /// Controller for the password input field.
  TextEditingController passwordController = TextEditingController();

  /// Controller for the repeat password input field to verify password entry.
  TextEditingController repeatPasswordController = TextEditingController();

  /// Observable boolean to track password visibility.
  RxBool obscurePassword = true.obs;

  /// Observable boolean to track repeat password visibility.
  RxBool obscureRepeatPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    obscurePassword.value = true;
    obscureRepeatPassword.value = true;
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.onClose();
  }

  /// Attempts to register a new user with the provided credentials.
  ///
  /// [onSuccess] A callback function executed when registration is successful.
  Future<void> register(VoidCallback onSuccess) async {
    if (usernameController.text.isEmpty || 
        emailController.text.isEmpty || 
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (passwordController.text != repeatPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      final response = await ApiClient.post('/users/', {
        'username': usernameController.text,
        'email': emailController.text,
        'pwd': passwordController.text,
      });

      if (response != null) {
        Get.snackbar('Success', 'Registration successful! Please login.');
        // Clear fields for next use
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        repeatPasswordController.clear();
        
        // This callback should trigger the switch back to LoginScreen
        onSuccess();
      }
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    }
  }

  /// Placeholder for login button press action.
  void onLoginPressed() {}
}
