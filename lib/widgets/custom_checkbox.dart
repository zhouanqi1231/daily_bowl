import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomCheckBox - A reusable checkbox component with custom styling
 */
class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
    this.textStyle,
    this.checkboxColor,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.height, // Added height parameter
  }) : super(key: key);

  final String text;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final TextStyle? textStyle;
  final Color? checkboxColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? height; // Added height property

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // Set fixed height if provided
      decoration: BoxDecoration(
        color: backgroundColor ?? Color(0xFFFFFFFF),
        borderRadius: borderRadius ?? BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9F86C6).withAlpha(77),
            offset: Offset(0, 1.h),
            blurRadius: 5.h,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center( // Wrap in Center to ensure content is aligned with the height
        child: CheckboxListTile(
          value: value,
          onChanged: onChanged,
          title: Text(text, style: textStyle ?? _getDefaultTextStyle()),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: checkboxColor ?? appTheme.deep_purple_800,
          contentPadding: padding ?? EdgeInsets.symmetric(horizontal: 18.h),
          dense: true,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyleHelper.instance.title16MediumRoboto.copyWith(height: 1.1);
  }
}
