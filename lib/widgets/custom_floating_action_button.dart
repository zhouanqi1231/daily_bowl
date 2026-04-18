import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomFloatingActionButton - A reusable floating action button component
 * 
 * A customizable floating action button that supports different icons and background colors.
 * Built on Flutter's FloatingActionButton with consistent sizing and Material Design principles.
 * 
 * @param onPressed - Callback function when button is pressed (required)
 * @param iconPath - Path to the icon image (SVG, PNG, etc.)
 * @param backgroundColor - Background color of the button
 * @param iconSize - Size of the icon inside the button
 */
class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    this.iconPath,
    this.backgroundColor,
    this.iconSize,
  }) : super(key: key);

  /// Callback function triggered when the button is pressed
  final VoidCallback? onPressed;

  /// Path to the icon image (SVG, PNG, network, etc.)
  final String? iconPath;

  /// Background color of the floating action button
  final Color? backgroundColor;

  /// Size of the icon inside the button
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56.h,
      height: 56.h,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? Color(0xFFFFFFFF),
        elevation: 6.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
        child: CustomImageView(
          imagePath: iconPath ?? ImageConstant.imgFab,
          height: iconSize ?? 24.h,
          width: iconSize ?? 24.h,
        ),
      ),
    );
  }
}
