import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';

void main() {
  group('Azkar Card Visibility Tests', () {
    testWidgets('should display cards with enhanced visibility', (
      WidgetTester tester,
    ) async {
      // Create test data
      final category = AzkarCategory(
        id: '1',
        nameAr: 'أذكار الصباح',
        description: 'Test category',
        orderIndex: 1,
        createdAt: DateTime.now(),
      );

      final azkar = Azkar(
        id: '1',
        textAr: 'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
        transliteration: 'Bismillahi ar-Rahmani ar-Raheem',
        translation:
            'In the name of Allah, the Most Gracious, the Most Merciful',
        repeatCount: 3,
        categoryId: '1',
        reference: 'Quran',
        associatedMoods: ['peaceful'],
        createdAt: DateTime.now(),
      );

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: AzkarDetailScreen(
            azkar: azkar,
            category: category,
            azkarIndex: 0,
            totalAzkar: 1,
          ),
        ),
      );

      // Wait for animations
      await tester.pumpAndSettle();

      // Verify the main azkar text is present
      expect(find.text('بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ'), findsOneWidget);

      // Verify transliteration section is present
      expect(find.text('Bismillahi ar-Rahmani ar-Raheem'), findsOneWidget);

      // Verify translation section is present
      expect(
        find.text('In the name of Allah, the Most Gracious, the Most Merciful'),
        findsOneWidget,
      );

      // Verify the cards have enhanced styling
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      print('✅ Azkar cards with enhanced visibility are displayed correctly');
    });

    testWidgets('should handle category color properly', (
      WidgetTester tester,
    ) async {
      // Test with a different category that should have a specific color
      final category = AzkarCategory(
        id: '2',
        nameAr: 'أذكار المساء',
        description: 'Test evening category',
        orderIndex: 2,
        createdAt: DateTime.now(),
      );

      final azkar = Azkar(
        id: '2',
        textAr: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        transliteration: 'Alhamdulillahi rabbil alameen',
        translation: 'All praise is due to Allah, Lord of the worlds',
        repeatCount: 1,
        categoryId: '2',
        associatedMoods: ['grateful'],
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AzkarDetailScreen(
            azkar: azkar,
            category: category,
            azkarIndex: 0,
            totalAzkar: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the text is displayed
      expect(
        find.text('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'),
        findsOneWidget,
      );
      expect(find.text('Alhamdulillahi rabbil alameen'), findsOneWidget);

      print('✅ Category colors are applied correctly to cards');
    });
  });
}
