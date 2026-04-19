import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_recipe_card.dart';
import './controller/user_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  final UserProfileController controller = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      appBar: CustomAppBar(
        leadingIcon: ImageConstant.imgMenu,
        onLeadingTap: () => Get.toNamed(AppRoutes.settingsMenuScreen),
        actionIcons: [
          CustomAppBarAction(
            iconPath: ImageConstant.imgShare,
            onTap: () => controller.onSharePressed(),
          ),
        ],
        backgroundColor: appTheme.white_A700,
        horizontalPadding: 24.h,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfileSection(),
            _buildActivityCalendarSection(),
            _buildWeeklyReportBanner(),
            _buildMyRecipesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Container(
      width: double.infinity,
      color: appTheme.white_A700,
      padding: EdgeInsets.all(24.h),
      child: Row(
        children: [
          Container(
            width: 104.h,
            height: 104.h,
            margin: EdgeInsets.only(top: 6.h),
            decoration: BoxDecoration(
              color: appTheme.orange_200,
              shape: BoxShape.circle,
              border: Border.all(color: appTheme.gray_900_01, width: 1.h),
            ),
          ),
          SizedBox(width: 32.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.userProfileModel.value?.userName?.value ??
                        "Amy Perkins",
                    style: TextStyleHelper.instance.headline28RegularRoboto,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Obx(
                      () => Text(
                        "${controller.userProfileModel.value?.recipeCount?.value ?? 4} Recipes",
                        style: TextStyleHelper.instance.body14MediumRoboto
                            .copyWith(color: appTheme.blue_gray_400),
                      ),
                    ),
                    SizedBox(width: 24.h),
                    Obx(
                      () => Text(
                        "${controller.userProfileModel.value?.saveCount?.value ?? 128} Saves",
                        style: TextStyleHelper.instance.body14MediumRoboto
                            .copyWith(color: appTheme.blue_gray_400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCalendarSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 10.h, 16.h, 0),
      padding: EdgeInsets.fromLTRB(14.h, 8.h, 14.h, 8.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.color2C21AF,
            offset: Offset(0, 1),
            blurRadius: 4.h,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6.h),
            Row(
              children: [
                _buildMonthLabel("Jan"),
                SizedBox(width: 50.h),
                _buildMonthLabel("Feb"),
                SizedBox(width: 48.h),
                _buildMonthLabel("Mar"),
                SizedBox(width: 64.h),
                _buildMonthLabel("Apr"),
                SizedBox(width: 50.h),
                _buildMonthLabel("May"),
                SizedBox(width: 64.h),
                _buildMonthLabel("Jun"),
                SizedBox(width: 50.h),
                _buildMonthLabel("Jul"),
                SizedBox(width: 50.h),
                _buildMonthLabel("Aug"),
                SizedBox(width: 64.h),
                _buildMonthLabel("Sep"),
                SizedBox(width: 50.h),
                _buildMonthLabel("Oct"),
                SizedBox(width: 50.h),
                _buildMonthLabel("Nov"),
                SizedBox(width: 64.h),
                _buildMonthLabel("Dec"),
              ],
            ),
            SizedBox(height: 4.h),
            CustomImageView(
              imagePath: ImageConstant.imgMap,
              width: 952.h,
              height: 124.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthLabel(String month) {
    return Text(month, style: TextStyleHelper.instance.body13RegularPingFangSC);
  }

  Widget _buildWeeklyReportBanner() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.weeklyNutritionReportScreen),
      child: Container(
        width: double.infinity,
        height: 80.h,
        margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath:
                    "https://cdn.britannica.com/36/123536-050-138B212A/Variety-fruits-vegetables.jpg",
                width: double.infinity,
                height: 80.h,
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              Text(
                "Check Your Weekly Report!",
                style:
                    TextStyleHelper.instance.headline24RegularRozhaOne.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(0, 2),
                      blurRadius: 4.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyRecipesSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Text(
              "My Recipes",
              style: TextStyleHelper.instance.headline24RegularRoboto,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Column(
              children: List.generate(
                controller.userProfileModel.value?.recipes?.length ?? 0,
                (index) {
                  final recipe =
                      controller.userProfileModel.value?.recipes?[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: CustomRecipeCard(
                      title:
                          recipe?.title?.value ?? "Stir-fried Tomato and Eggs",
                      description: recipe?.description?.value ??
                          "This is a simple and classic dish ...",
                      imagePath:
                          recipe?.imagePath?.value ?? ImageConstant.imgMedia,
                      onTap: () => controller.onRecipeTap(index),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
