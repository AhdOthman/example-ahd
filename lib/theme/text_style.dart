import 'package:flutter/material.dart';
import 'language_service.dart';

class AppTextStyles {
  // Method to get the font family based on the current language
  static String getFontFamily() {
    final langCode = LanguageService.languageCode;
    return langCode == 'ar' ? 'Zain' : 'Inter';
  }

  // Black (900) font style
  static TextStyle black = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w900, // Black weight (900)
  );

  // Extra Bold (800) font style
  static TextStyle extraBold = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w800, // ExtraBold weight (800)
  );

  // Bold (700) font style
  static TextStyle bold = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w700, // Bold weight (700)
  );

  // SemiBold (600) font style
  static TextStyle semiBold = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w600, // SemiBold weight (600)
  );

  // Medium (500) font style
  static TextStyle medium = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w500, // Medium weight (500)
  );

  // Regular (400) font style
  static TextStyle regular = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w400, // Regular weight (400)
  );

  // Light (300) font style
  static TextStyle light = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w300, // Light weight (300)
  );

  // ExtraLight (200) font style
  static TextStyle extraLight = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w200, // ExtraLight weight (200)
  );

  // Thin (100) font style
  static TextStyle thin = TextStyle(
    fontFamily: getFontFamily(),
    fontWeight: FontWeight.w100, // Thin weight (100)
  );

  // Method to get text style with custom font size and color
  static TextStyle custom({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: getFontFamily(),
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }
}
