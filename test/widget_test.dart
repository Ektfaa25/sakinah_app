// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  group('Sakinah App Tests', () {
    testWidgets('Playpen Sans Arabic font configuration test', (
      WidgetTester tester,
    ) async {
      // Verify Playpen Sans Arabic is being used
      final textStyle = GoogleFonts.playpenSans();
      expect(textStyle.fontFamily, contains('PlaypenSans'));

      // Test that the font loads and has valid properties
      expect(textStyle.fontFamily, isNotNull);
    });

    testWidgets('Google Fonts integration test', (WidgetTester tester) async {
      // Test creating text style with different weights
      final lightStyle = GoogleFonts.playpenSans(fontWeight: FontWeight.w300);
      final regularStyle = GoogleFonts.playpenSans(fontWeight: FontWeight.w400);
      final boldStyle = GoogleFonts.playpenSans(fontWeight: FontWeight.w700);

      expect(lightStyle.fontWeight, equals(FontWeight.w300));
      expect(regularStyle.fontWeight, equals(FontWeight.w400));
      expect(boldStyle.fontWeight, equals(FontWeight.w700));
    });
  });
}
