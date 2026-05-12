import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import './controller/login_controller.dart';

class LoginScreen extends GetWidget<LoginController> {
  final VoidCallback? onRegisterPressed;

  const LoginScreen({Key? key, this.onRegisterPressed}) : super(key: key);

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
              CustomFloatingTextField(
                placeholder: "Password",
                controller: controller.passwordController,
                obscureText: true,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
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
                      backgroundColor: appTheme.deep_purple_800,
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
