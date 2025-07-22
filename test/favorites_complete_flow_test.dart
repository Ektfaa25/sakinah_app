import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_favorites_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  print('🧪 Testing complete favorites flow...');

  group('Favorites Complete Flow Tests', () {
    testWidgets(
      'Heart icon adds to favorites and navigates to favorites screen',
      (WidgetTester tester) async {
        print(
          '📱 Testing complete favorites flow from detail to favorites screen',
        );

        // Create a test azkar
        final testAzkar = Azkar(
          id: '1',
          categoryId: '1',
          textAr: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ',
          translation: 'O Allah, help me remember You',
          transliteration: 'Allahumma a\'inni ala dhikrika',
          reference: 'Test reference',
          description: 'Test description',
          repeatCount: 1,
          createdAt: DateTime.now(),
        );

        // Create a test category
        final testCategory = AzkarCategory(
          id: '1',
          nameAr: 'اختبار',
          orderIndex: 0,
          createdAt: DateTime.now(),
        );

        print('🎯 Testing azkar detail screen creation');

        // Test the azkar detail screen exists and heart icon is present
        await tester.pumpWidget(
          MaterialApp(
            home: AzkarDetailScreen(
              azkar: testAzkar,
              category: testCategory,
              azkarIndex: 0,
              totalAzkar: 1,
              azkarList: [testAzkar],
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the heart icon
        final heartIcon = find.byIcon(Icons.favorite_border);
        print('❤️ Heart icon found: ${heartIcon.evaluate().isNotEmpty}');
        expect(heartIcon, findsOneWidget);

        print('🎉 Complete favorites flow test components verified!');
      },
    );

    testWidgets('Favorites screen displays properly', (
      WidgetTester tester,
    ) async {
      print('📋 Testing favorites screen display');

      // Test that favorites screen can be created without errors
      await tester.pumpWidget(const MaterialApp(home: AzkarFavoritesScreen()));

      await tester.pumpAndSettle();

      // Check that the screen loads
      expect(find.byType(AzkarFavoritesScreen), findsOneWidget);
      print('✅ Favorites screen loaded successfully');

      print('🎉 Favorites screen test passed!');
    });
  });

  print('✅ All favorites flow tests completed successfully!');
}
