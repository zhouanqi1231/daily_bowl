import '../core/app_export.dart';
import 'package:get/get.dart';
import '../presentation/recipe_creation_screen/recipe_creation_screen.dart';
import '../presentation/weekly_nutrition_report_screen/weekly_nutrition_report_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/saved_recipe_list_screen/saved_recipe_list_screen.dart';
import '../presentation/settings_menu_screen/settings_menu_screen.dart';
import '../presentation/allergy_setting_screen/allergy_setting_screen.dart';

import '../presentation/recipe_creation_screen/binding/recipe_creation_binding.dart';
import '../presentation/weekly_nutrition_report_screen/binding/weekly_nutrition_report_binding.dart';
import '../presentation/user_profile_screen/binding/user_profile_binding.dart';
import '../presentation/saved_recipe_list_screen/binding/saved_recipe_list_binding.dart';
import '../presentation/settings_menu_screen/binding/settings_menu_binding.dart';
import '../presentation/allergy_setting_screen/binding/allergy_setting_binding.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/app_navigation_screen/binding/app_navigation_binding.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String recipeCreationScreen = '/recipe_creation_screen';
  static const String weeklyNutritionReportScreen =
      '/weekly_nutrition_report_screen';
  static const String userProfileScreen = '/user_profile_screen';
  static const String savedRecipeListScreen = '/saved_recipe_list_screen';
  static const String savedRecipeListScreenInitialPage =
      '/saved_recipe_list_screen_initial_page';
  static const String settingsMenuScreen = '/settings_menu_screen';
  static const String allergySettingScreen = '/allergy_setting_screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/';

  static List<GetPage> pages = [
    GetPage(
      name: recipeCreationScreen,
      page: () => RecipeCreationScreen(),
      bindings: [RecipeCreationBinding()],
    ),
    GetPage(
      name: weeklyNutritionReportScreen,
      page: () => WeeklyNutritionReportScreen(),
      bindings: [WeeklyNutritionReportBinding()],
    ),
    GetPage(
      name: userProfileScreen,
      page: () => UserProfileScreen(),
      bindings: [UserProfileBinding()],
    ),
    GetPage(
      name: savedRecipeListScreen,
      page: () => SavedRecipeListScreen(),
      bindings: [SavedRecipeListBinding()],
    ),
    GetPage(
      name: settingsMenuScreen,
      page: () => SettingsMenuScreen(),
      bindings: [SettingsMenuBinding()],
    ),
    GetPage(
      name: allergySettingScreen,
      page: () => AllergySettingScreen(),
      bindings: [AllergySettingBinding()],
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
    GetPage(
      name: initialRoute,
      page: () => AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
  ];
}
