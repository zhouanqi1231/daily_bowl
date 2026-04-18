import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomRecipeCard - A reusable card component for displaying recipe information
 * Features a title, description, and recipe image in a consistent Material Design layout
 * with configurable tap handling and responsive design
 * 
 * @param title - The recipe title text (required)
 * @param description - The recipe description text (required) 
 * @param imagePath - Path to the recipe image (required)
 * @param onTap - Optional callback when card is tapped
 * @param width - Optional card width, defaults to full available width
 */
class CustomRecipeCard extends StatelessWidget {
  CustomRecipeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.onTap,
    this.width,
  }) : super(key: key);

  final String title;
  final String description;
  final String imagePath;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 80.h,
        decoration: BoxDecoration(
          color: appTheme.gray_50,
          border: Border.all(color: appTheme.blue_gray_100, width: 1),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyleHelper.instance.title16MediumRoboto
                          .copyWith(color: appTheme.gray_900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      description,
                      style: TextStyleHelper.instance.body14RegularRoboto,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            CustomImageView(
              imagePath: imagePath,
              height: 80.h,
              width: 80.h,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
