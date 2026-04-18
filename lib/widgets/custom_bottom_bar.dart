import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomBottomBar - A customizable bottom navigation bar component
 * 
 * Features:
 * - Support for multiple navigation items with icons and labels
 * - Active/inactive state management with visual indicators
 * - Customizable item data through CustomBottomBarItem model
 * - Responsive design with SizeUtils integration
 * - Tap handling with callback function
 * 
 * @param bottomBarItemList - List of navigation items
 * @param selectedIndex - Currently selected tab index
 * @param onChanged - Callback function when tab is tapped
 */
class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({
    Key? key,
    required this.bottomBarItemList,
    required this.onChanged,
    this.selectedIndex = 0,
  }) : super(key: key);

  /// List of bottom bar items with their properties
  final List<CustomBottomBarItem> bottomBarItemList;

  /// Current selected index of the bottom bar
  final int selectedIndex;

  /// Callback function triggered when a bottom bar item is tapped
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 6.h),
      decoration: BoxDecoration(color: appTheme.purple_50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(bottomBarItemList.length, (index) {
          final isSelected = selectedIndex == index;
          final item = bottomBarItemList[index];

          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              child: _buildBottomBarItem(item, isSelected),
            ),
          );
        }),
      ),
    );
  }

  /// Builds individual bottom bar item widget
  Widget _buildBottomBarItem(CustomBottomBarItem item, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 32.h,
          width: 56.h,
          decoration: isSelected
              ? BoxDecoration(
                  color: appTheme.deep_purple_50,
                  borderRadius: BorderRadius.circular(16.h),
                )
              : null,
          child: Center(
            child: CustomImageView(
              imagePath: isSelected ? item.activeIcon ?? item.icon : item.icon,
              height: 24.h,
              width: 24.h,
            ),
          ),
        ),
        SizedBox(height: isSelected ? 4.h : 8.h),
        Text(
          item.title ?? '',
          style: TextStyleHelper.instance.body12MediumRoboto.copyWith(
            color: isSelected ? Color(0xFF625B71) : appTheme.gray_800,
          ),
        ),
      ],
    );
  }
}

/// Item data model for custom bottom bar
class CustomBottomBarItem {
  CustomBottomBarItem({this.icon, this.activeIcon, this.title, this.routeName});

  /// Path to the default/inactive state icon
  final String? icon;

  /// Path to the active state icon (optional, falls back to icon if null)
  final String? activeIcon;

  /// Title text shown below the icon
  final String? title;

  /// Route name for navigation
  final String? routeName;
}
