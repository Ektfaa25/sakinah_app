import 'dart:io';
import 'package:sakinah_app/core/network/supabase_service.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';

void main() async {
  print('🧪 Testing Favorites Functionality');

  try {
    // Initialize Supabase
    print('🔧 Initializing Supabase...');
    await SupabaseService.initialize();
    print('✅ Supabase initialized');

    // Test basic connection
    print('\n🔍 Testing database connection...');
    final connected = await AzkarDatabaseAdapter.testConnection();
    print('📡 Connection: $connected');

    if (!connected) {
      print('❌ Cannot connect to database');
      exit(1);
    }

    // Get categories
    print('\n📂 Fetching categories...');
    final categories = await AzkarDatabaseAdapter.getAzkarCategories();
    print('📂 Found ${categories.length} categories');

    if (categories.isEmpty) {
      print('❌ No categories found');
      exit(1);
    }

    // Get first azkar from first category
    final firstCategory = categories.first;
    print('📋 Using category: ${firstCategory.nameAr}');

    final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
      firstCategory.id,
    );
    print('📄 Found ${azkarList.length} azkar in category');

    if (azkarList.isEmpty) {
      print('❌ No azkar found in category');
      exit(1);
    }

    final firstAzkar = azkarList.first;
    print('📝 Selected azkar: ${firstAzkar.id}');
    print('📝 Text: ${firstAzkar.textAr.substring(0, 50)}...');

    // Clear existing favorites
    print('\n🧹 Clearing existing favorites...');
    await AzkarDatabaseAdapter.clearAllFavorites();

    // Check current favorites
    print('\n🔍 Getting current favorites...');
    final currentFavorites = await AzkarDatabaseAdapter.getFavoriteAzkar();
    print('💖 Current favorites: ${currentFavorites.length}');

    // Add to favorites
    print('\n💖 Adding azkar to favorites...');
    await AzkarDatabaseAdapter.addToFavorites(azkarId: firstAzkar.id);
    print('✅ Added to favorites');

    // Check if it's favorite
    print('\n🔍 Checking if azkar is favorite...');
    final isFavorite = await AzkarDatabaseAdapter.isAzkarFavorite(
      azkarId: firstAzkar.id,
    );
    print('💖 Is favorite: $isFavorite');

    // Get favorites
    print('\n📋 Getting all favorites...');
    final favorites = await AzkarDatabaseAdapter.getFavoriteAzkar();
    print('📋 Total favorites: ${favorites.length}');

    if (favorites.isNotEmpty) {
      print('✅ SUCCESS: Favorites are working!');
      for (int i = 0; i < favorites.length; i++) {
        final favorite = favorites[i];
        print('   ${i + 1}. ID: ${favorite.id}');
        print('      Text: ${favorite.textAr.substring(0, 50)}...');
        print('      Category: ${favorite.categoryId}');
      }
    } else {
      print('❌ FAILED: No favorites found after adding');
    }

    // Get favorite count
    final count = await AzkarDatabaseAdapter.getFavoriteCount();
    print('\n📊 Favorite count: $count');

    print('\n🎉 Test completed successfully!');
  } catch (e, stack) {
    print('❌ Error: $e');
    print('Stack: $stack');
    exit(1);
  }
}
