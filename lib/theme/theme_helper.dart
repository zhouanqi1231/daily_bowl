import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
class ThemeHelper {
  // The current app theme
  final _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
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
  static const lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get gray_50 => const Color(0xFFFEF7FF);
  Color get gray_200 => const Color(0xFFF0F0F0);
  Color get gray_300 => const Color(0xFFE0E4E8);
  Color get gray_400 => const Color(0xFFBDBDBD);
  Color get gray_500 => const Color(0xFF949494);
  Color get gray_600 => const Color(0xFF828282);
  Color get gray_700 => const Color(0xFF625B71);
  Color get gray_800 => const Color(0xFF49454F);
  Color get gray_900 => const Color(0xFF1D1B20);
  
  Color get blueGray_100 => const Color(0xFFCAC4D0);
  Color get blueGray_400 => const Color(0xFF8E8D8D);
  Color get blueGray_800 => const Color(0xFF4A4459);
  
  Color get deepPurple_50 => const Color(0xFFE8DEF8);
  Color get deepPurple_300 => const Color(0xFF9F86C6);
  Color get deepPurple_800 => const Color(0xFF4F378A);
  
  Color get purple_50 => const Color(0xFFF3EDF7);
  
  Color get white_700 => const Color(0xFFFFFFFF);
  Color get black_900 => const Color(0xFF000000);
  
  // Colors with opacity
  Color get red_900 => const Color(0xFFB3261E);

  // Additional/Custom Colors
  Color get redCustom => Colors.red;
  Color get greenCustom => Colors.green;
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get greyCustom => Colors.grey;
  Color get transparentCustom => Colors.transparent;

  Color get color2C21AF => const Color(0x2C21AF6B);
  Color get color937F59 => const Color(0x937F5973);
  Color get color990000 => const Color(0x99000000);
  Color get color6E196E => const Color(0x6E196E6E);

  // Color Shades
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;
}
