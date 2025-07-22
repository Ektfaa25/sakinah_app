// Simple test to check favorites functionality
// Run with: flutter test test_favorites_simple.dart

import 'package:flutter_test/flutter_test.dart';
import '../lib/core/network/supabase_service.dart';
import '../lib/features/azkar/data/services/azkar_database_adapter.dart';

void main() {
  group('Favorites Database Test', () {
    setUpAll(() async {
      await SupabaseService.initialize();
    });

    test('Should be able to connect to database', () async {
      final client = SupabaseService.instance.client;
      expect(client, isNotNull);
      print('✅ Database client initialized');
    });

    test('Should be able to access user_favorites table', () async {
      final client = SupabaseService.instance.client;

      try {
        final response = await client
            .from('user_favorites')
            .select('count')
            .limit(1);
        print('✅ user_favorites table accessible');
        print('📊 Response: $response');
      } catch (e) {
        print('❌ Error accessing user_favorites: $e');
        fail('Cannot access user_favorites table: $e');
      }
    });

    test('Should be able to access azkar table', () async {
      final client = SupabaseService.instance.client;

      try {
        final response = await client
            .from('azkar')
            .select('id, text_ar')
            .limit(3);
        print('✅ azkar table accessible');
        print('📊 Found ${(response as List).length} azkar');

        expect(response, isList);
        expect((response as List).isNotEmpty, true);
      } catch (e) {
        print('❌ Error accessing azkar: $e');
        fail('Cannot access azkar table: $e');
      }
    });

    test('Should be able to add and retrieve favorites', () async {
      final client = SupabaseService.instance.client;

      // Get a test azkar
      final azkarResponse = await client.from('azkar').select('id').limit(1);

      expect((azkarResponse as List).isNotEmpty, true);
      final testAzkarId = azkarResponse.first['id'] as String;

      print('🎯 Using test azkar ID: $testAzkarId');

      // Clean up any existing favorites first
      await client
          .from('user_favorites')
          .delete()
          .eq('user_id', 'local_device_user')
          .eq('azkar_id', testAzkarId);

      // Add to favorites
      await AzkarDatabaseAdapter.addToFavorites(azkarId: testAzkarId);
      print('💗 Added to favorites');

      // Check if it's favorite
      final isFavorite = await AzkarDatabaseAdapter.isAzkarFavorite(
        azkarId: testAzkarId,
      );
      expect(isFavorite, true);
      print('💖 Confirmed as favorite: $isFavorite');

      // Get favorites
      final favorites = await AzkarDatabaseAdapter.getFavoriteAzkar();
      expect(favorites.isNotEmpty, true);
      expect(favorites.any((azkar) => azkar.id == testAzkarId), true);
      print('💝 Retrieved ${favorites.length} favorites');

      // Clean up
      await AzkarDatabaseAdapter.removeFromFavorites(azkarId: testAzkarId);
      print('🧹 Cleaned up test data');
    });

    test('Should handle empty favorites gracefully', () async {
      // Clear all favorites for test user
      final client = SupabaseService.instance.client;
      await client
          .from('user_favorites')
          .delete()
          .eq('user_id', 'local_device_user');

      final favorites = await AzkarDatabaseAdapter.getFavoriteAzkar();
      expect(favorites, isA<List>());
      expect(favorites.isEmpty, true);
      print('💫 Empty favorites handled correctly');
    });
  });
}
