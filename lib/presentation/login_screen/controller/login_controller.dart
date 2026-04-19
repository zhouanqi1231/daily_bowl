import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class LoginController extends GetxController {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    idController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void onLoginPressed() {
    // Navigate to main container or profile
    Get.offAllNamed(AppRoutes.mainContainer);
  }

  void onRegisterPressed() {
    // Handle registration
  }
}
