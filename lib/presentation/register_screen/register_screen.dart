import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import './controller/register_controller.dart';

/// A screen that provides a registration interface for new users.
///
/// This screen allows users to enter a username, email, and password (with confirmation)
/// to create a new account.
class RegisterScreen extends GetWidget<RegisterController> {
  /// Callback to be executed when the user opts to navigate back to the login screen.
  final VoidCallback? onLoginPressed;

  /// Callback to be executed upon successful registration.
  final VoidCallback? onRegisterSuccess;

  const RegisterScreen({Key? key, this.onLoginPressed, this.onRegisterSuccess})
      : super(key: key);

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
              CustomFloatingTextField(
                placeholder: "Username",
                controller: controller.usernameController,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
              ),
              SizedBox(height: 16.h),
              CustomFloatingTextField(
                placeholder: "Email",
                controller: controller.emailController,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
              ),
              SizedBox(height: 16.h),
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
              SizedBox(height: 16.h),
              Obx(
                () => CustomFloatingTextField(
                  placeholder: "Repeat Password",
                  controller: controller.repeatPasswordController,
                  obscureText: controller.obscureRepeatPassword.value,
                  textStyle: TextStyleHelper.instance.body14RegularRoboto
                      .copyWith(color: appTheme.gray_900),
                  labelStyle: TextStyleHelper.instance.body14RegularRoboto
                      .copyWith(color: appTheme.gray_600),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscureRepeatPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20.h,
                      color: appTheme.gray_500,
                    ),
                    onPressed: () => controller.obscureRepeatPassword.toggle(),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Login",
                      width: double.infinity,
                      backgroundColor: appTheme.gray_700,
                      textColor: appTheme.white_A700,
                      onPressed: onLoginPressed,
                    ),
                  ),
                  SizedBox(width: 20.h),
                  Expanded(
                    child: CustomButton(
                      text: "Register",
                      width: double.infinity,
                      backgroundColor: appTheme.deep_purple_800,
                      textColor: appTheme.white_A700,
                      onPressed: () {
                        if (onRegisterSuccess != null) {
                          controller.register(onRegisterSuccess!);
                        }
                      },
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
