import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_recipe_card.dart';
import './controller/saved_recipe_list_controller.dart';

class SavedRecipeListInitialPage extends StatelessWidget {
  SavedRecipeListInitialPage({Key? key}) : super(key: key);

  final SavedRecipeListController controller = Get.put(SavedRecipeListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(16.h, 22.h, 16.h, 0),
                child: Column(
                  children: [
                    Expanded(
                      child: Obx(
                        () => ListView.separated(
                          // Added bottom padding to the list
                          padding: EdgeInsets.only(bottom: 40.h),
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
            ),
          ],
        ),
      ),
    );
  }
}
