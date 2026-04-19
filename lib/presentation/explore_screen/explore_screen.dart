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
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: Stack(
        children: [
          // add NotificationListener for scroll event
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // is bottom?
              if (!controller.isLoading.value &&
                  scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
                // load before reach bottom
                controller.fetchRecipes();
                return true;
              }
              return false;
            },
            child: Obx(() {
              int recipeCount = controller.exploreModelObj.value.recipeList?.length ?? 0;
              
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16.h, statusBarHeight + 20.h, 16.h, 100.h),
                // if have more data, add a loading icon
                itemCount: recipeCount + (controller.hasMoreData.value ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  if (index == recipeCount) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  var recipe = controller.exploreModelObj.value.recipeList?[index];
                  return RecipeCardItem(
                    recipeItemModel: recipe,
                    onCardTap: () {
                      Get.toNamed(AppRoutes.recipeDetailScreen, arguments: {'id': recipe?.id});
                    },
                    onBookmarkTap: () {
                      controller.toggleBookmark(index);
                    },
                  );
                },
              );
            }),
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
            backgroundColor: appTheme.deep_purple_800,
            child: CustomImageView(
              imagePath: ImageConstant.imgCreateARecipe,
              color: appTheme.white_A700,
            ),
          ),
        ],
      ),
    );
  }
}
