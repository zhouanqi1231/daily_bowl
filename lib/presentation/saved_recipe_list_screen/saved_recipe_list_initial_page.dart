import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_recipe_card.dart';
import './controller/saved_recipe_list_controller.dart';

class SavedRecipeListInitialPage extends StatelessWidget {
  SavedRecipeListInitialPage({Key? key}) : super(key: key);

  final SavedRecipeListController controller = Get.put(SavedRecipeListController());

  @override
  Widget build(BuildContext context) {
    // Get status bar height to provide initial padding
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.separated(
                  // Use status bar height in padding to prevent coverage initially,
                  // but allow content to scroll behind status bar.
                  padding: EdgeInsets.fromLTRB(16.h, statusBarHeight + 20.h, 16.h, 40.h),
                  itemCount: controller.recipeList.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final recipe = controller.recipeList[index];
                    return CustomRecipeCard(
                      title: recipe.title?.value ?? "",
                      description: recipe.description?.value ?? "",
                      imagePath: recipe.imagePath?.value ?? "",
                      onTap: () => controller.onRecipeTap(index),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
