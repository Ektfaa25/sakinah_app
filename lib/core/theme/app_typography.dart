import 'package:flutter/material.dart';

/// Typography configuration for the entire app using Playpen Sans Arabic
class AppTypography {
  static const String fontFamily = 'PlaypenSansArabic';

  /// Helper method to create TextStyle with PlaypenSansArabic font
  /// This replaces GoogleFonts.playpenSans() calls throughout the app
  static TextStyle playpenSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Specialized Arabic text styles for optimal readability
  static const TextStyle arabicDisplayLarge = TextStyle(
    fontFamily: 'PlaypenSansArabic',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 2.0,
    letterSpacing: 1.0,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle arabicHeadline = TextStyle(
    fontFamily: 'PlaypenSansArabic',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.8,
    letterSpacing: 0.8,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle arabicBody = TextStyle(
    fontFamily: 'PlaypenSansArabic',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 2.2,
    letterSpacing: 0.6,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle arabicCaption = TextStyle(
    fontFamily: 'PlaypenSansArabic',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.4,
    color: Color(0xFF1A1A1A),
  );

  /// Light theme text theme using Playpen Sans Arabic
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 32,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      color: Color(0xFF1A1A1A),
    ),
    displayMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 28,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      color: Color(0xFF1A1A1A),
    ),
    displaySmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: Color(0xFF1A1A1A),
    ),
    headlineLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: Color(0xFF1A1A1A),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFF1A1A1A),
    ),
    headlineSmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: Color(0xFF1A1A1A),
    ),
    titleLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFF1A1A1A),
    ),
    titleMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1A1A1A),
    ),
    titleSmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1A1A1A),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Color(0xFF1A1A1A),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFF1A1A1A),
    ),
    bodySmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFF1A1A1A),
    ),
    labelLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      color: Color(0xFF1A1A1A),
    ),
    labelMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: Color(0xFF1A1A1A),
    ),
    labelSmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: Color(0xFF1A1A1A),
    ),
  );

  /// Dark theme text theme using Playpen Sans Arabic
  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 32,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      color: Color(0xFFFFFFFF),
    ),
    displayMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 28,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      color: Color(0xFFFFFFFF),
    ),
    displaySmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: Color(0xFFFFFFFF),
    ),
    headlineLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: Color(0xFFFFFFFF),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFFFFFFFF),
    ),
    headlineSmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: Color(0xFFFFFFFF),
    ),
    titleLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFFFFFFFF),
    ),
    titleMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFFFFFFF),
    ),
    titleSmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFFFFFFF),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Color(0xFFFFFFFF),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFFFFFFFF),
    ),
    bodySmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFFFFFFFF),
    ),
    labelLarge: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      color: Color(0xFFFFFFFF),
    ),
    labelMedium: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: Color(0xFFFFFFFF),
    ),
    labelSmall: TextStyle(
      fontFamily: 'PlaypenSansArabic',
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: Color(0xFFFFFFFF),
    ),
  );
}
