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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Obx(
          () => CustomAppBar(
            height: 80.h,
            topPadding: 0.h,
            leadingIcon: ImageConstant.imgArrowLeft,
            onLeadingTap: () => Get.back(),
            actionIcons: [
              CustomAppBarAction(
                iconPath: ImageConstant.imgShare,
                onTap: () => controller.onShareTap(),
                margin: 2.h,
              ),
            ],
            backgroundColor:
                controller.scrollOffset.value > controller.imageHeight - 80.h
                    ? appTheme.white_A700
                    : Colors.transparent,
            horizontalPadding: 18.h,
          ),
        ),
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification) {
                controller.updateScrollOffset(scrollNotification.metrics.pixels);
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgMedia,
                    width: double.infinity,
                    height: controller.imageHeight,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.h, left: 16.h, right: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildRecipeHeaderSection(context),
                        SizedBox(height: 16.h),
                        _buildIngredientsSection(context),
                        SizedBox(height: 16.h),
                        _buildStepsSection(context),
                        SizedBox(height: 16.h),
                        _buildUpdatedDateSection(context),
                        SizedBox(height: 180.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildFloatingActionButtons(context),
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
        Container(
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
        SizedBox(width: 8.h),
        Container(
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
      ],
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ingredients",
            style: TextStyleHelper.instance.title16MediumRoboto,
          ),
          SizedBox(height: 14.h),
          Obx(
            () => CustomIngredientsList(
              ingredientsList:
                  controller.recipeDetailModel.value?.ingredientsList?.value ??
                  [],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Steps",
            style: TextStyleHelper.instance.title16MediumRoboto,
          ),
          SizedBox(height: 16.h),
          Obx(
            () => CustomInstructionList(
              instructions:
                  controller
                      .recipeDetailModel
                      .value
                      ?.instructionsList
                      ?.value ??
                      [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatedDateSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        "Updated on 2026-02-11",
        style: TextStyleHelper.instance.body12RegularRoboto.copyWith(
          color: appTheme.gray_600, // Changed color to gray
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Positioned(
      bottom: 42.h,
      right: 24.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => CustomFloatingActionButton(
              onPressed: () => controller.onBookmarkTap(),
              backgroundColor:
                  controller.isBookmarked.value
                      ? appTheme.deep_purple_800
                      : appTheme.white_A700,
              child: CustomImageView(
                imagePath: ImageConstant.imgFab,
                color: controller.isBookmarked.value
                    ? appTheme.white_A700
                    : null,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => CustomFloatingActionButton(
              onPressed: () => controller.onMainFabTap(),
              child: Icon( 
                controller.isSaved.value ? Icons.star : Icons.star_border, // Changed to star icon
                color:
                    controller.isSaved.value
                        ? appTheme.white_A700
                        : appTheme.deep_purple_800,
              ),
              backgroundColor:
                  controller.isSaved.value
                      ? appTheme.deep_purple_800
                      : appTheme.deep_purple_50,
            ),
          ),
        ],
      ),
    );
  }
}
