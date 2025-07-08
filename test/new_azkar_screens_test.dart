import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_categories_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_category_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';

void main() {
  group('New Azkar Screens Tests', () {
    testWidgets('AzkarScreen should build without errors', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AzkarScreen()));

      expect(find.byType(AzkarScreen), findsOneWidget);
    });

    testWidgets('AzkarCategoryScreen should build with test data', (
      tester,
    ) async {
      final testCategory = AzkarCategory(
        id: 'test',
        nameAr: 'اختبار',
        nameEn: 'Test',
        description: 'Test category',
        icon: '🧪',
        orderIndex: 1,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(home: AzkarCategoryScreen(category: testCategory)),
      );

      expect(find.byType(AzkarCategoryScreen), findsOneWidget);
    });

    testWidgets('AzkarDetailScreen should build with test data', (
      tester,
    ) async {
      final testCategory = AzkarCategory(
        id: 'test',
        nameAr: 'اختبار',
        nameEn: 'Test',
        description: 'Test category',
        icon: '🧪',
        orderIndex: 1,
        createdAt: DateTime.now(),
      );

      final testAzkar = Azkar(
        id: 'test-azkar',
        categoryId: 'test',
        textAr: 'الحمد لله',
        transliteration: 'Alhamdulillah',
        translation: 'All praise is for Allah',
        repeatCount: 1,
        orderIndex: 1,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AzkarDetailScreen(
            azkar: testAzkar,
            category: testCategory,
            azkarIndex: 1,
            totalAzkar: 1,
          ),
        ),
      );

      expect(find.byType(AzkarDetailScreen), findsOneWidget);
    });
  });

  group('Azkar Models Tests', () {
    test('AzkarCategory should create from JSON', () {
      final json = {
        'id': 'test',
        'name_ar': 'اختبار',
        'name_en': 'Test',
        'description': 'Test category',
        'icon': '🧪',
        'order_index': 1,
        'is_active': true,
        'created_at': '2023-01-01T00:00:00.000Z',
      };

      final category = AzkarCategory.fromJson(json);

      expect(category.id, 'test');
      expect(category.nameAr, 'اختبار');
      expect(category.nameEn, 'Test');
      expect(category.description, 'Test category');
      expect(category.icon, '🧪');
      expect(category.orderIndex, 1);
      expect(category.isActive, true);
    });

    test('Azkar should create from JSON', () {
      final json = {
        'id': 'test-azkar',
        'category_id': 'test',
        'text_ar': 'الحمد لله',
        'transliteration': 'Alhamdulillah',
        'translation': 'All praise is for Allah',
        'repeat_count': 1,
        'order_index': 1,
        'is_active': true,
        'created_at': '2023-01-01T00:00:00.000Z',
      };

      final azkar = Azkar.fromJson(json);

      expect(azkar.id, 'test-azkar');
      expect(azkar.categoryId, 'test');
      expect(azkar.textAr, 'الحمد لله');
      expect(azkar.transliteration, 'Alhamdulillah');
      expect(azkar.translation, 'All praise is for Allah');
      expect(azkar.repeatCount, 1);
      expect(azkar.orderIndex, 1);
      expect(azkar.isActive, true);
    });

    test('UserAzkarProgress should create from JSON', () {
      final json = {
        'id': 'test-progress',
        'user_id': 'test-user',
        'azkar_id': 'test-azkar',
        'completed_count': 5,
        'total_count': 10,
        'last_completed_at': '2023-01-01T00:00:00.000Z',
        'created_at': '2023-01-01T00:00:00.000Z',
      };

      final progress = UserAzkarProgress.fromJson(json);

      expect(progress.id, 'test-progress');
      expect(progress.userId, 'test-user');
      expect(progress.azkarId, 'test-azkar');
      expect(progress.completedCount, 5);
      expect(progress.totalCount, 10);
      expect(progress.isCompleted, false);
    });
  });
}
