// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static AppTheme of(BuildContext context) {
    return LightModeTheme();
  }

  late Color primaryColor;
  late Color tertiaryColor;
  late Color iWowColor;
  late Color primaryBackground;
  late Color primaryText;

  late Color backgroundColor;
  late Color lineColor;
  late Color cardColor;
  late Color iconColor;
  late Color borderCard;
  late Color badgeColor;

  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends AppTheme {
  late Color primaryColor = const Color(0xFF1C1C1C);
  late Color iWowColor = const Color(0xFFE45936);
  late Color primaryBackground = const Color(0xFFF1F4F8);
  late Color primaryText = const Color(0xFF101213);
  late Color backgroundColor = Color(0xFFF9F9F9);
  late Color lineColor = Color(0xFFE8E8E8);
  late Color cardColor = Color(0xFFFFFFFF);
  late Color iconColor = Color(0xFFCECECE);
  late Color borderCard = Color(0xFF202020);
  late Color badgeColor = Color(0xFFB20C0C);
}

abstract class Typography {
  String get bodyText1Family;
  TextStyle get bodyText1;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);
  final AppTheme theme;
  String get bodyText1Family => 'Roboto';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Roboto',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}

extension Helper on TextStyle {
  TextStyle copyWith({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              lineHeight: lineHeight,
            );
}
