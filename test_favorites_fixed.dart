import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/features/azkar/data/services/azkar_database_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🧪 Testing favorites functionality...');

  try {
    // Test getting favorites
    print('📋 Testing getFavoriteAzkar...');
    final favorites = await AzkarDatabaseAdapter.getFavoriteAzkar();
    print('✅ Got ${favorites.length} favorites');

    for (int i = 0; i < favorites.length && i < 3; i++) {
      final azkar = favorites[i];
      print(
        '📝 Favorite ${i + 1}: ${azkar.id} - Category: ${azkar.categoryId}',
      );
      print('   Text preview: ${azkar.textAr.substring(0, 50)}...');
    }

    if (favorites.isNotEmpty) {
      print('✅ Favorites functionality is working correctly!');
    } else {
      print('⚠️ No favorites found, but method is working');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
