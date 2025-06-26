import 'package:flutter/material.dart';

class LanguageService {
  // Store the locale globally
  static Locale? _currentLocale;

  // Initialize the language service
  static void initialize(Locale locale) {
    _currentLocale = locale;
  }

  // Get the current language code
  static String get languageCode => _currentLocale?.languageCode ?? 'en';

  // Set the current locale
  static void setLocale(Locale locale) {
    _currentLocale = locale;
  }
}
