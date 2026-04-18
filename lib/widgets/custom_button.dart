import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/// Custom button widget that supports various styles and configurations
///
/// This button component provides:
/// - Customizable background and text colors
/// - Optional left icon support
/// - Responsive design with SizeUtils
/// - Consistent styling with configurable properties
class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.text,
    required this.width,
    this.backgroundColor,
    this.textColor,
    this.leftIcon,
    this.onPressed,
  }) : super(key: key);

  /// The text to display on the button
  final String text;

  /// Required width for the button to ensure proper layout
  final double width;

  /// Background color of the button
  final Color? backgroundColor;

  /// Text color for the button label
  final Color? textColor;

  /// Optional path to the left icon (SVG supported)
  final String? leftIcon;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Color(0xFFE8DEF8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.h),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.h),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leftIcon != null) ...[
              CustomImageView(imagePath: leftIcon!, height: 20.h, width: 20.h),
              SizedBox(width: 8.h),
            ],
            Text(
              text,
              style: TextStyleHelper.instance.body14MediumRoboto.copyWith(
                color: textColor ?? Color(0xFF4A4459),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
