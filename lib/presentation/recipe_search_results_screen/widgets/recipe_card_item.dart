import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/recipe_item_model.dart';

class RecipeCardItem extends StatelessWidget {
  final RecipeItemModel? recipeItemModel;
  final VoidCallback? onCardTap;
  final VoidCallback? onBookmarkTap;
  final bool showBookmark;

  RecipeCardItem({
    Key? key,
    this.recipeItemModel,
    this.onCardTap,
    this.onBookmarkTap,
    this.showBookmark = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: appTheme.gray_50,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: appTheme.blue_gray_100, width: 1.h),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildProfileSection(),
            SizedBox(height: 14.h),
            _buildRecipeImage(),
            SizedBox(height: 14.h),
            _buildRecipeInfo(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        children: [
          Container(
            width: 40.h,
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: appTheme.deep_purple_50,
              borderRadius: BorderRadius.circular(20.h),
            ),
            child: Text(
              recipeItemModel?.userInitial?.value ?? "A",
              style: TextStyleHelper.instance.title16MediumRoboto.copyWith(
                color: appTheme.deep_purple_800,
              ),
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipeItemModel?.userName?.value ?? "Name",
                  style: TextStyleHelper.instance.title16MediumRoboto,
                ),
                SizedBox(height: 4.h),
                Text(
                  recipeItemModel?.userInfo?.value ?? "info",
                  style: TextStyleHelper.instance.body14RegularRoboto,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeImage() {
    return CustomImageView(
      imagePath:
          recipeItemModel?.recipeImage?.value ?? ImageConstant.imgMedia188x364,
      height: 188.h,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
  }

  Widget _buildRecipeInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            recipeItemModel?.recipeName?.value ?? "Recipe name",
            style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
              color: appTheme.gray_900,
            ),
          ),
          if (showBookmark)
            GestureDetector(
              onTap: onBookmarkTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(12.h), // Increase tap area
                child: Obx(
                  () => Icon(
                    (recipeItemModel?.isBookmarked?.value ?? false)
                        ? Icons.star
                        : Icons.star_border,
                    color: (recipeItemModel?.isBookmarked?.value ?? false)
                        ? Colors.amber
                        : Colors.grey,
                    size: 24.h,
                  ),
                ),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
