import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_checkbox.dart';
import './controller/allergy_setting_controller.dart';

/// A screen where users can select and save their allergies.
///
/// This screen displays a list of common allergies that the user can toggle
/// to update their profile settings.
class AllergySettingScreen extends GetWidget<AllergySettingController> {
  const AllergySettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.deepPurple_50,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.h, 8.h, 16.h, 0),
        child: Column(children: [Expanded(child: _buildAllergyList(context))]),
      ),
    );
  }

  /// Builds the top app bar for the screen.
  ///
  /// [context] The build context.
  /// Returns a [PreferredSizeWidget] containing the app bar.
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingIcon: ImageConstant.imgArrowLeft,
      onLeadingTap: () {
        Get.back();
      },
      backgroundColor: appTheme.transparentCustom,
    );
  }

  /// Builds the scrollable list of allergy checkboxes.
  ///
  /// [context] The build context.
  /// Returns a [Widget] representing the allergy list.
  Widget _buildAllergyList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Obx(
        () => ListView.separated(
          padding: EdgeInsets.only(bottom: 24.h),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemCount: controller.allergyItems.length,
          itemBuilder: (context, index) {
            final item = controller.allergyItems[index];
            return CustomCheckBox(
              text: item.name?.value ?? "",
              value: item.isSelected?.value ?? false,
              height: 54.h, // Matches the height of menu items (16+16+22 approx)
              onChanged: (value) {
                controller.toggleAllergy(index, value ?? false);
              },
            );
          },
        ),
      ),
    );
  }
}
