import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * CustomCheckBox - A reusable checkbox component with custom styling
 * 
 * Features:
 * - Custom shadow and border radius styling
 * - Configurable text label and checkbox state
 * - Consistent padding and layout
 * - Support for form validation and theming
 * - Responsive design with SizeUtils
 * 
 * @param text - The label text displayed next to the checkbox
 * @param value - Current checked state of the checkbox
 * @param onChanged - Callback function when checkbox state changes
 * @param textStyle - Custom text style for the label (optional)
 * @param checkboxColor - Color of the checkbox when checked (optional)
 * @param backgroundColor - Background color of the container (optional)
 * @param borderRadius - Border radius of the container (optional)
 * @param padding - Custom padding for the container (optional)
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
  }) : super(key: key);

  /// The label text displayed next to the checkbox
  final String text;

  /// Current checked state of the checkbox
  final bool value;

  /// Callback function when checkbox state changes
  final ValueChanged<bool?>? onChanged;

  /// Custom text style for the label
  final TextStyle? textStyle;

  /// Color of the checkbox when checked
  final Color? checkboxColor;

  /// Background color of the container
  final Color? backgroundColor;

  /// Border radius of the container
  final BorderRadius? borderRadius;

  /// Custom padding for the container
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(text, style: textStyle ?? _getDefaultTextStyle()),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: checkboxColor ?? Theme.of(context).primaryColor,
        contentPadding: padding ?? EdgeInsets.fromLTRB(18.h, 16.h, 42.h, 16.h),
        dense: false,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyleHelper.instance.title16MediumRoboto.copyWith(height: 1.19);
  }
}
