import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_ingredient_list.dart';
import '../../widgets/custom_recipe_card.dart';
import './controller/weekly_nutrition_report_controller.dart';
import './models/recipe_item_model.dart';

class WeeklyNutritionReportScreen
    extends GetWidget<WeeklyNutritionReportController> {
  const WeeklyNutritionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Obx(
          () {
            // Calculate opacity based on scroll offset
            double opacity = (controller.scrollOffset.value / (controller.headerHeight - 80.h)).clamp(0.0, 1.0);
            
            return CustomAppBar(
              height: 70.h,
              topPadding: 0.h,
              leadingIcon: ImageConstant.imgArrowLeft,
              onLeadingTap: () => Get.back(),
              backgroundColor: appTheme.white_A700.withValues(alpha: opacity),
              horizontalPadding: 16.h,
            );
          },
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            controller.updateScrollOffset(scrollNotification.metrics.pixels);
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderSection(context),
              _buildContentSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: "https://www.worldanimalprotection.ca/cdn-cgi/image/width=800,format=auto,fit=cover/siteassets/shutterstock_722718097.jpg",
            height: 200.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4.h, bottom: 20.h),
                  child: Obx(() => Text(
                    'Weekly Report: ${controller.weeklyNutritionReportModel.value?.weekNumber?.value ?? 'W--'}',
                    style: TextStyleHelper.instance.headline28MediumRoboto.copyWith(
                      height: 1.2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          offset: const Offset(0, 2),
                          blurRadius: 6.h,
                        ),
                      ],
                    ),
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          _buildRecipesSection(context),
          SizedBox(height: 24.h),
          _buildIngredientsSection(context),
          SizedBox(height: 24.h),
          _buildNutritionAnalysisSection(context),
          SizedBox(height: 24.h),
          _buildCongratulationsSection(context),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget _buildRecipesSection(BuildContext context) {
    return Obx(() {
      final recipes = controller.weeklyNutritionReportModel.value?.recipesList ?? [];
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipes.isEmpty 
              ? 'You haven\'t followed any recipes this week yet.' 
              : 'During this week you followed these recipes:',
            style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
              height: 1.2,
            ),
          ),
          if (recipes.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Column(
              children: List.generate(
                recipes.length,
                (index) {
                  RecipeItemModel recipe = recipes[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: CustomRecipeCard(
                      title: recipe.title?.value ?? '',
                      description: recipe.description?.value ?? '',
                      imagePath: recipe.imagePath?.value ?? '',
                      onTap: () => controller.onRecipeCardTapped(recipe),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildIngredientsSection(BuildContext context) {
    return Obx(() {
      final ingredients = controller.weeklyNutritionReportModel.value?.ingredientsList ?? [];
      if (ingredients.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'By following these recipes, you consumed these ingredients:',
            style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
              height: 1.5,
            ),
          ),
          CustomIngredientList(
            ingredientList: ingredients.map(
                (item) {
                  return IngredientItem(
                    name: item.name?.value ?? '',
                    quantity: item.quantity?.value ?? '',
                  );
                },
              ).toList(),
            margin: EdgeInsets.only(top: 12.h),
          ),
        ],
      );
    });
  }

  Widget _buildNutritionAnalysisSection(BuildContext context) {
    return Obx(() {
      final totalCalories = controller.weeklyNutritionReportModel.value?.totalCalories?.value ?? 0;
      if (totalCalories == 0) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Here's your weekly nutrition analysis:",
            style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
              height: 1.2,
            ),
          ),
          SizedBox(height: 18.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 52.h),
            padding: EdgeInsets.fromLTRB(12.h, 26.h, 12.h, 26.h),
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              borderRadius: BorderRadius.circular(16.h),
              boxShadow: [
                BoxShadow(
                  color: appTheme.color6E196E.withValues(alpha: 0.2),
                  offset: const Offset(0, 1),
                  blurRadius: 8.h,
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nutrition Consumption',
                      style: TextStyleHelper.instance.title16BoldPoppins.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCongratulationsSection(BuildContext context) {
    return Obx(() {
      final recipes = controller.weeklyNutritionReportModel.value?.recipesList ?? [];
      if (recipes.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(top: 18.h),
        child: Text(
          'Congratulations! This is a remarkably healthy week in terms of food. You have a balanced diet and nutrition consumption. Keep going!',
          style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
            height: 1.5,
          ),
        ),
      );
    });
  }
}
