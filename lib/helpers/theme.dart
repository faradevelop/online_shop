import 'package:flutter/material.dart';

class ThemeHelper {
  static const TextTheme _textTheme = TextTheme(
    bodyLarge: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF3A3A3A)),
    bodyMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF8C8C8C),
    ),
    labelLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF14489E),
    ),
    labelSmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF3A3A3A)),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF3A3A3A),
    ),
    titleMedium: TextStyle(
        fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF3A3A3A)),
    titleSmall: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF3A3A3A)),
  );

  static ThemeData lightTheme = ThemeData(
    fontFamily: "YekanBakh",
    scaffoldBackgroundColor: const Color(0xFFF8F8F8),
    textTheme: _textTheme,
    iconTheme: const IconThemeData(
      color: Color(0xFF292D32),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF3A3A3A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
    dividerColor: const Color(0xFFE1E1E1),
    hintColor: const Color(0xFFB4B4B4),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF14489E),
      secondary: Colors.white,
      onSecondary: Color(0xFF3A3A3A),
      primaryContainer: Colors.white,
      secondaryContainer: Color(0xFFED723F),
      onSurface: Color(0xFF8C8C8C),
    ),
  );
}
