import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './controller/profile_settings_controller.dart';

class ProfileSettingsScreen extends GetWidget<ProfileSettingsController> {
  ProfileSettingsScreen({Key? key}) : super(key: key);

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
        padding: EdgeInsets.all(16.h),
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
            SizedBox(height: 40.h),
            _buildSaveButton(),
            SizedBox(height: 40.h),
          ],
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: TextStyleHelper.instance.body14RegularRoboto.copyWith(
            color: appTheme.gray_700,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.nameController,
          style: TextStyleHelper.instance.body14RegularRoboto,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: TextStyleHelper.instance.body14RegularRoboto.copyWith(
              color: appTheme.gray_400,
            ),
            filled: true,
            fillColor: appTheme.gray_50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.blue_gray_100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.blue_gray_100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.deep_purple_800),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyleHelper.instance.body14RegularRoboto.copyWith(
            color: appTheme.gray_700,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyleHelper.instance.body14RegularRoboto,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyleHelper.instance.body14RegularRoboto.copyWith(
              color: appTheme.gray_400,
            ),
            filled: true,
            fillColor: appTheme.gray_50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.blue_gray_100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.blue_gray_100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.h),
              borderSide: BorderSide(color: appTheme.deep_purple_800),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Password',
          style: TextStyleHelper.instance.body14RegularRoboto.copyWith(
            color: appTheme.gray_700,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => TextFormField(
            controller: controller.currentPasswordController,
            obscureText: controller.obscureCurrentPassword.value,
            style: TextStyleHelper.instance.body14RegularRoboto,
            decoration: InputDecoration(
              hintText: 'Enter current password',
              hintStyle: TextStyleHelper.instance.body14RegularRoboto.copyWith(
                color: appTheme.gray_400,
              ),
              filled: true,
              fillColor: appTheme.gray_50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.blue_gray_100),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.blue_gray_100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.deep_purple_800),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
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
          ),
        ),
      ],
    );
  }

  Widget _buildNewPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Password',
          style: TextStyleHelper.instance.body14RegularRoboto.copyWith(
            color: appTheme.gray_700,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => TextFormField(
            controller: controller.newPasswordController,
            obscureText: controller.obscureNewPassword.value,
            style: TextStyleHelper.instance.body14RegularRoboto,
            decoration: InputDecoration(
              hintText: 'Enter new password',
              hintStyle: TextStyleHelper.instance.body14RegularRoboto.copyWith(
                color: appTheme.gray_400,
              ),
              filled: true,
              fillColor: appTheme.gray_50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.blue_gray_100),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.blue_gray_100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.deep_purple_800),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
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
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm New Password',
          style: TextStyleHelper.instance.body14RegularRoboto.copyWith(
            color: appTheme.gray_700,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => TextFormField(
            controller: controller.confirmPasswordController,
            obscureText: controller.obscureConfirmPassword.value,
            style: TextStyleHelper.instance.body14RegularRoboto,
            decoration: InputDecoration(
              hintText: 'Re-enter new password',
              hintStyle: TextStyleHelper.instance.body14RegularRoboto.copyWith(
                color: appTheme.gray_400,
              ),
              filled: true,
              fillColor: appTheme.gray_50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.blue_gray_100),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.blue_gray_100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(color: appTheme.deep_purple_800),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
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
          ),
        ),
      ],
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
            backgroundColor: appTheme.deep_purple_800,
            disabledBackgroundColor: appTheme.deep_purple_300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.h),
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
