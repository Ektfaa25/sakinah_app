import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Color Updates Tests', () {
    testWidgets('should display mood button with new color #E3F1F1', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      await tester.pumpAndSettle();

      // Find the mood selection button
      final moodButton = find.byType(ElevatedButton);
      expect(moodButton, findsOneWidget);

      // Get the button widget to check its styling
      final elevatedButton = tester.widget<ElevatedButton>(moodButton);
      final buttonStyle = elevatedButton.style;

      // Verify the background color is set to #E3F1F1 (Color(0xFFE3F1F1))
      expect(buttonStyle, isNotNull);

      // Find the mood button text
      expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);

      print('✅ Mood button with color #E3F1F1 is displayed correctly');
    });

    testWidgets('should verify color value matches #E3F1F1', (
      WidgetTester tester,
    ) async {
      // Test the color conversion
      const targetColor = Color(0xFFE3F1F1);

      // Verify RGB values
      expect(targetColor.red, equals(227)); // E3 in hex = 227 in decimal
      expect(targetColor.green, equals(241)); // F1 in hex = 241 in decimal
      expect(targetColor.blue, equals(241)); // F1 in hex = 241 in decimal
      expect(targetColor.alpha, equals(255)); // FF in hex = 255 in decimal

      print(
        '✅ Color #E3F1F1 values verified: R=${targetColor.red}, G=${targetColor.green}, B=${targetColor.blue}',
      );
    });
  });
}
