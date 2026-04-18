import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomAppBar - A reusable app bar component that supports leading icons, 
 * action buttons, and customizable styling.
 * 
 * @param leadingIcon - Path to the leading icon image (optional)
 * @param onLeadingPressed - Callback function when leading icon is pressed
 * @param actions - List of action widgets to display on the right side
 * @param backgroundColor - Background color of the app bar
 * @param horizontalPadding - Horizontal padding for the app bar content
 * @param elevation - Elevation of the app bar
 */
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    this.leadingIcon,
    this.onLeadingPressed,
    this.actions,
    this.backgroundColor,
    this.horizontalPadding,
    this.elevation,
  }) : super(key: key);

  /// Path to the leading icon image
  final String? leadingIcon;

  /// Callback function when leading icon is pressed
  final VoidCallback? onLeadingPressed;

  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Background color of the app bar
  final Color? backgroundColor;

  /// Horizontal padding for the app bar content
  final double? horizontalPadding;

  /// Elevation of the app bar
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? appTheme.transparentCustom,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 56.h,
      leading: leadingIcon != null ? _buildLeading() : null,
      actions: actions != null ? _buildActions() : null,
      leadingWidth: leadingIcon != null ? (60.h) : null,
    );
  }

  Widget _buildLeading() {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding ?? 18.h),
      child: GestureDetector(
        onTap: onLeadingPressed,
        child: CustomImageView(
          imagePath: leadingIcon!,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [...actions!, SizedBox(width: horizontalPadding ?? 18.h)];
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
