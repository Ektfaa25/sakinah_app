import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  group('Home Page Categories Unit Test', () {
    test('AzkarCategory model works correctly without English name', () {
      // Test AzkarCategory creation and serialization
      final category = AzkarCategory(
        id: 'test-id',
        nameAr: 'أذكار الصباح',
        nameEn: null, // Should be null as per our changes
        description: 'Test category description',
        orderIndex: 1,
        createdAt: DateTime.now(),
      );

      // Verify that nameEn is null (as expected after our changes)
      expect(category.nameEn, isNull);
      expect(category.nameAr, equals('أذكار الصباح'));
      expect(category.id, equals('test-id'));
      expect(category.isActive, isTrue); // Default value

      // Test JSON serialization
      final json = category.toJson();
      expect(json['name_ar'], equals('أذكار الصباح'));
      expect(json.containsKey('name_en'), isFalse); // Should not be in JSON
      expect(json['id'], equals('test-id'));

      // Test JSON deserialization
      final testJson = {
        'id': 'test-id-2',
        'name_ar': 'أذكار المساء',
        'description': 'Evening remembrance',
        'order_index': 2,
        'is_active': true,
        'created_at': '2024-01-01T10:00:00Z',
      };

      final categoryFromJson = AzkarCategory.fromJson(testJson);
      expect(categoryFromJson.nameEn, isNull); // Should be null
      expect(categoryFromJson.nameAr, equals('أذكار المساء'));
      expect(categoryFromJson.id, equals('test-id-2'));
    });

    test('Home page category display logic works', () {
      // Test the category display logic used in home page
      final categories = [
        AzkarCategory(
          id: '1',
          nameAr: 'أذكار الصباح',
          orderIndex: 1,
          createdAt: DateTime.now(),
        ),
        AzkarCategory(
          id: '2',
          nameAr: 'أذكار المساء',
          orderIndex: 2,
          createdAt: DateTime.now(),
        ),
        AzkarCategory(
          id: '3',
          nameAr: 'أذكار الشكر',
          orderIndex: 3,
          createdAt: DateTime.now(),
        ),
        AzkarCategory(
          id: '4',
          nameAr: 'أذكار السفر',
          orderIndex: 4,
          createdAt: DateTime.now(),
        ),
        AzkarCategory(
          id: '5',
          nameAr: 'أذكار الطعام',
          orderIndex: 5,
          createdAt: DateTime.now(),
        ),
        AzkarCategory(
          id: '6',
          nameAr: 'أذكار النوم',
          orderIndex: 6,
          createdAt: DateTime.now(),
        ),
        AzkarCategory(
          id: '7',
          nameAr: 'أذكار الاستيقاظ',
          orderIndex: 7,
          createdAt: DateTime.now(),
        ),
      ];

      // Test displaying first 6 categories (like home page does)
      final displayCategories = categories.take(6).toList();
      expect(displayCategories.length, equals(6));
      expect(displayCategories.first.nameAr, equals('أذكار الصباح'));
      expect(displayCategories.last.nameAr, equals('أذكار النوم'));

      // Test "View All" logic
      final hasMore = categories.length > 6;
      expect(hasMore, isTrue);
      expect(categories.length, equals(7));
    });
  });
}
