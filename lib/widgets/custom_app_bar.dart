import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomAppBar - A flexible and reusable AppBar component
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
    this.topPadding,
    this.searchLeftIcon,
    this.searchRightIcon,
    this.onSearchLeftTap,
    this.onSearchRightTap,
    this.searchBackgroundColor,
    this.searchBorderRadius,
  }) : super(key: key);

  final double? height;
  final String? leadingIcon;
  final VoidCallback? onLeadingTap;
  final List<CustomAppBarAction>? actionIcons;
  final bool showSearch;
  final String? searchPlaceholder;
  final TextEditingController? searchController;
  final Function(String)? onSearchChanged;
  final String? Function(String?)? searchValidator;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? topPadding;
  final String? searchLeftIcon;
  final String? searchRightIcon;
  final VoidCallback? onSearchLeftTap;
  final VoidCallback? onSearchRightTap;
  final Color? searchBackgroundColor;
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
      flexibleSpace: SafeArea(
        bottom: false,
        child: Container(
          height: appBarHeight,
          padding: EdgeInsets.only(
            left: padding,
            right: padding,
            top: topPadding ?? 0,
          ),
          child: showSearch ? _buildSearchContent() : _buildNavigationContent(),
        ),
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
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(8.h),
              child: CustomImageView(
                imagePath: leadingIcon!,
                height: 24.h,
                width: 24.h,
              ),
            ),
          )
        else
          SizedBox(width: 40.h),
        if (actionIcons != null && actionIcons!.isNotEmpty)
          Row(
            children: actionIcons!.map((action) {
              return GestureDetector(
                onTap: action.onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: action.margin ?? 8.h,
                    top: 8.h,
                    bottom: 8.h,
                    right: 8.h,
                  ),
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
          SizedBox(width: 40.h),
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

class CustomAppBarAction {
  const CustomAppBarAction({required this.iconPath, this.onTap, this.margin});
  final String iconPath;
  final VoidCallback? onTap;
  final double? margin;
}
