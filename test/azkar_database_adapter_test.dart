import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/core/network/supabase_service.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() {
  group('AzkarDatabaseAdapter Tests', () {
    setUpAll(() async {
      // Initialize Supabase before running tests
      await SupabaseService.initialize();
    });

    test('should create adapter instance', () {
      expect(AzkarDatabaseAdapter, isNotNull);
    });

    test('should fetch categories from Supabase', () async {
      try {
        final categories = await AzkarDatabaseAdapter.getAzkarCategories();
        print('Fetched ${categories.length} categories:');
        for (final category in categories) {
          print(
            '- ${category.id}: ${category.nameAr} (${category.nameEn ?? 'N/A'})',
          );
        }

        expect(categories, isA<List<AzkarCategory>>());
        expect(categories.isNotEmpty, true);

        // Verify that categories have the expected structure
        for (final category in categories) {
          expect(category.id, isNotNull);
          expect(category.nameAr, isNotNull);
        }
      } catch (e) {
        print('Error fetching categories: $e');
        fail('Failed to fetch categories: $e');
      }
    });

    test('should fetch azkar by category', () async {
      try {
        // First get categories to get a valid category ID
        final categories = await AzkarDatabaseAdapter.getAzkarCategories();
        expect(categories.isNotEmpty, true);

        final categoryId = categories.first.id;
        print('Testing with category ID: $categoryId');

        final azkar = await AzkarDatabaseAdapter.getAzkarByCategory(categoryId);
        print('Fetched ${azkar.length} azkar for category $categoryId');

        expect(azkar, isA<List<Azkar>>());

        // Print some azkar details for debugging
        for (int i = 0; i < azkar.length && i < 3; i++) {
          final azkarItem = azkar[i];
          print('- ${azkarItem.id}: ${azkarItem.textAr.substring(0, 50)}...');
        }
      } catch (e) {
        print('Error fetching azkar: $e');
        fail('Failed to fetch azkar: $e');
      }
    });

    test('should handle health check', () async {
      try {
        final health = await AzkarDatabaseAdapter.getHealthCheck();
        print('Health check result: $health');

        expect(health, isA<Map<String, dynamic>>());
        expect(health['status'], isNotNull);
        expect(health['timestamp'], isNotNull);
      } catch (e) {
        print('Error in health check: $e');
        fail('Health check failed: $e');
      }
    });
  });
}
