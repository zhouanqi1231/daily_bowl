import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_floating_action_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_ingredients_list.dart';
import '../../widgets/custom_instruction_list.dart';
import './controller/recipe_detail_controller.dart';

class RecipeDetailScreen extends GetWidget<RecipeDetailController> {
  RecipeDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildRecipeImageSection(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 12.h, left: 16.h, right: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: 16.h,
                    children: [
                      _buildRecipeHeaderSection(context),
                      _buildIngredientsSection(context),
                      _buildStepsSection(context),
                      _buildUpdatedDateSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingActionButton(context),
        ],
      ),
    );
  }

  Widget _buildRecipeImageSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 412.h,
      child: Stack(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgMedia,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          CustomAppBar(
            leadingIcon: ImageConstant.imgArrowLeft,
            onLeadingTap: () => Get.back(),
            actionIcons: [
              CustomAppBarAction(
                iconPath: ImageConstant.imgIcon,
                onTap: () => controller.onShareTap(),
                margin: 2.h,
              ),
            ],
            backgroundColor: appTheme.transparentCustom,
            horizontalPadding: 18.h,
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeHeaderSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Stir-fried Tomato and Eggs",
            style: TextStyleHelper.instance.headline32RegularRoboto,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              CustomIconButton(
                iconPath: ImageConstant.imgGenericAvatar,
                backgroundColor: appTheme.deep_purple_50,
                width: 40.h,
                height: 40.h,
                borderRadius: 20.h,
                padding: EdgeInsets.all(4.h),
                onTap: () => controller.onUserProfileTap(),
              ),
              SizedBox(width: 10.h),
              Text(
                "User Name",
                style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
                  color: appTheme.black_900,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "This is a simple and classic dish that is easy to make and perfect for a quick meal.",
            style: TextStyleHelper.instance.body14RegularRoboto,
          ),
          SizedBox(height: 18.h),
          _buildAllergyAlertSection(context),
        ],
      ),
    );
  }

  Widget _buildAllergyAlertSection(BuildContext context) {
    return Row(
      children: [
        Text(
          "Allergy Alert:",
          style: TextStyleHelper.instance.body14RegularRoboto,
        ),
        SizedBox(width: 8.h),
        GestureDetector(
          onTap: () => controller.onAllergyTagTap("Egg"),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
            decoration: BoxDecoration(
              color: appTheme.deep_orange_200,
              border: Border.all(color: appTheme.red_900, width: 1.h),
              borderRadius: BorderRadius.circular(14.h),
            ),
            child: Text(
              "#Egg",
              style: TextStyleHelper.instance.label11MediumRoboto,
            ),
          ),
        ),
        SizedBox(width: 8.h),
        GestureDetector(
          onTap: () => controller.onAllergyTagTap("Tamato"),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
            decoration: BoxDecoration(
              border: Border.all(color: appTheme.blue_gray_100, width: 1.h),
              borderRadius: BorderRadius.circular(14.h),
            ),
            child: Text(
              "#Tamato",
              style: TextStyleHelper.instance.label11MediumRoboto.copyWith(
                color: appTheme.gray_800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14.h,
        children: [
          Text(
            "Ingredients",
            style: TextStyleHelper.instance.title16MediumRoboto,
          ),
          Obx(
            () => CustomIngredientsList(
              ingredientsList:
                  controller.recipeDetailModel.value?.ingredientsList?.value ??
                  [], // Modified: Added null safety and proper value access for Rx<List<CustomIngredientsItem>>
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 6.h),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.h,
            children: [
              Text(
                "Steps",
                style: TextStyleHelper.instance.title16MediumRoboto,
              ),
              Obx(
                () => CustomInstructionList(
                  instructions:
                      controller
                          .recipeDetailModel
                          .value
                          ?.instructionsList
                          ?.value ??
                      [], // Modified: Added null safety and proper value access for Rx<List<String>>
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20.h,
            right: 0,
            child: CustomFloatingActionButton(
              onPressed: () => controller.onBookmarkTap(),
              iconPath: ImageConstant.imgFab,
              backgroundColor: appTheme.white_A700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatedDateSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 46.h),
      child: Text(
        "Updated on 2026-02-11",
        style: TextStyleHelper.instance.body12RegularRoboto,
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Positioned(
      bottom: 42.h,
      right: 24.h,
      child: CustomFloatingActionButton(
        onPressed: () => controller.onMainFabTap(),
        iconPath: ImageConstant.imgFabDeepPurple800,
        backgroundColor: appTheme.deep_purple_50,
      ),
    );
  }
}
