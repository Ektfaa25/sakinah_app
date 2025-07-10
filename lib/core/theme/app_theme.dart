import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sakinah_app/core/theme/app_colors.dart';
import 'package:sakinah_app/core/theme/app_typography.dart';

/// Main theme configuration for the app
class AppTheme {
  /// Light theme configuration
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      tertiary: AppColors.lightTertiary,
      tertiaryContainer: AppColors.lightTertiaryContainer,
      surface: AppColors.lightSurface,
      surfaceContainer: AppColors.lightSurfaceContainer,
      background: AppColors.lightBackground,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onTertiary: AppColors.lightOnTertiary,
      onSurface: AppColors.lightOnSurface,
      onBackground: AppColors.lightOnBackground,
      outline: AppColors.lightOutline,
      error: AppColors.lightError,
    ),
    textTheme: AppTypography.lightTextTheme,
    appBarTheme: _lightAppBarTheme,
    elevatedButtonTheme: _lightElevatedButtonTheme,
    outlinedButtonTheme: _lightOutlinedButtonTheme,
    cardTheme: _lightCardTheme,
    bottomNavigationBarTheme: _lightBottomNavigationBarTheme,
    inputDecorationTheme: _lightInputDecorationTheme,
    dividerTheme: _lightDividerTheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    dialogTheme: _lightDialogTheme,
    sliderTheme: _lightSliderTheme,
    tabBarTheme: _lightTabBarTheme,
    chipTheme: _lightChipTheme,
    progressIndicatorTheme: _lightProgressIndicatorTheme,
    extensions: [GlassyThemeExtension.light],
  );

  /// Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      surface: AppColors.darkSurface,
      surfaceContainer: AppColors.darkSurfaceContainer,
      background: AppColors.darkBackground,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onTertiary: AppColors.darkOnTertiary,
      onSurface: AppColors.darkOnSurface,
      onBackground: AppColors.darkOnBackground,
      outline: AppColors.darkOutline,
      error: AppColors.darkError,
    ),
    textTheme: AppTypography.darkTextTheme,
    appBarTheme: _darkAppBarTheme,
    elevatedButtonTheme: _darkElevatedButtonTheme,
    outlinedButtonTheme: _darkOutlinedButtonTheme,
    cardTheme: _darkCardTheme,
    bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
    inputDecorationTheme: _darkInputDecorationTheme,
    dividerTheme: _darkDividerTheme,
    scaffoldBackgroundColor: AppColors.darkBackground,
    dialogTheme: _darkDialogTheme,
    sliderTheme: _darkSliderTheme,
    tabBarTheme: _darkTabBarTheme,
    chipTheme: _darkChipTheme,
    progressIndicatorTheme: _darkProgressIndicatorTheme,
    extensions: [GlassyThemeExtension.dark],
  );

  // Light theme components
  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.lightOnSurface,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  static final ElevatedButtonThemeData _lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      );

  static final OutlinedButtonThemeData _lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          side: const BorderSide(color: AppColors.lightPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );

  static const CardThemeData _lightCardTheme = CardThemeData(
    color: AppColors.lightSurface,
    surfaceTintColor: AppColors.lightSurface,
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static const BottomNavigationBarThemeData _lightBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFE3F1F1), // Updated to use #E3F1F1
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightOnSurface,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static final InputDecorationTheme _lightInputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      );

  static const DividerThemeData _lightDividerTheme = DividerThemeData(
    color: AppColors.lightOutline,
    thickness: 1,
    space: 1,
  );

  static const DialogThemeData _lightDialogTheme = DialogThemeData(
    backgroundColor: AppColors.lightSurface,
    surfaceTintColor: AppColors.lightSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static const SliderThemeData _lightSliderTheme = SliderThemeData(
    activeTrackColor: AppColors.lightPrimary,
    inactiveTrackColor: AppColors.lightOutline,
    thumbColor: AppColors.lightPrimary,
    overlayColor: AppColors.lightPrimaryContainer,
  );

  static const TabBarThemeData _lightTabBarTheme = TabBarThemeData(
    labelColor: AppColors.lightPrimary,
    unselectedLabelColor: AppColors.lightOnSurface,
    indicatorColor: AppColors.lightPrimary,
    indicatorSize: TabBarIndicatorSize.tab,
  );

  static const ChipThemeData _lightChipTheme = ChipThemeData(
    backgroundColor: AppColors.lightSurfaceContainer,
    selectedColor: AppColors.lightPrimary,
    labelStyle: TextStyle(color: AppColors.lightOnSurface),
    secondaryLabelStyle: TextStyle(color: AppColors.lightOnPrimary),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  static const ProgressIndicatorThemeData _lightProgressIndicatorTheme =
      ProgressIndicatorThemeData(
        color: AppColors.lightPrimary,
        linearTrackColor: AppColors.lightOutline,
        circularTrackColor: AppColors.lightOutline,
      );

  // Dark theme components
  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.darkOnSurface,
    elevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  static final ElevatedButtonThemeData _darkElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 2,
        ),
      );

  static final OutlinedButtonThemeData _darkOutlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );

  static const CardThemeData _darkCardTheme = CardThemeData(
    color: AppColors.darkSurface,
    surfaceTintColor: AppColors.darkSurface,
    elevation: 2,
    margin: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static const BottomNavigationBarThemeData _darkBottomNavigationBarTheme =
      BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFE3F1F1), // Updated to use #E3F1F1
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkOnSurface,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static final InputDecorationTheme _darkInputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      );

  static const DividerThemeData _darkDividerTheme = DividerThemeData(
    color: AppColors.darkOutline,
    thickness: 1,
    space: 1,
  );

  static const DialogThemeData _darkDialogTheme = DialogThemeData(
    backgroundColor: AppColors.darkSurface,
    surfaceTintColor: AppColors.darkSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static const SliderThemeData _darkSliderTheme = SliderThemeData(
    activeTrackColor: AppColors.darkPrimary,
    inactiveTrackColor: AppColors.darkOutline,
    thumbColor: AppColors.darkPrimary,
    overlayColor: AppColors.darkPrimaryContainer,
  );

  static const TabBarThemeData _darkTabBarTheme = TabBarThemeData(
    labelColor: AppColors.darkPrimary,
    unselectedLabelColor: AppColors.darkOnSurface,
    indicatorColor: AppColors.darkPrimary,
    indicatorSize: TabBarIndicatorSize.tab,
  );

  static const ChipThemeData _darkChipTheme = ChipThemeData(
    backgroundColor: AppColors.darkSurfaceContainer,
    selectedColor: AppColors.darkPrimary,
    labelStyle: TextStyle(color: AppColors.darkOnSurface),
    secondaryLabelStyle: TextStyle(color: AppColors.darkOnPrimary),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  static const ProgressIndicatorThemeData _darkProgressIndicatorTheme =
      ProgressIndicatorThemeData(
        color: AppColors.darkPrimary,
        linearTrackColor: AppColors.darkOutline,
        circularTrackColor: AppColors.darkOutline,
      );
}

/// Theme extension for glassy effects
class GlassyThemeExtension extends ThemeExtension<GlassyThemeExtension> {
  final Color overlayColor;
  final Color borderColor;
  final Color backgroundColor;
  final double blurRadius;
  final double borderWidth;

  const GlassyThemeExtension({
    required this.overlayColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.blurRadius,
    required this.borderWidth,
  });

  static const GlassyThemeExtension light = GlassyThemeExtension(
    overlayColor: AppColors.glassOverlay,
    borderColor: AppColors.glassBorder,
    backgroundColor: AppColors.glassBackground,
    blurRadius: 10,
    borderWidth: 1,
  );

  static const GlassyThemeExtension dark = GlassyThemeExtension(
    overlayColor: AppColors.glassOverlayDark,
    borderColor: AppColors.glassBorderDark,
    backgroundColor: AppColors.glassBackgroundDark,
    blurRadius: 10,
    borderWidth: 1,
  );

  @override
  GlassyThemeExtension copyWith({
    Color? overlayColor,
    Color? borderColor,
    Color? backgroundColor,
    double? blurRadius,
    double? borderWidth,
  }) {
    return GlassyThemeExtension(
      overlayColor: overlayColor ?? this.overlayColor,
      borderColor: borderColor ?? this.borderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      blurRadius: blurRadius ?? this.blurRadius,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  GlassyThemeExtension lerp(GlassyThemeExtension? other, double t) {
    if (other is! GlassyThemeExtension) return this;
    return GlassyThemeExtension(
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      blurRadius: blurRadius,
      borderWidth: borderWidth,
    );
  }
}
