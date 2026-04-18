import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomAppBar - A flexible and reusable AppBar component
 * 
 * Supports both navigation-style AppBar with leading/action icons and search-style AppBar
 * with integrated search functionality. Handles responsive sizing and customizable styling.
 * 
 * @param height - Custom height for the AppBar
 * @param leadingIcon - Path to the leading icon (typically back arrow)
 * @param onLeadingTap - Callback for leading icon tap
 * @param actionIcons - List of action icons with their respective callbacks
 * @param showSearch - Whether to display search field instead of title
 * @param searchPlaceholder - Placeholder text for search field
 * @param searchController - TextEditingController for search field
 * @param onSearchChanged - Callback for search text changes
 * @param searchValidator - Validator function for search field
 * @param backgroundColor - Background color of the AppBar
 * @param horizontalPadding - Horizontal padding for AppBar content
 */
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.height,
    this.leadingIcon,
    this.onLeadingTap,
    this.actionIcons,
    this.showSearch = false,
    this.searchPlaceholder,
    this.searchController,
    this.onSearchChanged,
    this.searchValidator,
    this.backgroundColor,
    this.horizontalPadding,
    this.searchLeftIcon,
    this.searchRightIcon,
    this.onSearchLeftTap,
    this.onSearchRightTap,
    this.searchBackgroundColor,
    this.searchBorderRadius,
  }) : super(key: key);

  /// Custom height for the AppBar
  final double? height;

  /// Path to the leading icon image
  final String? leadingIcon;

  /// Callback function when leading icon is tapped
  final VoidCallback? onLeadingTap;

  /// List of action icons with their properties
  final List<CustomAppBarAction>? actionIcons;

  /// Whether to show search field instead of regular content
  final bool showSearch;

  /// Placeholder text for search field
  final String? searchPlaceholder;

  /// Controller for search text field
  final TextEditingController? searchController;

  /// Callback when search text changes
  final Function(String)? onSearchChanged;

  /// Validator function for search field
  final String? Function(String?)? searchValidator;

  /// Background color of the AppBar
  final Color? backgroundColor;

  /// Horizontal padding for AppBar content
  final double? horizontalPadding;

  /// Left icon for search field
  final String? searchLeftIcon;

  /// Right icon for search field
  final String? searchRightIcon;

  /// Callback for search left icon tap
  final VoidCallback? onSearchLeftTap;

  /// Callback for search right icon tap
  final VoidCallback? onSearchRightTap;

  /// Background color for search field
  final Color? searchBackgroundColor;

  /// Border radius for search field
  final double? searchBorderRadius;

  @override
  Widget build(BuildContext context) {
    final appBarHeight = height ?? 70.h;
    final padding = horizontalPadding ?? 18.h;

    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor ?? appTheme.transparentCustom,
      automaticallyImplyLeading: false,
      toolbarHeight: appBarHeight,
      flexibleSpace: Container(
        height: appBarHeight,
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: showSearch ? _buildSearchContent() : _buildNavigationContent(),
      ),
    );
  }

  Widget _buildNavigationContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (leadingIcon != null)
          GestureDetector(
            onTap: onLeadingTap,
            child: CustomImageView(
              imagePath: leadingIcon!,
              height: 24.h,
              width: 24.h,
            ),
          )
        else
          SizedBox(width: 24.h),

        if (actionIcons != null && actionIcons!.isNotEmpty)
          Row(
            children: actionIcons!.map((action) {
              return Padding(
                padding: EdgeInsets.only(left: action.margin ?? 0),
                child: GestureDetector(
                  onTap: action.onTap,
                  child: CustomImageView(
                    imagePath: action.iconPath,
                    height: 24.h,
                    width: 24.h,
                  ),
                ),
              );
            }).toList(),
          )
        else
          SizedBox(width: 24.h),
      ],
    );
  }

  Widget _buildSearchContent() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: searchController,
            onChanged: onSearchChanged,
            validator: searchValidator,
            decoration: InputDecoration(
              hintText: searchPlaceholder ?? "Search...",
              hintStyle: TextStyleHelper.instance.title16RegularRoboto,
              filled: true,
              fillColor: searchBackgroundColor ?? Color(0xFFECE6F0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(searchBorderRadius ?? 28.h),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(searchBorderRadius ?? 28.h),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(searchBorderRadius ?? 28.h),
                borderSide: BorderSide.none,
              ),
              prefixIcon: searchLeftIcon != null
                  ? GestureDetector(
                      onTap: onSearchLeftTap,
                      child: Padding(
                        padding: EdgeInsets.all(12.h),
                        child: CustomImageView(
                          imagePath: searchLeftIcon!,
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),
                    )
                  : null,
              suffixIcon: searchRightIcon != null
                  ? GestureDetector(
                      onTap: onSearchRightTap,
                      child: Padding(
                        padding: EdgeInsets.all(12.h),
                        child: CustomImageView(
                          imagePath: searchRightIcon!,
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                vertical: 16.h,
                horizontal: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 70.h);
}

/// Data model for AppBar action items
class CustomAppBarAction {
  const CustomAppBarAction({required this.iconPath, this.onTap, this.margin});

  /// Path to the action icon image
  final String iconPath;

  /// Callback function when action is tapped
  final VoidCallback? onTap;

  /// Left margin for the action icon
  final double? margin;
}
