import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import './controller/login_controller.dart';

/// A screen that provides a login interface for the user.
///
/// This screen allows users to enter their email and password to authenticate.
/// It also provides a way to navigate to the registration flow.
class LoginScreen extends GetWidget<LoginController> {
  /// Optional callback to be executed when the register button is pressed.
  final VoidCallback? onRegisterPressed;

  const LoginScreen({super.key, this.onRegisterPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
              // email input field
              CustomFloatingTextField(
                placeholder: "Email",
                controller: controller.emailController,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
              ),
              SizedBox(height: 16.h),
              // pwd input field
              Obx(
                () => CustomFloatingTextField(
                  placeholder: "Password",
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  textStyle: TextStyleHelper.instance.body14RegularRoboto
                      .copyWith(color: appTheme.gray_900),
                  labelStyle: TextStyleHelper.instance.body14RegularRoboto
                      .copyWith(color: appTheme.gray_600),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20.h,
                      color: appTheme.gray_500,
                    ),
                    onPressed: () => controller.obscurePassword.toggle(),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  // register button: jump to register
                  Expanded(
                    child: CustomButton(
                      text: "Register",
                      width: double.infinity,
                      backgroundColor: appTheme.gray_700,
                      textColor: appTheme.white_A700,
                      onPressed: onRegisterPressed ?? () => controller.onRegisterPressed(),
                    ),
                  ),
                  SizedBox(width: 20.h),
                  // login button
                  Expanded(
                    child: CustomButton(
                      text: "Login",
                      width: double.infinity,
                      backgroundColor: appTheme.deepPurple800,
                      textColor: appTheme.white_A700,
                      onPressed: () => controller.login(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
