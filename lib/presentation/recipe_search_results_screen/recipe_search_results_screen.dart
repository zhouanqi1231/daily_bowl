import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../../widgets/custom_floating_action_button.dart';
import './controller/recipe_search_results_controller.dart';
import './recipe_search_results_screen_initial_page.dart';

class RecipeSearchResultsScreen
    extends GetWidget<RecipeSearchResultsController> {
  RecipeSearchResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Navigator(
          key: Get.nestedKey(1),
          initialRoute: AppRoutes.recipeSearchResultsScreenInitialPage,
          onGenerateRoute: (routeSetting) => GetPageRoute(
            page: () => getCurrentPage(routeSetting.name!),
            transition: Transition.noTransition,
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          onPressed: () {
            // Create recipe functionality
          },
          iconPath: ImageConstant.imgCreateARecipe,
          backgroundColor: appTheme.deep_purple_50,
        ),
        bottomNavigationBar: SizedBox(
          width: double.maxFinite,
          child: _buildBottomNavigation(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    var bottomBarItemList = <CustomBottomNavigationBarItem>[
      CustomBottomNavigationBarItem(
        icon: ImageConstant.imgNavExplore,
        activeIcon: ImageConstant.imgNavExplore,
        title: 'Explore',
        routeName: AppRoutes.recipeSearchResultsScreenInitialPage,
      ),
      CustomBottomNavigationBarItem(
        icon: ImageConstant.imgNavCatagory,
        title: 'Category',
        routeName: AppRoutes.recipeSearchResultsScreenInitialPage,
      ),
      CustomBottomNavigationBarItem(
        icon: ImageConstant.imgIcon24x24,
        title: 'Saved',
        routeName: AppRoutes.recipeSearchResultsScreenInitialPage,
      ),
      CustomBottomNavigationBarItem(
        icon: ImageConstant.imgNavMe,
        title: 'Me',
        routeName: AppRoutes.recipeSearchResultsScreenInitialPage,
      ),
    ];

    return CustomBottomNavigationBar(
      bottomBarItemList: bottomBarItemList,
      selectedIndex: 0,
      onChanged: (index) {
        var bottomBarItem = bottomBarItemList[index];
        Get.toNamed(bottomBarItem.routeName, id: 1);
      },
      backgroundColor: appTheme.purple_50,
      activeColor: appTheme.deep_purple_50_02,
      inactiveColor: appTheme.gray_800,
    );
  }

  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.recipeSearchResultsScreenInitialPage:
        return RecipeSearchResultsScreenInitialPage();
      default:
        return Container();
    }
  }
}
