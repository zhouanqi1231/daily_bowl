import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomBottomBar - A customizable bottom navigation bar component
 */
class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({
    Key? key,
    required this.bottomBarItemList,
    required this.onChanged,
    this.selectedIndex = 0,
  }) : super(key: key);

  final List<CustomBottomBarItem> bottomBarItemList;
  final int selectedIndex;
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
            child: _buildIcon(item, isSelected),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          item.title ?? '',
          style: TextStyleHelper.instance.body12MediumRoboto.copyWith(
            color: isSelected ? appTheme.gray_900 : appTheme.gray_800,
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(CustomBottomBarItem item, bool isSelected) {
    if (isSelected) {
      if (item.activeIconData != null) {
        return Icon(
          item.activeIconData,
          size: 24.h,
          color: appTheme.gray_900,
        );
      }
      return CustomImageView(
        imagePath: item.activeIcon ?? item.icon,
        height: 24.h,
        width: 24.h,
        color: appTheme.gray_900,
      );
    } else {
      if (item.inactiveIconData != null) {
        return Icon(
          item.inactiveIconData,
          size: 24.h,
          color: appTheme.gray_800,
        );
      }
      return CustomImageView(
        imagePath: item.icon,
        height: 24.h,
        width: 24.h,
        color: appTheme.gray_800,
      );
    }
  }
}

class CustomBottomBarItem {
  CustomBottomBarItem({
    this.icon,
    this.activeIcon,
    this.activeIconData,
    this.inactiveIconData, // New field for Material Icons
    this.title,
    this.routeName,
  });

  final String? icon;
  final String? activeIcon;
  final IconData? activeIconData;
  final IconData? inactiveIconData;
  final String? title;
  final String? routeName;
}
