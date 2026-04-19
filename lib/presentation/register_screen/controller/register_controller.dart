import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class RegisterController extends GetxController {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  void onClose() {
    idController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.onClose();
  }

  void onRegisterPressed() {
    // Handle registration logic
    Get.offAllNamed(AppRoutes.mainContainer);
  }

  void onLoginPressed() {
    Get.back();
  }
}
