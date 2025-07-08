import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Azkar Categories Integration Test', () {
    setUpAll(() async {
      // Initialize Supabase for testing
      await Supabase.initialize(
        url: 'https://fjkihvlxpxhfvjnqqadd.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqa2lodnhweGhmdmpucXFhZGQiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTczNjc3NjI1MiwiZXhwIjoyMDUyMzUyMjUyfQ.YZJrUGgHWP8OgYkWG1kKgGKaFGhHiH3MxJmqEZzJdgM',
      );
    });

    test('should connect to database successfully', () async {
      final result = await AzkarDatabaseAdapter.testConnection();
      expect(result, true);
    });

    test('should fetch azkar categories derived from azkar table', () async {
      final categories = await AzkarDatabaseAdapter.getAzkarCategories();

      // Verify that we get categories
      expect(categories.length, greaterThan(0));

      // Verify that the categories have the expected structure
      for (final category in categories) {
        expect(category.id, isA<String>());
        expect(category.nameAr, isA<String>());
        expect(
          category.nameEn,
          isNull,
        ); // English name is no longer in database
        expect(category.isActive, true);
        if (category.description != null) {
          expect(category.description, contains('أذكار'));
        }
      }

      // Print categories for debugging
      print('📋 Found ${categories.length} categories:');
      for (final category in categories) {
        print(
          '   - ${category.id}: ${category.nameAr} - ${category.description ?? "No description"}',
        );
      }
    });

    test('should fetch azkar by category', () async {
      try {
        // First get categories to test with real data
        final categories = await AzkarDatabaseAdapter.getAzkarCategories();
        expect(categories.length, greaterThan(0));

        // Test fetching azkar for the first category
        final firstCategory = categories.first;
        final azkar = await AzkarDatabaseAdapter.getAzkarByCategory(
          firstCategory.id,
        );

        print(
          '📖 Found ${azkar.length} azkar for category: ${firstCategory.nameAr}',
        );

        // Verify that we get azkar
        expect(azkar, isA<List>());
        expect(azkar.length, greaterThan(0));

        // Verify azkar structure
        for (final azkarItem in azkar) {
          expect(azkarItem.id, isA<String>());
          expect(azkarItem.textAr, isA<String>());
          expect(azkarItem.categoryId, equals(firstCategory.id));
        }

        print('   Sample azkar: ${azkar.first.textAr.substring(0, 50)}...');
      } catch (e) {
        print('⚠️  Error fetching azkar by category: $e');
        fail('Should be able to fetch azkar by category');
      }
    });

    test('should get health check information', () async {
      final healthCheck = await AzkarDatabaseAdapter.getHealthCheck();

      expect(healthCheck, isA<Map<String, dynamic>>());
      expect(healthCheck['status'], isA<String>());
      expect(healthCheck['timestamp'], isA<String>());

      print('🏥 Health check: ${healthCheck['status']}');
      if (healthCheck['status'] == 'healthy') {
        print('   - Categories count: ${healthCheck['categories_count']}');
        print('   - Azkar count: ${healthCheck['azkar_count']}');
      }
    });
  });
}
