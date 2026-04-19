import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_floating_action_button.dart';
import '../../widgets/custom_image_view.dart';
import '../recipe_search_results_screen/widgets/recipe_card_item.dart';
import './controller/explore_controller.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);

  final ExploreController controller = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    // Get status bar height
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: Stack(
        children: [
          Obx(
            () => ListView.separated(
              // Added horizontal padding (16.h) between cards and screen edge
              // Increased bottom padding to 100.h to provide more empty space at the bottom
              padding: EdgeInsets.fromLTRB(16.h, statusBarHeight + 20.h, 16.h, 100.h),
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
          _buildFloatingActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Positioned(
      bottom: 24.h,
      right: 16.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomFloatingActionButton(
            onPressed: () {
              Get.toNamed(AppRoutes.recipeCreationScreen);
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgCreateARecipe,
              color: appTheme.white_A700,
            ),
            backgroundColor: appTheme.deep_purple_800,
          ),
        ],
      ),
    );
  }
}
