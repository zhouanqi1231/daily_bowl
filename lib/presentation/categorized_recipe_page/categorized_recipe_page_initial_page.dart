import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_recipe_card.dart';
import './controller/categorized_recipe_controller.dart';

class CategorizedRecipePageInitialPage extends StatelessWidget {
  CategorizedRecipePageInitialPage({super.key});

  final CategorizedRecipeController controller = Get.put(
    CategorizedRecipeController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: appTheme.white_700,
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: appTheme.deepPurple_800,
            ),
          );
        }

        if (controller.categorizedRecipeModelObj.value.recipeList?.isEmpty ?? true) {
          return Center(
            child: Text(
              "No recipes found for this category",
              style: TextStyleHelper.instance.body14RegularRoboto,
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.h, 0.h, 16.h, 20.h),
          itemCount: controller.categorizedRecipeModelObj.value.recipeList!.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            var recipe = controller.categorizedRecipeModelObj.value.recipeList![index];
            return CustomRecipeCard(
              title: recipe.recipeName?.value ?? "",
              description: "By ${recipe.userName?.value ?? ''}",
              imagePath: recipe.recipeImage?.value ?? "",
              onTap: () {
                Get.toNamed(AppRoutes.recipeDetailScreen, arguments: {'id': recipe.id});
              },
            );
          },
        );
      }),
    );
  }
}
