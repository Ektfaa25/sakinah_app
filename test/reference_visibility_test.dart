import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  group('Reference Visibility Tests', () {
    testWidgets('Azkar reference text is visible with proper color', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing azkar reference text visibility');

      // Create test azkar with reference
      final testAzkar = Azkar(
        id: 'test_azkar',
        categoryId: 'morning',
        textAr: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
        translation: 'ذكر طيب.',
        repeatCount: 1,
        reference: 'البخاري', // This is the reference that should be visible
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

      // Find the reference text (with "المصدر: " prefix)
      final referenceFinder = find.text('المصدر: البخاري');
      expect(
        referenceFinder,
        findsOneWidget,
        reason: 'Reference text should be found',
      );
      print('✅ Reference text found');

      // Get the Text widget to check its style
      final textWidget = tester.widget<Text>(referenceFinder);
      expect(
        textWidget.style?.color,
        equals(Colors.black87),
        reason: 'Reference text should use Colors.black87 for visibility',
      );
      print('✅ Reference text uses Colors.black87');

      print('🎉 All reference visibility tests passed!');
    });
  });
}
