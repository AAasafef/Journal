import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF4EFE8);

  static const Color paper = Color(0xFFF8F2EA);

  static const Color primaryText = Color(0xFF2D241E);

  static const Color secondaryText = Color(0xFF6F6258);

  static const Color accent = Color(0xFF74624F);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: Brightness.light,
      ),
    );
  }
}
