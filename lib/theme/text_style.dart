import 'package:flutter/material.dart';

class AppTextStyles {
  // Font family name
  static const String _fontFamily = 'Cascadia Code';

  // Black (900) font style
  static const TextStyle black = TextStyle(
    fontFamily: _fontFamily,

    fontWeight: FontWeight.w900, // Black weight (900)
  );

  // Extra Bold (800) font style
  static const TextStyle extraBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w800, // ExtraBold weight (800)
  );

  // Bold (700) font style
  static const TextStyle bold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700, // Bold weight (700)
  );

  // SemiBold (600) font style
  static const TextStyle semiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600, // SemiBold weight (600)
  );

  // Medium (500) font style
  static const TextStyle medium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500, // Medium weight (500)
  );

  // Regular (400) font style
  static const TextStyle regular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400, // Regular weight (400)
  );

  // Light (300) font style
  static const TextStyle light = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w300, // Light weight (300)
  );

  // ExtraLight (200) font style
  static const TextStyle extraLight = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w200, // ExtraLight weight (200)
  );

  // Thin (100) font style
  static const TextStyle thin = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w100, // Thin weight (100)
  );

  // Method to get text style with custom font size and color
  static TextStyle custom({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }
}
