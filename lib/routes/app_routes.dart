import 'package:get/get.dart';
import '../presentation/recipe_creation_screen/recipe_creation_screen.dart';
import '../presentation/weekly_nutrition_report_screen/weekly_nutrition_report_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/saved_recipe_list_screen/saved_recipe_list_screen.dart';
import '../presentation/settings_menu_screen/settings_menu_screen.dart';
import '../presentation/allergy_setting_screen/allergy_setting_screen.dart';
import '../presentation/recipe_detail_screen/recipe_detail_screen.dart';
import '../presentation/categorized_recipe_page/categorized_recipe_page.dart';
import '../presentation/main_container_screen/main_container_screen.dart';
import '../presentation/category_screen/category_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/register_screen/register_screen.dart';
import '../presentation/profile_settings_screen/profile_settings_screen.dart';

import '../presentation/recipe_creation_screen/binding/recipe_creation_binding.dart';
import '../presentation/weekly_nutrition_report_screen/binding/weekly_nutrition_report_binding.dart';
import '../presentation/user_profile_screen/binding/user_profile_binding.dart';
import '../presentation/saved_recipe_list_screen/binding/saved_recipe_list_binding.dart';
import '../presentation/settings_menu_screen/binding/settings_menu_binding.dart';
import '../presentation/allergy_setting_screen/binding/allergy_setting_binding.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/app_navigation_screen/binding/app_navigation_binding.dart';
import '../presentation/recipe_detail_screen/binding/recipe_detail_binding.dart';
import '../presentation/categorized_recipe_page/binding/categorized_recipe_binding.dart';
import '../presentation/login_screen/binding/login_binding.dart';
import '../presentation/register_screen/binding/register_binding.dart';
import '../presentation/profile_settings_screen/binding/profile_settings_binding.dart';

// ignore_for_file: must_be_immutable
class AppRoutes {
  static const String mainContainer = '/main_container';
  static const String categoryScreen = '/category_screen';
  static const String recipeCreationScreen = '/recipe_creation_screen';
  static const String weeklyNutritionReportScreen =
      '/weekly_nutrition_report_screen';
  static const String userProfileScreen = '/user_profile_screen';
  static const String savedRecipeListScreen = '/saved_recipe_list_screen';
  static const String savedRecipeListScreenInitialPage =
      '/saved_recipe_list_screen_initial_page';
  static const String settingsMenuScreen = '/settings_menu_screen';
  static const String allergySettingScreen = '/allergy_setting_screen';
  static const String recipeDetailScreen = '/recipe_detail_screen';
  static const String categorizedRecipePage =
      '/categorized_recipe_page';
  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';
  static const String profileSettingsScreen = '/profile_settings_screen';

  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/';

  static List<GetPage> pages = [
    GetPage(
      name: mainContainer,
      page: () => MainContainerScreen(),
      bindings: [
        LoginBinding(),
        RegisterBinding(), 
      ],
    ),
    GetPage(
      name: categoryScreen,
      page: () => CategoryScreen(),
    ),
    GetPage(
      name: recipeCreationScreen,
      page: () => const RecipeCreationScreen(),
      bindings: [RecipeCreationBinding()],
    ),
    GetPage(
      name: weeklyNutritionReportScreen,
      page: () => const WeeklyNutritionReportScreen(),
      bindings: [WeeklyNutritionReportBinding()],
    ),
    GetPage(
      name: userProfileScreen,
      page: () => UserProfileScreen(),
      bindings: [UserProfileBinding()],
    ),
    GetPage(
      name: savedRecipeListScreen,
      page: () => const SavedRecipeListScreen(),
      bindings: [SavedRecipeListBinding()],
    ),
    GetPage(
      name: settingsMenuScreen,
      page: () => const SettingsMenuScreen(),
      bindings: [SettingsMenuBinding()],
    ),
    GetPage(
      name: allergySettingScreen,
      page: () => const AllergySettingScreen(),
      bindings: [AllergySettingBinding()],
    ),
    GetPage(
      name: profileSettingsScreen,
      page: () => const ProfileSettingsScreen(),
      bindings: [ProfileSettingsBinding()],
    ),
    GetPage(
      name: recipeDetailScreen,
      page: () => const RecipeDetailScreen(),
      bindings: [RecipeDetailBinding()],
    ),
    GetPage(
      name: categorizedRecipePage,
      page: () => const CategorizedRecipePage(),
      bindings: [CategorizedRecipeBinding()],
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      bindings: [LoginBinding()],
    ),
    GetPage(
      name: registerScreen,
      page: () => const RegisterScreen(),
      bindings: [RegisterBinding()],
    ),
    GetPage(
      name: appNavigationScreen,
      page: () => const AppNavigationScreen(),
      bindings: [AppNavigationBinding()],
    ),
    GetPage(
      name: initialRoute,
      page: () => MainContainerScreen(),
      bindings: [
        LoginBinding(),
        RegisterBinding(), 
      ],
    ),
  ];
}
