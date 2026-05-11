import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_recipe_card.dart';
import './controller/recipe_search_results_controller.dart';

class RecipeSearchResultsScreenInitialPage extends StatelessWidget {
  RecipeSearchResultsScreenInitialPage({Key? key}) : super(key: key);

  final RecipeSearchResultsController controller = Get.put(
    RecipeSearchResultsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: appTheme.white_A700,
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: appTheme.deep_purple_800,
            ),
          );
        }

        if (controller.recipeSearchResultsModelObj.value.recipeList?.isEmpty ?? true) {
          return Center(
            child: Text(
              "No recipes found for this category",
              style: TextStyleHelper.instance.body14RegularRoboto,
            ),
          );
        }

        double statusBarHeight = MediaQuery.of(context).padding.top;

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.h, 0.h, 16.h, 20.h),
          itemCount: controller.recipeSearchResultsModelObj.value.recipeList!.length,
          separatorBuilder: (context, index) =>
              SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            var recipe = controller.recipeSearchResultsModelObj.value.recipeList![index];
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
