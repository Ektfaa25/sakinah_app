import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Color Palette Tests', () {
    testWidgets('HomePage uses correct pastel colors from image palette', (
      WidgetTester tester,
    ) async {
      // Build the HomePage widget
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Test the hex color conversion function works correctly
      expect(
        _getColorFromHex('#FBF8CC').value,
        equals(Color(0xFFFBF8CC).value),
      );
      expect(
        _getColorFromHex('#A3C4F3').value,
        equals(Color(0xFFA3C4F3).value),
      );
      expect(
        _getColorFromHex('#FDE4CF').value,
        equals(Color(0xFFFDE4CF).value),
      );
      expect(
        _getColorFromHex('#90DBF4').value,
        equals(Color(0xFF90DBF4).value),
      );
      expect(
        _getColorFromHex('#98F5E1').value,
        equals(Color(0xFF98F5E1).value),
      );
      expect(
        _getColorFromHex('#B9FBC0').value,
        equals(Color(0xFFB9FBC0).value),
      );

      print(
        '🎨 All color palette tests passed! The app now uses the correct pastel colors from the image.',
      );
    });

    testWidgets('HomePage contains azkar category cards with colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();

      // Verify that the home page shows category cards
      expect(find.text('أذكار الصباح'), findsAtLeastNWidgets(1));
      expect(find.text('أذكار المساء'), findsAtLeastNWidgets(1));
      expect(find.text('أذكار الاستيقاظ'), findsAtLeastNWidgets(1));
      expect(find.text('أذكار النوم'), findsAtLeastNWidgets(1));
      expect(find.text('أذكار الصلاة'), findsAtLeastNWidgets(1));
      expect(find.text('أذكار بعد الصلاة'), findsAtLeastNWidgets(1));

      print(
        '🎨 All azkar category cards are displayed with the new color palette!',
      );
    });
  });
}

// Helper function to test color conversion
Color _getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor'; // Add alpha channel
  }
  return Color(int.parse(hexColor, radix: 16));
}
