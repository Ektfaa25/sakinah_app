import 'package:flutter/material.dart';
import 'lib/core/network/supabase_service.dart';
import 'lib/features/azkar/data/services/azkar_database_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase
    print('🔧 Initializing Supabase...');
    await SupabaseService.initialize();
    print('✅ Supabase initialized successfully');

    // Test database connection
    print('\n📡 Testing database connection...');
    final client = SupabaseService.instance.client;

    // Test 1: Check if user_favorites table exists
    print('\n🔍 Testing user_favorites table...');
    try {
      final favoritesTest = await client
          .from('user_favorites')
          .select('count')
          .limit(1);
      print('✅ user_favorites table is accessible');
      print('📊 Test query result: $favoritesTest');
    } catch (e) {
      print('❌ Error accessing user_favorites table: $e');
    }

    // Test 2: Check azkar table
    print('\n🔍 Testing azkar table...');
    try {
      final azkarTest = await client
          .from('azkar')
          .select('id, zkr_text')
          .limit(3);
      print('✅ azkar table is accessible');
      print('📊 Found ${(azkarTest as List).length} azkar samples');

      // Get first azkar for testing
      if ((azkarTest as List).isNotEmpty) {
        final firstAzkar = azkarTest.first;
        final azkarId = firstAzkar['id'];
        print('🎯 Using azkar ID for testing: $azkarId');

        // Test 3: Add to favorites
        print('\n💗 Testing addToFavorites...');
        await AzkarDatabaseAdapter.addToFavorites(azkarId: azkarId);

        // Test 4: Check if favorite
        print('\n🔍 Testing isAzkarFavorite...');
        final isFavorite = await AzkarDatabaseAdapter.isAzkarFavorite(
          azkarId: azkarId,
        );
        print('💖 Is favorite: $isFavorite');

        // Test 5: Get favorites
        print('\n📋 Testing getFavoriteAzkar...');
        final favorites = await AzkarDatabaseAdapter.getFavoriteAzkar();
        print('💝 Found ${favorites.length} favorite azkar');

        for (final fav in favorites) {
          print('  - ${fav.id}: ${fav.textAr.substring(0, 50)}...');
        }

        // Test 6: Check raw favorites table
        print('\n🔍 Checking raw user_favorites table...');
        final rawFavorites = await client
            .from('user_favorites')
            .select('*')
            .eq('user_id', 'local_device_user');
        print('📊 Raw favorites: $rawFavorites');
      } else {
        print('❌ No azkar found in database');
      }
    } catch (e) {
      print('❌ Error accessing azkar table: $e');
    }
  } catch (e) {
    print('❌ Fatal error: $e');
  }
}
