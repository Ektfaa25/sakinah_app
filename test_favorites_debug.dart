import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';

void main() async {
  print('🧪 Testing favorites database functionality...');

  try {
    // Test connection first
    print('🔍 Testing database connection...');
    final connected = await AzkarDatabaseAdapter.testConnection();
    print('📡 Connection result: $connected');

    if (!connected) {
      print('❌ Database connection failed');
      return;
    }

    // Test fetching a regular azkar to see the structure
    print('\n🔍 Testing regular azkar fetch...');
    final categories = await AzkarDatabaseAdapter.getAzkarCategories();
    print('📂 Found ${categories.length} categories');

    if (categories.isNotEmpty) {
      final firstCategory = categories.first;
      print('📂 First category: ${firstCategory.id} - ${firstCategory.nameAr}');

      final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
        firstCategory.id,
      );
      print('📖 Found ${azkarList.length} azkar in first category');

      if (azkarList.isNotEmpty) {
        final firstAzkar = azkarList.first;
        print('📖 First azkar structure:');
        print('   ID: ${firstAzkar.id}');
        print('   Category ID: ${firstAzkar.categoryId}');
        print('   Text AR: ${firstAzkar.textAr.substring(0, 50)}...');
        print('   Created: ${firstAzkar.createdAt}');

        // Test adding to favorites
        print('\n🔍 Testing add to favorites...');
        await AzkarDatabaseAdapter.addToFavorites(azkarId: firstAzkar.id);
        print('✅ Added to favorites');

        // Test fetching favorites
        print('\n🔍 Testing fetch favorites...');
        final favorites = await AzkarDatabaseAdapter.getFavoriteAzkar();
        print('💖 Found ${favorites.length} favorite azkar');

        for (int i = 0; i < favorites.length; i++) {
          final fav = favorites[i];
          print('💖 Favorite $i:');
          print('   ID: ${fav.id}');
          print('   Text: ${fav.textAr.substring(0, 30)}...');
        }
      }
    }
  } catch (e, stackTrace) {
    print('❌ Error during testing: $e');
    print('❌ Stack trace: $stackTrace');
  }
}
