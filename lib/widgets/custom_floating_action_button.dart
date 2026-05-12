import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomFloatingActionButton - A reusable floating action button component
 */
class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    this.iconPath,
    this.backgroundColor,
    this.iconSize,
    this.child, // Added child support
    this.heroTag, // Added heroTag to prevent tag collisions
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String? iconPath;
  final Color? backgroundColor;
  final double? iconSize;
  final Widget? child; // New child property
  final Object? heroTag; // New heroTag property

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56.h,
      height: 56.h,
      child: FloatingActionButton(
        heroTag: heroTag, // Pass the heroTag to the internal FAB
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? Color(0xFFFFFFFF),
        elevation: 6.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
        child: child ??
            CustomImageView(
              imagePath: iconPath ?? ImageConstant.imgFab,
              height: iconSize ?? 24.h,
              width: iconSize ?? 24.h,
            ),
      ),
    );
  }
}
