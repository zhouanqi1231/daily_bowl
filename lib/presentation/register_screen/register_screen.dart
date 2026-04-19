import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_floating_text_field.dart';
import './controller/register_controller.dart';

class RegisterScreen extends GetWidget<RegisterController> {
  final VoidCallback? onLoginPressed;
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
              SizedBox(height: 100.h), // Top padding to avoid status bar
              CustomFloatingTextField(
                placeholder: "Your ID",
                controller: controller.idController,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
              ),
              SizedBox(height: 16.h),
              CustomFloatingTextField(
                placeholder: "Password",
                controller: controller.passwordController,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
              ),
              SizedBox(height: 16.h),
              CustomFloatingTextField(
                placeholder: "Repeat Password",
                controller: controller.repeatPasswordController,
                textStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_900),
                labelStyle: TextStyleHelper.instance.body14RegularRoboto
                    .copyWith(color: appTheme.gray_600),
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
                      onPressed: onRegisterSuccess,
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
