import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_export.dart';
import '../../../core/network/api_client.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login(VoidCallback onSuccess) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password');
      return;
    }

    try {
      final response = await ApiClient.post('/tokens/', {
        'email': emailController.text,
        'pwd': passwordController.text,
      });

      if (response != null && response['token'] != null) {
        // Persist session token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('api_key', response['token']);
        // We might want to store the email too
        await prefs.setString('user_email', emailController.text);

        // Fetch user profile to get the username and ID
        try {
          final usersResponse = await ApiClient.get('/users/');
          if (usersResponse is List) {
            final currentUser = usersResponse.firstWhere(
              (u) => u['email'] == emailController.text,
              orElse: () => null,
            );
            if (currentUser != null) {
              if (currentUser['username'] != null) {
                await prefs.setString('user_name', currentUser['username']);
              }
              if (currentUser['id'] != null) {
                await prefs.setInt('user_id', currentUser['id']);
              }
            }
          }
        } catch (e) {
          print("Error fetching user profile after login: $e");
        }

        Get.snackbar('Success', 'Login successful!');
        onSuccess();
      }
    } catch (e) {
      Get.snackbar('Login Failed', 'Invalid email or password.');
    }
  }

  void onLoginPressed() {
    // This is handled by the parent
  }
}
