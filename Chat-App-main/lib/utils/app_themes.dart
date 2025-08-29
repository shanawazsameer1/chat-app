import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryGreen = Color(0xFF00A884);
  static const Color primaryGreenDark = Color(0xFF008069);
  static const Color accentGreen = Color(0xFF25D366);
  static const Color tealLight = Color(0xFF128C7E);
  static const Color tealDark = Color(0xFF075E54);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F8FA);
  static const Color lightChatBubbleMe = Color(0xFFDCF8C6);
  static const Color lightChatBubbleOther = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF667781);
  static const Color lightDivider = Color(0xFFE9EDEF);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF111B21);
  static const Color darkSurface = Color(0xFF202C33);
  static const Color darkChatBubbleMe = Color(0xFF005C4B);
  static const Color darkChatBubbleOther = Color(0xFF202C33);
  static const Color darkText = Color(0xFFE9EDEF);
  static const Color darkTextSecondary = Color(0xFF8696A0);
  static const Color darkDivider = Color(0xFF313D44);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: tealDark,
      foregroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      onPrimary: Colors.white,
      secondary: accentGreen,
      surface: lightSurface,
      onSurface: lightText,
      background: lightBackground,
      onBackground: lightText,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
      titleLarge: TextStyle(color: lightText, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: lightTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: darkText,
      elevation: 1,
      iconTheme: IconThemeData(color: darkText),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryGreen,
      onPrimary: Colors.white,
      secondary: accentGreen,
      surface: darkSurface,
      onSurface: darkText,
      background: darkBackground,
      onBackground: darkText,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: darkTextSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );
}
