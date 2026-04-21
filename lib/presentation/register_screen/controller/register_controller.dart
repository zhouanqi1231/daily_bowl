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

  void onLoginPressed() {}
}
