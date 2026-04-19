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
  WeeklyNutritionReportScreen({Key? key}) : super(key: key);

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
              backgroundColor: appTheme.white_A700.withOpacity(opacity),
              horizontalPadding: 18.h,
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
    return Container(
      width: double.infinity,
      height: 200.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgCoverImage,
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
                  child: Text(
                    'Weekly Report: W16',
                    style: TextStyleHelper.instance.headline28MediumRoboto.copyWith(
                      height: 1.2,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          offset: Offset(0, 2),
                          blurRadius: 6.h,
                        ),
                      ],
                    ),
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'During This week you followed these recipes:',
          style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
            height: 1.2,
          ),
        ),
        SizedBox(height: 20.h),
        Column(
          children: List.generate(
            controller.weeklyNutritionReportModel.value?.recipesList?.length ??
                0,
            (index) {
              RecipeItemModel recipe = controller
                  .weeklyNutritionReportModel
                  .value!
                  .recipesList![index];
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
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
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
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
          ingredientList:
              controller.weeklyNutritionReportModel.value?.ingredientsList?.map(
                (item) {
                  return IngredientItem(
                    name: item.name?.value ?? '',
                    quantity: item.quantity?.value ?? '',
                  );
                },
              ).toList() ??
              [],
          margin: EdgeInsets.only(top: 12.h),
        ),
      ],
    );
  }

  Widget _buildNutritionAnalysisSection(BuildContext context) {
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
                color: appTheme.color6E196E,
                offset: Offset(0, 1),
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
              SizedBox(height: 28.h),
              _buildNutritionChart(context),
              SizedBox(height: 28.h),
              _buildNutritionLegend(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionChart(BuildContext context) {
    return Container(
      height: 214.h,
      width: 214.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70.h,
              sections: [
                PieChartSectionData(
                  value: 35,
                  color: appTheme.indigo_400,
                  radius: 25.h,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 32,
                  color: appTheme.deep_orange_400,
                  radius: 25.h,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 33,
                  color: appTheme.cyan_400,
                  radius: 25.h,
                  showTitle: false,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '3564',
                style: TextStyleHelper.instance.headline32BoldPoppins,
              ),
              Text(
                'CALORIES',
                style: TextStyleHelper.instance.body12MediumPoppins,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(4.h, 2.h, 4.h, 2.h),
          decoration: BoxDecoration(
            color: appTheme.deep_orange_400,
            borderRadius: BorderRadius.circular(4.h),
          ),
          child: Text(
            'PROTEIN',
            style: TextStyleHelper.instance.label10BoldRoboto.copyWith(
              height: 1.2,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 2.h),
          decoration: BoxDecoration(
            color: appTheme.indigo_400,
            borderRadius: BorderRadius.circular(4.h),
          ),
          child: Text(
            'CARBS',
            style: TextStyleHelper.instance.label10BoldRoboto.copyWith(
              height: 1.2,
            ),
          ),
        ),
        SizedBox(width: 10.h),
        Container(
          padding: EdgeInsets.fromLTRB(2.h, 2.h, 2.h, 2.h),
          decoration: BoxDecoration(
            color: appTheme.cyan_400,
            borderRadius: BorderRadius.circular(4.h),
          ),
          child: Text(
            'FAT',
            style: TextStyleHelper.instance.label10BoldRoboto.copyWith(
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCongratulationsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: Text(
        'Congratulations! This is a remarkably healthy week in terms of food. You have a balanced diet and nutrition consumption. Keep going!',
        style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
          height: 1.5,
        ),
      ),
    );
  }
}
