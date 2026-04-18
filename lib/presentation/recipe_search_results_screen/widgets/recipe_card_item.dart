import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/recipe_item_model.dart';

class RecipeCardItem extends StatelessWidget {
  final RecipeItemModel? recipeItemModel;
  final VoidCallback? onCardTap;
  final VoidCallback? onBookmarkTap;

  RecipeCardItem({
    Key? key,
    this.recipeItemModel,
    this.onCardTap,
    this.onBookmarkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: appTheme.gray_50,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: appTheme.blue_gray_100, width: 1.h),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 14.h),
            _buildRecipeImage(),
            SizedBox(height: 14.h),
            _buildRecipeInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
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
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            recipeItemModel?.recipeName?.value ?? "Recipe name",
            style: TextStyleHelper.instance.title16RegularRoboto.copyWith(
              color: appTheme.gray_900,
            ),
          ),
          GestureDetector(
            onTap: onBookmarkTap,
            child: CustomImageView(
              imagePath: ImageConstant.imgIcon24x24,
              height: 24.h,
              width: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
