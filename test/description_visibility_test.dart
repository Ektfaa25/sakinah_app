import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  group('Description Visibility Tests', () {
    testWidgets('Azkar description text is visible with proper color', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing azkar description text visibility');

      // Create test azkar with translation (description)
      final testAzkar = Azkar(
        id: 'test_azkar',
        categoryId: 'morning',
        textAr: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        translation:
            'ذكر طيب.', // This is the description that should be visible
        repeatCount: 1,
        reference: null,
        createdAt: DateTime.now(),
      );

      final testCategory = AzkarCategory(
        id: 'morning',
        nameAr: 'أذكار الصباح',
        nameEn: 'Morning Azkar',
        description: 'Morning remembrance',
        icon: 'morning',
        color: '#FF9800',
        orderIndex: 1,
        isActive: true,
        createdAt: DateTime.now(),
      );

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

      print('✅ Azkar detail screen loaded successfully');

      // Find the translation text
      final translationFinder = find.text('ذكر طيب.');
      expect(
        translationFinder,
        findsOneWidget,
        reason: 'Translation text should be found',
      );
      print('✅ Translation text found');

      // Get the Text widget to check its style
      final textWidget = tester.widget<Text>(translationFinder);
      expect(
        textWidget.style?.color,
        equals(Colors.black87),
        reason: 'Translation text should use Colors.black87 for visibility',
      );
      print('✅ Translation text uses Colors.black87');

      print('🎉 All description visibility tests passed!');
    });
  });
}
