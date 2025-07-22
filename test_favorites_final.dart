import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
import 'package:sakinah_app/core/network/supabase_service.dart';

void main() {
  print('🧪 Testing favorites functionality with current schema');

  group('Favorites Functionality Tests', () {
    setUpAll(() async {
      print('🔧 Setting up Supabase connection...');
      // Initialize Supabase
      await SupabaseService.initialize();
    });

    test('should be able to fetch sample azkar and add to favorites', () async {
      print('📋 Testing favorites workflow...');

      try {
        // Fetch some azkar first
        print('🔍 Fetching azkar...');
        final categories = await AzkarDatabaseAdapter.getAzkarCategories();
        print('📂 Found ${categories.length} categories');
        expect(categories.isNotEmpty, true);

        if (categories.isNotEmpty) {
          final firstCategory = categories.first;
          print('📋 Using category: ${firstCategory.nameAr}');

          final azkarInCategory = await AzkarDatabaseAdapter.getAzkarByCategory(
            firstCategory.id,
          );
          print('📄 Found ${azkarInCategory.length} azkar in category');
          expect(azkarInCategory.isNotEmpty, true);

          if (azkarInCategory.isNotEmpty) {
            final firstAzkar = azkarInCategory.first;
            print(
              '📝 Using azkar: ${firstAzkar.id} - ${firstAzkar.textAr.substring(0, 50)}...',
            );

            // Clear any existing favorites
            print('🧹 Clearing existing favorites...');
            await AzkarDatabaseAdapter.clearAllFavorites();

            // Add to favorites
            print('💖 Adding azkar to favorites...');
            await AzkarDatabaseAdapter.addToFavorites(azkarId: firstAzkar.id);

            // Check if it's marked as favorite
            print('🔍 Checking if azkar is favorited...');
            final isFavorite = await AzkarDatabaseAdapter.isAzkarFavorite(
              azkarId: firstAzkar.id,
            );
            print('💖 Is favorite: $isFavorite');
            expect(isFavorite, true);

            // Get favorite count
            print('📊 Getting favorite count...');
            final favoriteCount = await AzkarDatabaseAdapter.getFavoriteCount();
            print('📊 Favorite count: $favoriteCount');
            expect(favoriteCount, 1);

            // Get favorite azkar
            print('📋 Getting favorite azkar...');
            final favoriteAzkar = await AzkarDatabaseAdapter.getFavoriteAzkar();
            print('📋 Found ${favoriteAzkar.length} favorite azkar');
            expect(favoriteAzkar.length, 1);
            expect(favoriteAzkar.first.id, firstAzkar.id);

            // Remove from favorites
            print('❌ Removing from favorites...');
            await AzkarDatabaseAdapter.removeFromFavorites(
              azkarId: firstAzkar.id,
            );

            // Check if it's no longer favorite
            print('🔍 Verifying removal...');
            final isStillFavorite = await AzkarDatabaseAdapter.isAzkarFavorite(
              azkarId: firstAzkar.id,
            );
            print('💔 Is still favorite: $isStillFavorite');
            expect(isStillFavorite, false);
          }
        }

        print('✅ All favorites tests passed!');
      } catch (e, stack) {
        print('❌ Error in favorites test: $e');
        print('Stack trace: $stack');
        fail('Test failed with error: $e');
      }
    });
  });
}
