import 'package:flutter/material.dart';

/// Typography configuration for the Sakinah app
/// 
/// Provides font configurations for different languages:
/// - Amiri font for Arabic text (beautiful calligraphy)
/// - Roboto/System fonts for English text
class AppTypography {
  static const String arabicFontFamily = 'Amiri';
  static const String englishFontFamily = 'Roboto';

  /// Get text style based on locale/language
  static TextStyle getLocalizedTextStyle({
    required BuildContext context,
    String? locale,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    final isArabic = locale == 'ar' || 
                    Localizations.localeOf(context).languageCode == 'ar';
    
    return TextStyle(
      fontFamily: isArabic ? arabicFontFamily : englishFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      // RTL text direction for Arabic
      textBaseline: isArabic ? TextBaseline.ideographic : TextBaseline.alphabetic,
    );
  }

  /// Get appropriate text direction based on locale
  static TextDirection getTextDirection(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Check if current locale is Arabic
  static bool isArabicLocale(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }
}

/// Predefined text styles for Arabic content
class ArabicTextStyles {
  static const TextStyle headline = TextStyle(
    fontFamily: AppTypography.arabicFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static const TextStyle title = TextStyle(
    fontFamily: AppTypography.arabicFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppTypography.arabicFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppTypography.arabicFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Large azkar text style for beautiful display
  static const TextStyle azkarText = TextStyle(
    fontFamily: AppTypography.arabicFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.8,
    letterSpacing: 0.5,
  );

  /// Small azkar text for translations/transliterations
  static const TextStyle azkarTranslation = TextStyle(
    fontFamily: AppTypography.arabicFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontStyle: FontStyle.italic,
  );
}

/// Predefined text styles for English content
class EnglishTextStyles {
  static const TextStyle headline = TextStyle(
    fontFamily: AppTypography.englishFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const TextStyle title = TextStyle(
    fontFamily: AppTypography.englishFontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppTypography.englishFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppTypography.englishFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppTypography.englishFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}

/// Extension to add localized text styles to TextStyle
extension LocalizedTextStyle on TextStyle {
  /// Apply Arabic font family
  TextStyle get arabic => copyWith(fontFamily: AppTypography.arabicFontFamily);
  
  /// Apply English font family
  TextStyle get english => copyWith(fontFamily: AppTypography.englishFontFamily);
  
  /// Apply font family based on context locale
  TextStyle localized(BuildContext context) {
    final isArabic = AppTypography.isArabicLocale(context);
    return copyWith(
      fontFamily: isArabic 
          ? AppTypography.arabicFontFamily 
          : AppTypography.englishFontFamily,
    );
  }
}
