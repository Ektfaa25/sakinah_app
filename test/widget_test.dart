// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/core/theme/app_typography.dart';

void main() {
  group('Sakinah App Tests', () {
    testWidgets('AppTypography configuration test', (
      WidgetTester tester,
    ) async {
      // Verify Arabic font family
      expect(AppTypography.arabicFontFamily, equals('Amiri'));
      expect(AppTypography.englishFontFamily, equals('Roboto'));

      // Verify Arabic text styles are configured
      expect(ArabicTextStyles.azkarText.fontFamily, equals('Amiri'));
      expect(ArabicTextStyles.azkarText.fontSize, equals(24));

      // Verify English text styles are configured
      expect(EnglishTextStyles.button.fontFamily, equals('Roboto'));
      expect(EnglishTextStyles.button.fontSize, equals(16));
    });

    testWidgets('Localized TextStyle extension test', (
      WidgetTester tester,
    ) async {
      const baseStyle = TextStyle(fontSize: 16);

      // Test Arabic font application
      final arabicStyle = baseStyle.arabic;
      expect(arabicStyle.fontFamily, equals('Amiri'));

      // Test English font application
      final englishStyle = baseStyle.english;
      expect(englishStyle.fontFamily, equals('Roboto'));
    });
  });
}
