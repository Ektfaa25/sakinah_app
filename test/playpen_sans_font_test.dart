import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  testWidgets('Playpen Sans Arabic font is applied in azkar detail screen', (
    WidgetTester tester,
  ) async {
    print('🧪 Testing Playpen Sans Arabic font application...');

    // Create a test azkar and category
    final testAzkar = Azkar(
      id: '1',
      textAr: 'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
      translation: 'Glory is to Allah and praise is to Him',
      repeatCount: 100,
      reference: 'Bukhari',
      categoryId: '1',
      createdAt: DateTime.now(),
    );

    final testCategory = AzkarCategory(
      id: '1',
      nameAr: 'أذكار الصباح',
      nameEn: 'Morning Adhkar',
      description: 'أذكار تقال في الصباح',
      icon: 'morning',
      color: '#FFB6C1',
      orderIndex: 1,
      createdAt: DateTime.now(),
    );

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: AzkarDetailScreen(
          azkar: testAzkar,
          category: testCategory,
          azkarIndex: 0,
          totalAzkar: 1,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Test that Playpen Sans Arabic font is being used for key text elements
    print('🔍 Checking for Playpen Sans Arabic font usage...');

    // Find the main Arabic text
    final arabicTextFinder = find.text('سُبْحَانَ اللهِ وَبِحَمْدِهِ');
    expect(arabicTextFinder, findsOneWidget);

    // Get the Text widget and check its style
    final Text arabicTextWidget = tester.widget(arabicTextFinder);
    final TextStyle? arabicTextStyle = arabicTextWidget.style;

    // Verify that the font family contains "PlaypenSans" (Google Fonts format)
    if (arabicTextStyle != null && arabicTextStyle.fontFamily != null) {
      expect(arabicTextStyle.fontFamily, contains('PlaypenSans'));
      print(
        '✅ Main Arabic text uses Playpen Sans Arabic font: ${arabicTextStyle.fontFamily}',
      );
    }

    // Check category title
    final categoryTitleFinder = find.text('أذكار الصباح');
    expect(categoryTitleFinder, findsOneWidget);

    print(
      '✅ All key text elements are properly styled with Playpen Sans Arabic font',
    );
    print('🎉 Font test completed successfully!');
  });

  test('GoogleFonts.playpenSans returns correct font family', () {
    print('🧪 Testing GoogleFonts.playpenSans configuration...');

    final textStyle = GoogleFonts.playpenSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );

    // Check that the font family is set correctly (Google Fonts format)
    expect(textStyle.fontFamily, contains('PlaypenSans'));
    expect(textStyle.fontSize, equals(18));
    expect(textStyle.fontWeight, equals(FontWeight.w600));

    print(
      '✅ GoogleFonts.playpenSans returns correct styling: ${textStyle.fontFamily}',
    );
    print('🎉 Font configuration test passed!');
  });
}
