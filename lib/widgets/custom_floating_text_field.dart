import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_export.dart';

/**
 * CustomFloatingTextField - A Material Design floating label text field component
 * 
 * Features:
 * - Floating label animation
 * - Customizable input types and keyboard types  
 * - Validator support for form validation
 * - Responsive design using SizeUtils
 * - Material Design styling with custom colors
 * 
 * @param placeholder - The placeholder/label text
 * @param validator - Optional validation function
 * @param keyboardType - Keyboard type based on input type
 * @param inputFormatters - Optional input formatters for validation
 * @param controller - Text editing controller
 * @param onChanged - Callback when text changes
 * @param enabled - Whether the field is enabled
 * @param maxLines - Maximum number of lines
 * @param width - Custom width for the field
 * @param topMargin - Top margin spacing
 * @param topPadding - Additional top padding for content
 * @param textStyle - Optional custom text style
 * @param labelStyle - Optional custom label style
 */
class CustomFloatingTextField extends StatelessWidget {
  CustomFloatingTextField({
    Key? key,
    required this.placeholder,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.controller,
    this.onChanged,
    this.enabled,
    this.maxLines,
    this.width,
    this.topMargin,
    this.topPadding,
    this.textStyle,
    this.labelStyle,
  }) : super(key: key);

  /// Placeholder text that becomes the floating label
  final String placeholder;

  /// Validation function for form validation
  final String? Function(String?)? validator;

  /// Keyboard type for different input methods
  final TextInputType? keyboardType;

  /// Input formatters for text validation
  final List<TextInputFormatter>? inputFormatters;

  /// Text editing controller
  final TextEditingController? controller;

  /// Callback function when text changes
  final Function(String)? onChanged;

  /// Whether the text field is enabled
  final bool? enabled;

  /// Maximum number of lines
  final int? maxLines;

  /// Custom width for the text field
  final double? width;

  /// Top margin for spacing
  final double? topMargin;

  /// Additional top padding for content area
  final double? topPadding;

  /// Custom text style
  final TextStyle? textStyle;

  /// Custom label style
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(top: topMargin ?? 0.h),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType ?? TextInputType.text,
        inputFormatters: inputFormatters,
        enabled: enabled ?? true,
        maxLines: maxLines ?? 1,
        onChanged: onChanged,
        style: textStyle ??
            TextStyleHelper.instance.title16RegularRoboto.copyWith(
              color: appTheme.gray_900,
            ),
        decoration: InputDecoration(
          labelText: placeholder,
          labelStyle: labelStyle ??
              TextStyleHelper.instance.title16RegularRoboto.copyWith(
                color: appTheme.gray_600,
              ),
          floatingLabelStyle: TextStyleHelper.instance.body12RegularRoboto
              .copyWith(color: appTheme.gray_600),
          filled: true,
          fillColor: appTheme.gray_50,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: appTheme.gray_50, width: 1.h),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: appTheme.gray_50, width: 1.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: appTheme.gray_50, width: 2.h),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: appTheme.redCustom, width: 1.h),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: appTheme.redCustom, width: 2.h),
          ),
        ),
      ),
    );
  }

  /// Helper method to get keyboard type based on input type
  static TextInputType getKeyboardType(String inputType) {
    switch (inputType.toUpperCase()) {
      case 'NUMBER_ONLY':
        return TextInputType.number;
      case 'TEXT_ONLY':
        return TextInputType.text;
      case 'EMAIL':
        return TextInputType.emailAddress;
      case 'PHONE':
        return TextInputType.phone;
      case 'MULTILINE':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  /// Helper method to get input formatters based on input type
  static List<TextInputFormatter>? getInputFormatters(String inputType) {
    switch (inputType.toUpperCase()) {
      case 'NUMBER_ONLY':
        return [FilteringTextInputFormatter.digitsOnly];
      case 'DECIMAL':
        return [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))];
      default:
        return null;
    }
  }
}
