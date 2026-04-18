import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../allergy_setting_screen/allergy_setting_screen.dart';
import '../recipe_creation_screen/recipe_creation_screen.dart';
import '../settings_menu_screen/settings_menu_screen.dart';
import '../user_profile_screen/user_profile_screen.dart';
import '../weekly_nutrition_report_screen/weekly_nutrition_report_screen.dart';
import './controller/saved_recipe_list_controller.dart';
import './saved_recipe_list_initial_page.dart';

// Modified: Added missing import
// Modified: Added missing import
// Modified: Added missing import
// Modified: Added missing import

class SavedRecipeListScreen extends GetWidget<SavedRecipeListController> {
  SavedRecipeListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Navigator(
          key: Get.nestedKey(1),
          initialRoute: AppRoutes.savedRecipeListScreenInitialPage,
          onGenerateRoute: (routeSetting) => GetPageRoute(
            page: () => getCurrentPage(routeSetting.name!),
            transition: Transition.noTransition,
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.maxFinite,
          child: _buildBottomNavigation(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return CustomBottomBar(
      selectedIndex: 2,
      onChanged: (index) {
        String routeName = _getRouteByIndex(index);
        Get.toNamed(routeName, id: 1);
      },
      bottomBarItemList: [
        CustomBottomBarItem(
          icon: ImageConstant.imgNavExplore,
          title: 'Explore',
          routeName: AppRoutes.savedRecipeListScreenInitialPage,
        ),
        CustomBottomBarItem(
          icon: ImageConstant.imgNavCatagory,
          title: 'Category',
          routeName: AppRoutes.savedRecipeListScreenInitialPage,
        ),
        CustomBottomBarItem(
          icon: ImageConstant.imgNavSavedGray800,
          activeIcon: ImageConstant.imgNavSaved,
          title: 'Saved',
          routeName: AppRoutes.savedRecipeListScreenInitialPage,
        ),
        CustomBottomBarItem(
          icon: ImageConstant.imgNavMe,
          activeIcon: ImageConstant.imgNavMeBlack900,
          title: 'Me',
          routeName: AppRoutes.userProfileScreen,
        ),
      ],
    );
  }

  String _getRouteByIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.savedRecipeListScreenInitialPage;
      case 1:
        return AppRoutes.savedRecipeListScreenInitialPage;
      case 2:
        return AppRoutes.savedRecipeListScreenInitialPage;
      case 3:
        return AppRoutes.userProfileScreen;
      default:
        return AppRoutes.savedRecipeListScreenInitialPage;
    }
  }

  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.savedRecipeListScreenInitialPage:
        return SavedRecipeListInitialPage();
      case AppRoutes.userProfileScreen:
        return UserProfileScreen();
      case AppRoutes.recipeCreationScreen:
        return RecipeCreationScreen(); // Modified: Fixed undefined method by adding import
      case AppRoutes.weeklyNutritionReportScreen:
        return WeeklyNutritionReportScreen(); // Modified: Fixed undefined method by adding import
      case AppRoutes.settingsMenuScreen:
        return SettingsMenuScreen(); // Modified: Fixed undefined method by adding import
      case AppRoutes.allergySettingScreen:
        return AllergySettingScreen(); // Modified: Fixed undefined method by adding import
      default:
        return SavedRecipeListInitialPage();
    }
  }
}
