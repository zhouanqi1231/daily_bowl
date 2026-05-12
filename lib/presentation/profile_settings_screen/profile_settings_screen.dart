import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_floating_text_field.dart';
import './controller/profile_settings_controller.dart';

class ProfileSettingsScreen extends GetWidget<ProfileSettingsController> {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      appBar: CustomAppBar(
        leadingIcon: ImageConstant.imgArrowLeft,
        onLeadingTap: () => Get.back(),
        backgroundColor: appTheme.transparentCustom,
        horizontalPadding: 16.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Profile Information'),
            SizedBox(height: 16.h),
            _buildNameField(),
            SizedBox(height: 16.h),
            _buildEmailField(),
            SizedBox(height: 32.h),
            _buildSectionTitle('Change Password'),
            SizedBox(height: 4.h),
            Text(
              'Leave blank if you don\'t want to change',
              style: TextStyleHelper.instance.body14RegularRoboto.copyWith(
                color: appTheme.gray_600,
              ),
            ),
            SizedBox(height: 16.h),
            _buildCurrentPasswordField(),
            SizedBox(height: 16.h),
            _buildNewPasswordField(),
            SizedBox(height: 16.h),
            _buildConfirmPasswordField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24.h, 16.h, 24.h, 16.h),
        child: _buildSaveButton(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
        color: appTheme.black_900,
      ),
    );
  }

  Widget _buildNameField() {
    return CustomFloatingTextField(
      placeholder: "Name",
      controller: controller.nameController,
      textStyle: TextStyleHelper.instance.body14RegularRoboto
          .copyWith(color: appTheme.gray_900),
      labelStyle: TextStyleHelper.instance.body14RegularRoboto
          .copyWith(color: appTheme.gray_600),
    );
  }

  Widget _buildEmailField() {
    return CustomFloatingTextField(
      placeholder: "Email",
      controller: controller.emailController,
      keyboardType: TextInputType.emailAddress,
      textStyle: TextStyleHelper.instance.body14RegularRoboto
          .copyWith(color: appTheme.gray_900),
      labelStyle: TextStyleHelper.instance.body14RegularRoboto
          .copyWith(color: appTheme.gray_600),
    );
  }

  Widget _buildCurrentPasswordField() {
    return Obx(
      () => CustomFloatingTextField(
        placeholder: "Current Password",
        controller: controller.currentPasswordController,
        obscureText: controller.obscureCurrentPassword.value,
        textStyle: TextStyleHelper.instance.body14RegularRoboto
            .copyWith(color: appTheme.gray_900),
        labelStyle: TextStyleHelper.instance.body14RegularRoboto
            .copyWith(color: appTheme.gray_600),
        suffixIcon: IconButton(
          icon: Icon(
            controller.obscureCurrentPassword.value
                ? Icons.visibility_off
                : Icons.visibility,
            size: 20.h,
            color: appTheme.gray_500,
          ),
          onPressed: () => controller.obscureCurrentPassword.toggle(),
        ),
      ),
    );
  }

  Widget _buildNewPasswordField() {
    return Obx(
      () => CustomFloatingTextField(
        placeholder: "New Password",
        controller: controller.newPasswordController,
        obscureText: controller.obscureNewPassword.value,
        textStyle: TextStyleHelper.instance.body14RegularRoboto
            .copyWith(color: appTheme.gray_900),
        labelStyle: TextStyleHelper.instance.body14RegularRoboto
            .copyWith(color: appTheme.gray_600),
        suffixIcon: IconButton(
          icon: Icon(
            controller.obscureNewPassword.value
                ? Icons.visibility_off
                : Icons.visibility,
            size: 20.h,
            color: appTheme.gray_500,
          ),
          onPressed: () => controller.obscureNewPassword.toggle(),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => CustomFloatingTextField(
        placeholder: "Confirm New Password",
        controller: controller.confirmPasswordController,
        obscureText: controller.obscureConfirmPassword.value,
        textStyle: TextStyleHelper.instance.body14RegularRoboto
            .copyWith(color: appTheme.gray_900),
        labelStyle: TextStyleHelper.instance.body14RegularRoboto
            .copyWith(color: appTheme.gray_600),
        suffixIcon: IconButton(
          icon: Icon(
            controller.obscureConfirmPassword.value
                ? Icons.visibility_off
                : Icons.visibility,
            size: 20.h,
            color: appTheme.gray_500,
          ),
          onPressed: () => controller.obscureConfirmPassword.toggle(),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: Obx(
        () => ElevatedButton(
          onPressed:
              controller.isLoading.value ? null : () => controller.saveProfile(),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.deepPurple_800,
            disabledBackgroundColor: appTheme.deepPurple_300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.h),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 22.h,
                  height: 22.h,
                  child: CircularProgressIndicator(
                    color: appTheme.white_A700,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Save Changes',
                  style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
                    color: appTheme.white_A700,
                  ),
                ),
        ),
      ),
    );
  }
}
