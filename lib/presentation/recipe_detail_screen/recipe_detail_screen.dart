import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_floating_action_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_ingredients_list.dart';
import '../../widgets/custom_instruction_list.dart';
import './controller/recipe_detail_controller.dart';

/// A screen that displays detailed information about a specific recipe.
///
/// This screen includes the recipe image, title, author, ingredients,
/// preparation steps, nutrition facts, and allergy alerts. It also provides
/// functionality to mark the recipe as "cooked" or save it to the user's collection.
class RecipeDetailScreen extends GetWidget<RecipeDetailController> {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // top bar: back button + share button
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Obx(
          () {
            double opacity = (controller.scrollOffset.value / (controller.imageHeight - 80.h)).clamp(0.0, 1.0);
            return CustomAppBar(
              height: 70.h,
              topPadding: 0.h,
              leadingIcon: ImageConstant.imgArrowLeft,
              onLeadingTap: () => Get.back(),
              actionIcons: [
                CustomAppBarAction(
                  iconPath: ImageConstant.imgShare,
                  margin: 2.h,
                ),
              ],
              backgroundColor: appTheme.white_A700.withValues(alpha: opacity),
              horizontalPadding: 16.h,
            );
          },
        ),
      ),
      body: Obx(() {
        // check if loading
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: appTheme.deepPurple800));
        }

        return Stack(
          children: [
            // notification listener for scroll event
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
                    // top image, img_url or default
                    CustomImageView(
                      imagePath: controller.recipeImageUrl.value.isNotEmpty 
                          ? controller.recipeImageUrl.value 
                          : ImageConstant.imgMedia,
                      width: double.infinity,
                      height: controller.imageHeight,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.h, left: 16.h, right: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRecipeHeaderSection(context),
                          SizedBox(height: 24.h),
                          _buildIngredientsSection(context),
                          SizedBox(height: 24.h),
                          _buildStepsSection(context),
                          SizedBox(height: 24.h),
                          _buildNutritionSection(context),
                          SizedBox(height: 24.h),
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
        );
      }),
    );
  }

  /// Builds the header section containing the recipe title, author, and description.
  ///
  /// [context] The build context.
  Widget _buildRecipeHeaderSection(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // recipe title
          Text(
            controller.recipeTitle.value,
            style: TextStyleHelper.instance.headline32RegularRoboto,
          ),
          SizedBox(height: 12.h),
          // recipe owner
          Row(
            children: [
              CustomIconButton(
                iconPath: ImageConstant.imgGenericAvatar,
                backgroundColor: appTheme.deepPurple50,
                width: 40.h,
                height: 40.h,
                borderRadius: 20.h,
                padding: EdgeInsets.all(4.h),
              ),
              SizedBox(width: 10.h),
              Text(
                controller.authorName.value,
                style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
                  color: appTheme.black_900,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // recipe description: type, serving
          Text(
            controller.recipeDescription.value,
            style: TextStyleHelper.instance.body14RegularRoboto,
          ),
          SizedBox(height: 18.h),
          // allergy section
          _buildAllergyAlertSection(context),
        ],
      ),
    );
  }

  /// Builds the nutrition facts section displaying calories, protein, carbs, and fat.
  ///
  /// [context] The build context.
  Widget _buildNutritionSection(BuildContext context) {
    // nutrition of the recipe: calories, protein, carbs, fat
    List<CustomIngredientsItem> nutritionItems = [
      CustomIngredientsItem(name: "Calories", quantity: "${controller.totalCalories.value.toInt()} kcal"),
      CustomIngredientsItem(name: "Protein", quantity: "${controller.totalProtein.value.toInt()} g"),
      CustomIngredientsItem(name: "Carbohydrates", quantity: "${controller.totalCarbs.value.toInt()} g"),
      CustomIngredientsItem(name: "Fat", quantity: "${controller.totalFat.value.toInt()} g"),
    ];

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nutrition Facts",
            style: TextStyleHelper.instance.title16MediumRoboto,
          ),
          SizedBox(height: 14.h),
          CustomIngredientsList(
            ingredientsList: nutritionItems,
          ),
        ],
      ),
    );
  }

  /// Builds a section showing allergy alerts if the recipe contains ingredients
  /// the user is allergic to.
  ///
  /// [context] The build context.
  Widget _buildAllergyAlertSection(BuildContext context) {
    if (controller.allergyTags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.h,
      runSpacing: 8.h,
      children: [
        Text(
          "Allergy Alert:",
          style: TextStyleHelper.instance.body14RegularRoboto
        ),
        // allergy tags, from all the ingredient-allergy-tags
        ...controller.allergyTags.map((tag) {
          bool isMatched = controller.isUserAllergicTo(tag); // matched: red, unmatched: gray
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
              decoration: BoxDecoration(
                color: isMatched ? appTheme.red_900 : appTheme.gray_200,
                border: Border.all(
                  color: isMatched ? appTheme.red_900 : appTheme.gray_300,
                  width: 1.h,
                ),
                borderRadius: BorderRadius.circular(16.h),
              ),
              child: Text(
                "#$tag",
                style: TextStyleHelper.instance.label11MediumRoboto.copyWith(
                  color: isMatched ? appTheme.whiteCustom : appTheme.gray_700,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// Builds the list of ingredients for the recipe.
  ///
  /// [context] The build context.
  Widget _buildIngredientsSection(BuildContext context) {
    // ingredient list
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
          CustomIngredientsList(
            ingredientsList: controller.recipeDetailModel.value?.ingredientsList?.value ?? <CustomIngredientsItem>[],
          ),
        ],
      ),
    );
  }

  /// Builds the list of preparation steps for the recipe.
  ///
  /// [context] The build context.
  Widget _buildStepsSection(BuildContext context) {
    // recipe procedures
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
          CustomInstructionList(
            instructions: controller.recipeDetailModel.value?.instructionsList?.value ?? <String>[],
          ),
        ],
      ),
    );
  }

  /// Builds a section showing the recipe's creation or last updated date.
  ///
  /// [context] The build context.
  Widget _buildUpdatedDateSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        controller.updateDate.value,
        style: TextStyleHelper.instance.body14RegularRoboto.copyWith(
          color: appTheme.gray_600,
        ),
      ),
    );
  }

  /// Builds the floating action buttons for bookmarking (cooked) and saving the recipe.
  ///
  /// [context] The build context.
  Widget _buildFloatingActionButtons(BuildContext context) {
    return Positioned(
      bottom: 42.h,
      right: 24.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => CustomFloatingActionButton(
              heroTag: 'detail_bookmark_fab',
              onPressed: () => controller.onBookmarkTap(),
              backgroundColor:
                  controller.isBookmarked.value
                      ? appTheme.deepPurple800
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
              heroTag: 'detail_main_fab',
              onPressed: () => controller.onMainFabTap(),
              backgroundColor:
                  controller.isSaved.value
                      ? appTheme.deepPurple800
                      : appTheme.deepPurple50,
              child: Icon( 
                controller.isSaved.value ? Icons.star : Icons.star_border, // Changed to star icon
                color:
                    controller.isSaved.value
                        ? appTheme.white_A700
                        : appTheme.deepPurple800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
