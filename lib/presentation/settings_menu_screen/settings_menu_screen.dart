import 'package:daily_bowl/presentation/login_screen/controller/login_controller.dart';
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
              child: Obx(() => Column(
                    spacing: 12.h,
                    children: controller.isLoggedIn.value
                        ? [
                            _buildProfileSettingsCard(),
                            _buildMyAllergiesCard(),
                            _buildLogoutCard(),
                          ]
                        : [
                            _buildLoginPromptCard(),
                          ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 18.h),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.deep_purple_300.withOpacity(0.3),
              offset: Offset(0, 1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
            color: textColor,
            height: 1.19,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutCard() {
    return _buildMenuButton(
      text: 'Logout',
      textColor: Colors.red,
      onTap: () {
        Get.dialog(
          AlertDialog(
            title: Text('Logout'),
            content: Text(
              'Are you sure you want to log out?',
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
              TextButton(
                onPressed: () {
                  Get.back(); // close dialog
                  controller.onLogoutTap();
                },
                child: Text('Logout'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginPromptCard() {
    return _buildMenuButton(
      text: "Please Login to access settings",
      onTap: () {
        Get.delete<LoginController>();
        Get.toNamed(AppRoutes.loginScreen);
      },
    );
  }

  Widget _buildProfileSettingsCard() {
    return _buildMenuButton(
      text: 'Profile Settings',
      onTap: () => controller.onProfileSettingsTap(),
    );
  }

  Widget _buildMyAllergiesCard() {
    return _buildMenuButton(
      text: 'My Allergies',
      onTap: () => controller.onMyAllergiesTap(),
    );
  }
}
