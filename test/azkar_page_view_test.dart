import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_category_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  group('AzkarCategoryScreen Page View Tests', () {
    late AzkarCategory testCategory;

    setUp(() {
      testCategory = AzkarCategory(
        id: '1',
        nameAr: 'أذكار الصباح',
        nameEn: 'Morning Azkar',
        description: 'أذكار تُقال في الصباح',
        icon: 'wb_sunny',
        color: '#FFD700',
        orderIndex: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    testWidgets('AzkarCategoryScreen should display page view structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: AzkarCategoryScreen(category: testCategory)),
      );

      // Wait for the loading to complete
      await tester.pumpAndSettle();

      // Check if the screen renders without crashing
      expect(find.byType(AzkarCategoryScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      // Check if the header is displayed
      expect(find.text('أذكار الصباح'), findsOneWidget);

      // Navigation buttons have been removed as requested
    });

    testWidgets('Page view should handle empty state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: AzkarCategoryScreen(category: testCategory)),
      );

      // Wait for the loading to complete
      await tester.pumpAndSettle();

      // Should show empty state since no azkar are loaded
      expect(find.text('لا توجد أذكار في هذه الفئة'), findsOneWidget);
    });

    testWidgets('Page indicator should show correct format', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: AzkarCategoryScreen(category: testCategory)),
      );

      // Wait for the loading to complete
      await tester.pumpAndSettle();

      // Check if page indicator shows correct format for empty state
      expect(find.text('لا توجد أذكار'), findsOneWidget);
    });
  });
}
