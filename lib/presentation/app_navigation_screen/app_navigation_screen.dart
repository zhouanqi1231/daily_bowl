import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './controller/app_navigation_controller.dart';

// ignore_for_file: must_be_immutable

/// A screen that provides easy access to all other screens in the application.
///
/// This is primarily used during development to quickly jump to different parts of the app.
class AppNavigationScreen extends GetWidget<AppNavigationController> {
  const AppNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFFFFFFFF),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    children: [
                      _buildScreenTitle(
                        context,
                        screenTitle: "Create a Recipe",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.recipeCreationScreen,
                        ),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Weekly Report",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.weeklyNutritionReportScreen,
                        ),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "My Profile",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.userProfileScreen,
                        ),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Saved Recipe",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.savedRecipeListScreen,
                        ),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Menu",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.settingsMenuScreen,
                        ),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Allergy Setting",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.allergySettingScreen,
                        ),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Explore",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.categorizedRecipePage,
                        ),
                      ),
                      _buildScreenTitle(
                        context,
                        screenTitle: "Recipe Detail",
                        onTapScreenTitle: () => onTapScreenTitle(
                          context,
                          AppRoutes.recipeDetailScreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a clickable row for a screen title.
  ///
  /// [context] The build context.
  /// [screenTitle] The title to display for the screen.
  /// [onTapScreenTitle] Callback function when the row is tapped.
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {
        onTapScreenTitle?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: const BoxDecoration(color: Color(0XFFFFFFFF)),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.title20RegularRoboto.copyWith(
                    color: const Color(0XFF000000),
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Color(0XFF343330)),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(height: 1.h, thickness: 1.h, color: const Color(0XFFD2D2D2)),
          ],
        ),
      ),
    );
  }

  /// Navigates to the specified [routeName].
  ///
  /// [context] The build context.
  /// [routeName] The name of the route to navigate to.
  void onTapScreenTitle(BuildContext context, String routeName) {
    Get.toNamed(routeName);
  }

  /// Shows a modal bottom sheet with the provided [className] widget.
  ///
  /// [context] The build context.
  /// [className] The widget to display in the bottom sheet.
  void onTapBottomSheetTitle(BuildContext context, Widget className) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return className;
      },
      isScrollControlled: true,
      backgroundColor: appTheme.transparentCustom,
    );
  }

  /// Shows an alert dialog with the provided [className] widget.
  ///
  /// [context] The build context.
  /// [className] The widget to display in the dialog.
  void onTapDialogTitle(BuildContext context, Widget className) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: className,
          backgroundColor: appTheme.transparentCustom,
          insetPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
