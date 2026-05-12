import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/recipe_item_model.dart';

/// A widget representing a single recipe card, typically used in lists or grids.
///
/// It displays information such as the creator's initials, name, recipe image,
/// and a bookmark (save) button if the user is logged in.
class RecipeCardItem extends StatelessWidget {
  /// The data model for the recipe to display.
  final RecipeItemModel? recipeItemModel;

  /// Callback function when the card is tapped.
  final VoidCallback? onCardTap;

  /// Callback function when the bookmark button is tapped.
  final VoidCallback? onBookmarkTap;

  /// Whether to show the bookmark (save) button.
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

  /// Builds the creator's profile section with initials and name/info.
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
            child: Padding(
              padding: EdgeInsets.only(right: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeItemModel?.userName?.value ?? "Name",
                    style: TextStyleHelper.instance.title16MediumRoboto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    recipeItemModel?.userInfo?.value ?? "info",
                    style: TextStyleHelper.instance.body14RegularRoboto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main recipe image.
  Widget _buildRecipeImage() {
    return CustomImageView(
      imagePath:
          recipeItemModel?.recipeImage?.value ?? ImageConstant.imgMedia188x364,
      height: 188.h,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
  }

  /// Builds the bottom section with recipe name and an optional bookmark button.
  ///
  /// The height is maintained even if [showBookmark] is false to ensure card consistency.
  Widget _buildRecipeInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 48.h, // Maintain consistent height regardless of bookmark button visibility
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 16.h),
              child: Text(
                recipeItemModel?.recipeName?.value ?? "Recipe name",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
                  color: appTheme.gray_900,
                ),
              ),
            ),
          ),
          if (showBookmark)
            GestureDetector(
              onTap: onBookmarkTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.only(left: 8.h, top: 12.h, bottom: 12.h),
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
            ),
        ],
      ),
    );
  }
}
