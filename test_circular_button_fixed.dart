import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  testWidgets('Circular button shows initial state and builds correctly', (
    WidgetTester tester,
  ) async {
    // Create test data
    final testAzkar = Azkar(
      id: '1',
      categoryId: '1',
      textAr: 'تست',
      textEn: 'Test',
      transliteration: 'Test',
      translation: 'Test translation',
      reference: 'Test reference',
      description: 'Test description',
      repeatCount: 3,
      orderIndex: 1,
      associatedMoods: ['general'],
      searchTags: 'test',
      isActive: true,
      createdAt: DateTime.now(),
    );

    final testCategory = AzkarCategory(
      id: '1',
      nameAr: 'فئة الاختبار',
      nameEn: 'Test Category',
      description: 'Test description',
      icon: 'test_icon',
      color: '#FF8A65',
      orderIndex: 1,
      isActive: true,
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

    // Wait for the widget to be built
    await tester.pumpAndSettle();

    // Verify initial state - the circular button should display initial count
    expect(find.text('0'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('اضغط للعد'), findsOneWidget);

    // Verify the circular progress indicator and other UI elements exist
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
    expect(find.text('التقدم في الذكر'), findsOneWidget);
  });
}
