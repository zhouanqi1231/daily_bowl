import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './controller/recipe_search_results_controller.dart';
import './widgets/recipe_card_item.dart';

// Modified: Fixed import path

class RecipeSearchResultsScreenInitialPage extends StatelessWidget {
  RecipeSearchResultsScreenInitialPage({Key? key}) : super(key: key);

  RecipeSearchResultsController controller = Get.put(
    RecipeSearchResultsController(),
  ); // Modified: Fixed controller initialization

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 20.h),
        child: Obx(
          () => ListView.separated(
            itemCount:
                controller
                    .recipeSearchResultsModelObj
                    .value
                    .recipeList
                    ?.length ??
                0,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              var recipe = controller
                  .recipeSearchResultsModelObj
                  .value
                  .recipeList?[index];
              return RecipeCardItem(
                recipeItemModel: recipe,
                onCardTap: () {
                  Get.toNamed(AppRoutes.recipeDetailScreen);
                },
                onBookmarkTap: () {
                  controller.toggleBookmark(index);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 70.h,
      showSearch: true,
      searchPlaceholder: 'Hinted search text',
      searchController: controller.searchController.value,
      onSearchChanged: (value) {
        controller.onSearchTextChanged(value);
      },
      searchValidator: (value) {
        return controller.validateSearchText(value);
      },
      searchLeftIcon: ImageConstant.imgIconGray800,
      searchRightIcon: ImageConstant.imgIconGray80024x24,
      onSearchLeftTap: () {
        // Handle left icon tap
      },
      onSearchRightTap: () {
        controller.performSearch();
      },
      searchBackgroundColor: appTheme.deep_purple_50_01,
      searchBorderRadius: 28.h,
      horizontalPadding: 24.h,
    );
  }
}
