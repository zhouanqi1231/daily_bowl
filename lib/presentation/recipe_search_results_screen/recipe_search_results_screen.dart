import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './controller/recipe_search_results_controller.dart';
import './recipe_search_results_screen_initial_page.dart';

class RecipeSearchResultsScreen
    extends GetWidget<RecipeSearchResultsController> {
  RecipeSearchResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: appTheme.white_A700,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Obx(() => CustomAppBar(
            height: 70.h,
            leadingIcon: ImageConstant.imgArrowLeft,
            onLeadingTap: () => Get.back(),
            title: controller.cuisineType.value ?? "Recipes",
            backgroundColor: appTheme.white_A700,
            horizontalPadding: 16.h,
          )),
        ),
        body: RecipeSearchResultsScreenInitialPage(),
      ),
    );
  }
}
