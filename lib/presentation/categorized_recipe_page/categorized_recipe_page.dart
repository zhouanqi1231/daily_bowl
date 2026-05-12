import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './controller/categorized_recipe_controller.dart';
import './categorized_recipe_page_initial_page.dart';

/// A screen that displays recipes filtered by a specific category (cuisine type).
///
/// This screen uses a [CategorizedRecipeController] to manage the state and
/// displays the list of recipes using [CategorizedRecipePageInitialPage].
class CategorizedRecipePage
    extends GetWidget<CategorizedRecipeController> {
  CategorizedRecipePage({Key? key}) : super(key: key);

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
        body: CategorizedRecipePageInitialPage(),
      ),
    );
  }
}
