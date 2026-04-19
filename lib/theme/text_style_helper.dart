import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Define the base text color based on the nav bar active state (gray_900)
  Color get _baseTextColor => appTheme.gray_900;

  // Headline Styles
  TextStyle get headline32BoldPoppins => TextStyle(
    fontSize: 32.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: _baseTextColor,
  );

  TextStyle get headline28RegularRoboto => TextStyle(
    fontSize: 28.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get headline28MediumRoboto => TextStyle(
    fontSize: 28.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: appTheme.white_A700, // Keep white for header contrast
  );

  TextStyle get headline24RegularRozhaOne => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Rozha One',
    color: appTheme.white_A700, // Keep white for banner contrast
  );

  TextStyle get headline24RegularRoboto => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  // Title Styles
  TextStyle get title22RegularRoboto => TextStyle(
    fontSize: 22.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get title16MediumRoboto => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get title16RegularRoboto => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get title16BoldPoppins => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: _baseTextColor,
  );

  // Body Styles
  TextStyle get body14MediumRoboto => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get body14RegularRoboto => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get body13RegularPingFangSC => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'PingFang SC',
    color: _baseTextColor,
  );

  TextStyle get body12MediumPoppins => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: _baseTextColor,
  );

  TextStyle get body12MediumRoboto => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get body12RegularRoboto => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  // Label Styles
  TextStyle get label10BoldRoboto => TextStyle(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto',
    color: appTheme.white_A700, // Keep white for high-contrast labels
  );

  TextStyle get headline32RegularRoboto => TextStyle(
    fontSize: 32.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );

  TextStyle get label11MediumRoboto => TextStyle(
    fontSize: 11.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: appTheme.red_900, // Keep red for alerts
  );

  TextStyle get bodyTextRoboto => TextStyle(
    fontFamily: 'Roboto',
    color: _baseTextColor,
  );
}
