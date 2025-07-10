import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography configuration for the entire app using Playpen Sans Arabic
class AppTypography {
  static const String fontFamily = 'PlaypenSans';

  /// Specialized Arabic text styles for optimal readability
  static TextStyle arabicDisplayLarge = GoogleFonts.playpenSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 2.0,
    letterSpacing: 1.0,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle arabicHeadline = GoogleFonts.playpenSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.8,
    letterSpacing: 0.8,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle arabicBody = GoogleFonts.playpenSans(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 2.2,
    letterSpacing: 0.6,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle arabicCaption = GoogleFonts.playpenSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.4,
    color: const Color(0xFF1A1A1A),
  );

  /// Light theme text theme using Playpen Sans Arabic
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.playpenSans(
      fontSize: 32,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      color: const Color(0xFF1A1A1A),
    ),
    displayMedium: GoogleFonts.playpenSans(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      color: const Color(0xFF1A1A1A),
    ),
    displaySmall: GoogleFonts.playpenSans(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: const Color(0xFF1A1A1A),
    ),
    headlineLarge: GoogleFonts.playpenSans(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: const Color(0xFF1A1A1A),
    ),
    headlineMedium: GoogleFonts.playpenSans(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: const Color(0xFF1A1A1A),
    ),
    headlineSmall: GoogleFonts.playpenSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: const Color(0xFF1A1A1A),
    ),
    titleLarge: GoogleFonts.playpenSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: const Color(0xFF1A1A1A),
    ),
    titleMedium: GoogleFonts.playpenSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: const Color(0xFF1A1A1A),
    ),
    titleSmall: GoogleFonts.playpenSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: const Color(0xFF1A1A1A),
    ),
    bodyLarge: GoogleFonts.playpenSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: const Color(0xFF1A1A1A),
    ),
    bodyMedium: GoogleFonts.playpenSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: const Color(0xFF1A1A1A),
    ),
    bodySmall: GoogleFonts.playpenSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: const Color(0xFF1A1A1A),
    ),
    labelLarge: GoogleFonts.playpenSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      color: const Color(0xFF1A1A1A),
    ),
    labelMedium: GoogleFonts.playpenSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: const Color(0xFF1A1A1A),
    ),
    labelSmall: GoogleFonts.playpenSans(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: const Color(0xFF1A1A1A),
    ),
  );

  /// Dark theme text theme using Playpen Sans Arabic
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.playpenSans(
      fontSize: 32,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
      color: const Color(0xFFFFFFFF),
    ),
    displayMedium: GoogleFonts.playpenSans(
      fontSize: 28,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
      color: const Color(0xFFFFFFFF),
    ),
    displaySmall: GoogleFonts.playpenSans(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: const Color(0xFFFFFFFF),
    ),
    headlineLarge: GoogleFonts.playpenSans(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      color: const Color(0xFFFFFFFF),
    ),
    headlineMedium: GoogleFonts.playpenSans(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: const Color(0xFFFFFFFF),
    ),
    headlineSmall: GoogleFonts.playpenSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: const Color(0xFFFFFFFF),
    ),
    titleLarge: GoogleFonts.playpenSans(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: const Color(0xFFFFFFFF),
    ),
    titleMedium: GoogleFonts.playpenSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: const Color(0xFFFFFFFF),
    ),
    titleSmall: GoogleFonts.playpenSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: const Color(0xFFFFFFFF),
    ),
    bodyLarge: GoogleFonts.playpenSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: const Color(0xFFFFFFFF),
    ),
    bodyMedium: GoogleFonts.playpenSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: const Color(0xFFFFFFFF),
    ),
    bodySmall: GoogleFonts.playpenSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: const Color(0xFFFFFFFF),
    ),
    labelLarge: GoogleFonts.playpenSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
      color: const Color(0xFFFFFFFF),
    ),
    labelMedium: GoogleFonts.playpenSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: const Color(0xFFFFFFFF),
    ),
    labelSmall: GoogleFonts.playpenSans(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
      color: const Color(0xFFFFFFFF),
    ),
  );
}
