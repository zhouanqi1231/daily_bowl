import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './controller/category_controller.dart';
import './models/category_model.dart';

/// A screen that displays various recipe categories (cuisine types) in a grid.
///
/// Each category item displays the cuisine name, the number of recipes available,
/// and a representative image.
class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: appTheme.white_700,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: appTheme.deepPurple_800,
            ),
          );
        }

        if (controller.categoryList.isEmpty) {
          return Center(
            child: Text(
              "No categories found",
              style: TextStyleHelper.instance.body14RegularRoboto,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchCategories(),
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(16.h, statusBarHeight + 20.h, 16.h, 40.h),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.h,
              childAspectRatio: 1.2,  // Rectangular shape
            ),
            itemCount: controller.categoryList.length,
            itemBuilder: (context, index) {
              CategoryModel category = controller.categoryList[index];
              return _buildCategoryItem(category);
            },
          ),
        );
      }),
    );
  }

  /// Builds a single category item in the grid.
  ///
  /// [category] The category model data to display.
  /// Returns a [Widget] representing the category item.
  Widget _buildCategoryItem(CategoryModel category) {
    return GestureDetector(
      onTap: () => controller.onCategoryTap(category),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.deepPurple_50,
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: appTheme.gray_300.withValues(alpha: 0.3),
              blurRadius: 4.h,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.h),
          child: Obx(() {
            bool hasImage = category.imagePath.value.isNotEmpty;
            return Stack(
              children: [
                // Background (Recipe image or default icon)
                if (hasImage)
                  Positioned.fill(
                    child: CustomImageView(
                      imagePath: category.imagePath.value,
                      fit: BoxFit.cover,
                    ),
                  ),
                
                if (hasImage)
                  // Gradient Overlay for text readability on image
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  // Default Icon when no image is available
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 80.h,
                        color: appTheme.deepPurple_800,
                      ),
                    ),
                  ),

                // Content
                Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.cuisineType.value,
                        style: TextStyleHelper.instance.title16BoldPoppins.copyWith(
                          color: hasImage ? Colors.white : appTheme.deepPurple_800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${category.recipeCount.value} Recipes",
                        style: TextStyleHelper.instance.body12RegularRoboto.copyWith(
                          color: hasImage ? Colors.white.withValues(alpha: 0.8) : appTheme.gray_600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
