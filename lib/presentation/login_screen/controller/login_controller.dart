import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';

class LoginController extends GetxController {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    idController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login(VoidCallback onSuccess) async {
    if (idController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both username and password');
      return;
    }

    try {
      // The swagger shows POST /users/ for registration, 
      // but typical login might be a different endpoint if not using API keys directly.
      // Based on the provided swagger, it seems the system uses API keys for protected endpoints.
      // If there's no specific 'login' endpoint, we might just try to fetch user info 
      // using the provided credentials or assume a 'session' if applicable.
      // However, usually login would return an API key.
      
      // Since a specific login endpoint isn't defined in the swagger (only registration), 
      // I will implement a placeholder that navigates on success as requested.
      // In a real scenario, we'd call an auth endpoint here.
      
      // For now, let's assume successful login for any non-empty input to allow testing.
      onSuccess();
      
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    }
  }

  void onLoginPressed() {
    Get.offAllNamed(AppRoutes.mainContainer);
  }
}
