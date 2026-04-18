import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_checkbox.dart';
import './controller/allergy_setting_controller.dart';

class AllergySettingScreen extends GetWidget<AllergySettingController> {
  const AllergySettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.deep_purple_50,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.h, 8.h, 16.h, 0),
        child: Column(children: [Expanded(child: _buildAllergyList(context))]),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingIcon: ImageConstant.imgArrowLeft,
      onLeadingTap: () {
        Get.back();
      },
      backgroundColor: appTheme.transparentCustom,
    );
  }

  /// Section Widget
  Widget _buildAllergyList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Obx(
        () => Column(
          spacing: 12.h,
          children: List.generate(controller.allergyItems.length, (index) {
            final item = controller.allergyItems[index];
            return CustomCheckBox(
              text: item.name?.value ?? "",
              value: item.isSelected?.value ?? false,
              onChanged: (value) {
                controller.toggleAllergy(index, value ?? false);
              },
            );
          }),
        ),
      ),
    );
  }
}
