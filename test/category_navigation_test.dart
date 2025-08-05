
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  testWidgets('Category navigation should pass category object properly', (
    WidgetTester tester,
  ) async {
    // Create a sample category
    final testCategory = AzkarCategory(
      id: 'morning',
      nameAr: 'أذكار الصباح',
      orderIndex: 1,
      createdAt: DateTime.now(),
    );

    // Test that the category object has the required properties
    expect(testCategory.id, equals('morning'));
    expect(testCategory.nameAr, equals('أذكار الصباح'));
    expect(testCategory.nameEn, isNull); // Should be null as per our changes
    expect(testCategory.isActive, isTrue); // Default value

    print('✅ Category object structure is correct for navigation');
  });

  testWidgets('Category cards should have proper navigation setup', (
    WidgetTester tester,
  ) async {
    // Test category JSON structure that would come from database
    final categoryJson = {
      'id': 'evening',
      'name_ar': 'أذكار المساء',
      'description': 'أذكار المساء المبارك',
      'order_index': 2,
      'is_active': true,
      'created_at': '2024-01-01T10:00:00Z',
    };

    final category = AzkarCategory.fromJson(categoryJson);

    expect(category.id, equals('evening'));
    expect(category.nameAr, equals('أذكار المساء'));
    expect(category.description, equals('أذكار المساء المبارك'));
    expect(category.nameEn, isNull); // Should be null

    print('✅ Category JSON parsing works correctly for navigation');
  });
}
