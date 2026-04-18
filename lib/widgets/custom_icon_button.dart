import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * A customizable icon button widget that displays an SVG or image icon with
 * configurable styling including background color, border radius, padding, and dimensions.
 * 
 * @param iconPath - Path to the icon image (SVG, PNG, etc.)
 * @param onTap - Callback function triggered when the button is tapped
 * @param backgroundColor - Background color of the button
 * @param width - Width of the button
 * @param height - Height of the button  
 * @param borderRadius - Border radius for rounded corners
 * @param padding - Internal padding around the icon
 * @param iconColor - Color tint for the icon (optional)
 */
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.iconPath,
    this.onTap,
    this.backgroundColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.iconColor,
  }) : super(key: key);

  /// Path to the icon image (SVG, PNG, network URL, etc.)
  final String? iconPath;

  /// Callback function triggered when the button is tapped
  final VoidCallback? onTap;

  /// Background color of the button
  final Color? backgroundColor;

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  /// Border radius for rounded corners
  final double? borderRadius;

  /// Internal padding around the icon
  final EdgeInsets? padding;

  /// Color tint for the icon
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius ?? 20.h),
      child: Container(
        width: width ?? 40.h,
        height: height ?? 40.h,
        padding: padding ?? EdgeInsets.all(4.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? Color(0xFFEADDFF),
          borderRadius: BorderRadius.circular(borderRadius ?? 20.h),
        ),
        child: CustomImageView(
          imagePath: iconPath ?? ImageConstant.imgGenericAvatar,
          color: iconColor,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
