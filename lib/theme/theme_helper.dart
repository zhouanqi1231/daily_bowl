import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get gray_900 => Color(0xFF1D1B20);
  Color get blue_gray_100 => Color(0xFFCAC4D0);
  Color get gray_50 => Color(0xFFFEF7FF);
  Color get black_900 => Color(0xFF000000);
  Color get gray_800 => Color(0xFF49454F);
  Color get blue_gray_800 => Color(0xFF4A4459);
  Color get deep_purple_50 => Color(0xFFE8DEF8);
  Color get gray_700 => Color(0xFF625B71);
  Color get purple_50 => Color(0xFFF3EDF7);
  Color get white_A700 => Color(0xFFFFFFFF);
  Color get deep_purple_300 => Color(0xFF9F86C6);
  Color get blue_gray_800_01 => Color(0xFF414D55);
  Color get deep_orange_400 => Color(0xFFFF715B);
  Color get indigo_400 => Color(0xFF6665DD);
  Color get cyan_400 => Color(0xFF34D1BF);
  Color get gray_600_19 => Color(0x196E6E6E);
  Color get gray_900_01 => Color(0xFF212121);
  Color get orange_200 => Color(0xFFFFC369);
  Color get blue_gray_400 => Color(0xFF8E8D8D);
  Color get blue_gray_500_7f => Color(0x7F597393);
  Color get gray_200 => Color(0xFFF0F0F0);
  Color get orange_100 => Color(0xFFFFE3B9);
  Color get orange_300 => Color(0xFFFFBB48);
  Color get gray_300 => Color(0xFFE0E4E8);
  Color get amber_900 => Color(0xFFFF7606);
  Color get lime_900_21 => Color(0x21AF6B2C);
  Color get gray_500 => Color(0xFF949494);
  Color get gray_300_01 => Color(0xFFE6E0E9);
  Color get deep_purple_800 => Color(0xFF4F378A);

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get whiteCustom => Colors.white;
  Color get greenCustom => Colors.green;
  Color get redCustom => Colors.red;
  Color get blackCustom => Colors.black;
  Color get greyCustom => Colors.grey;
  Color get color2C21AF => Color(0x2C21AF6B);
  Color get color937F59 => Color(0x937F5973);
  Color get color990000 => Color(0x99000000);
  Color get color6E196E => Color(0x6E196E6E);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}
