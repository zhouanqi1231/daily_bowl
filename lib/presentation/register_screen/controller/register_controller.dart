import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';

class RegisterController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.onClose();
  }

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

      // According to swagger, the response contains an api_key
      if (response != null && response['api_key'] != null) {
        // In a real app, we would save this API key securely (e.g., Flutter Secure Storage)
        // and update the ApiClient's header.
        Get.snackbar('Success', 'Registration successful!');
        onSuccess();
      }
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    }
  }

  void onLoginPressed() {
    // This is handled by the parent AnimatedSwitcher in MainContainer
  }
}
