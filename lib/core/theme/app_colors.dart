import 'package:flutter/material.dart';

/// App color palette with pastel colors and glassy UI styling
class AppColors {
  // Light theme colors
  static const Color lightPrimary = Color(0xFF9CAF88); // Sage green
  static const Color lightPrimaryContainer = Color(0xFFE8F5E8);
  static const Color lightSecondary = Color(0xFFD4A5A5); // Dusty rose
  static const Color lightSecondaryContainer = Color(0xFFF5E8E8);
  static const Color lightTertiary = Color(0xFFC8B5D1); // Lavender
  static const Color lightTertiaryContainer = Color(0xFFF0E8F5);
  static const Color lightSurface = Color(0xFFFAF7F0); // Cream
  static const Color lightSurfaceContainer = Color(0xFFF5F2EB);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF2C2C2C);
  static const Color lightOnBackground = Color(0xFF1C1C1C);
  static const Color lightOutline = Color(0xFFE0E0E0);
  static const Color lightError = Color(0xFFB3261E);
  static const Color lightSuccess = Color(0xFF4CAF50);
  static const Color lightWarning = Color(0xFFFF9800);
  static const Color lightInfo = Color(0xFF2196F3);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF7A8A6E); // Darker sage green
  static const Color darkPrimaryContainer = Color(0xFF2A3D2A);
  static const Color darkSecondary = Color(0xFFB8908B); // Darker dusty rose
  static const Color darkSecondaryContainer = Color(0xFF3D2A2A);
  static const Color darkTertiary = Color(0xFF9B7FA8); // Darker lavender
  static const Color darkTertiaryContainer = Color(0xFF3A2A3D);
  static const Color darkSurface = Color(0xFF1C1C1C);
  static const Color darkSurfaceContainer = Color(0xFF242424);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnTertiary = Color(0xFF000000);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnBackground = Color(0xFFE8E8E8);
  static const Color darkOutline = Color(0xFF484848);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkWarning = Color(0xFFFFB74D);
  static const Color darkInfo = Color(0xFF64B5F6);

  // Glassy effect colors
  static const Color glassOverlay = Color(0x0FFFFFFF);
  static const Color glassOverlayDark = Color(0x1FFFFFFF);
  static const Color glassBorder = Color(0x3FFFFFFF);
  static const Color glassBorderDark = Color(0x2FFFFFFF);
  static const Color glassBackground = Color(0x0DFFFFFF);
  static const Color glassBackgroundDark = Color(0x1AFFFFFF);

  // Gradient colors
  static const List<Color> primaryGradient = [lightPrimary, lightSecondary];

  static const List<Color> primaryGradientDark = [darkPrimary, darkSecondary];

  static const List<Color> secondaryGradient = [lightSecondary, lightTertiary];

  static const List<Color> secondaryGradientDark = [
    darkSecondary,
    darkTertiary,
  ];

  static const List<Color> surfaceGradient = [
    lightSurface,
    lightSurfaceContainer,
  ];

  static const List<Color> surfaceGradientDark = [
    darkSurface,
    darkSurfaceContainer,
  ];

  // Mood colors
  static const Color moodHappy = Color(0xFFFFF59D);
  static const Color moodSad = Color(0xFF9FA8DA);
  static const Color moodAnxious = Color(0xFFF8BBD9);
  static const Color moodGrateful = Color(0xFFC8E6C9);
  static const Color moodStressed = Color(0xFFFFCC80);
  static const Color moodPeaceful = Color(0xFFB3E5FC);

  // Shadow colors
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowDark = Color(0x26000000);

  // Utility methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static LinearGradient getGradient(
    List<Color> colors, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(begin: begin, end: end, colors: colors);
  }

  static BoxShadow getGlowShadow(Color color, {double blurRadius = 10}) {
    return BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: blurRadius,
      spreadRadius: 2,
    );
  }
}
