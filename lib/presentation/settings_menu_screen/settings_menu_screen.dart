import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './controller/settings_menu_controller.dart';

class SettingsMenuScreen extends GetWidget<SettingsMenuController> {
  SettingsMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.deep_purple_50,
      appBar: CustomAppBar(
        leadingIcon: ImageConstant.imgArrowLeft,
        onLeadingTap: () => Get.back(),
        backgroundColor: appTheme.transparentCustom,
        horizontalPadding: 18.h,
      ),
      body: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 16.h, right: 16.h),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: Column(
                spacing: 12.h,
                children: [
                  _buildProfileSettingsCard(),
                  _buildMyAllergiesCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSettingsCard() {
    return GestureDetector(
      onTap: () => controller.onProfileSettingsTap(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 16.h, bottom: 16.h, left: 18.h),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.deep_purple_300,
              offset: Offset(0, 1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Settings',
              style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
                height: 1.19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyAllergiesCard() {
    return GestureDetector(
      onTap: () => controller.onMyAllergiesTap(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 16.h, bottom: 16.h, left: 18.h),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.deep_purple_300,
              offset: Offset(0, 1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Allergies',
              style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
                height: 1.19,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
