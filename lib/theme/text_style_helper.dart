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

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline32BoldPoppins => TextStyle(
    fontSize: 32.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: appTheme.blue_gray_800_01,
  );

  TextStyle get headline28RegularRoboto => TextStyle(
    fontSize: 28.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: appTheme.black_900,
  );

  TextStyle get headline28MediumRoboto => TextStyle(
    fontSize: 28.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: appTheme.white_A700,
  );

  TextStyle get headline24RegularRozhaOne => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Rozha One',
    color: appTheme.white_A700,
  );

  TextStyle get headline24RegularRoboto => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: appTheme.black_900,
  );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title22RegularRoboto => TextStyle(
    fontSize: 22.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: appTheme.black_900,
  );

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  TextStyle get title16MediumRoboto => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: appTheme.black_900,
  );

  TextStyle get title16RegularRoboto => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: appTheme.black_900,
  );

  TextStyle get title16BoldPoppins => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: appTheme.blue_gray_800_01,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body14MediumRoboto => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  TextStyle get body14RegularRoboto => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: appTheme.gray_900,
  );

  TextStyle get body13RegularPingFangSC => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'PingFang SC',
    color: appTheme.color937F59,
  );

  TextStyle get body12MediumPoppins => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: appTheme.blue_gray_800_01,
  );

  TextStyle get body12MediumRoboto => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  TextStyle get body12RegularRoboto => TextStyle(
    fontSize: 12.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: appTheme.black_900,
  );

  // Label Styles
  // Small text styles for labels, captions, and hints

  TextStyle get label10BoldRoboto => TextStyle(
    fontSize: 10.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Roboto',
    color: appTheme.white_A700,
  );

  TextStyle get headline32RegularRoboto => TextStyle(
    fontSize: 32.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    color: appTheme.black_900,
  );

  TextStyle get label11MediumRoboto => TextStyle(
    fontSize: 11.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
    color: appTheme.red_900,
  );

  TextStyle get bodyTextRoboto => TextStyle(fontFamily: 'Roboto');
}
