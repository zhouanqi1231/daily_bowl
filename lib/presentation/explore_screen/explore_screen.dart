import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../recipe_search_results_screen/widgets/recipe_card_item.dart';
import './controller/explore_controller.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);

  final ExploreController controller = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      // Removed AppBar containing the "Explore" title as requested
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 20.h),
        child: Obx(
          () => ListView.separated(
            itemCount: controller.exploreModelObj.value.recipeList?.length ?? 0,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              var recipe = controller.exploreModelObj.value.recipeList?[index];
              return RecipeCardItem(
                recipeItemModel: recipe,
                onCardTap: () {
                  Get.toNamed(AppRoutes.recipeDetailScreen);
                },
                onBookmarkTap: () {
                  controller.toggleBookmark(index);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
