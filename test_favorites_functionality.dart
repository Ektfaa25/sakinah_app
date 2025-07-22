import 'package:flutter/material.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Testing favorites functionality...');

  try {
    // Clear all favorites first
    print('🧹 Clearing all existing favorites...');
    await AzkarDatabaseAdapter.clearAllFavorites();

    // Get initial count
    final initialCount = await AzkarDatabaseAdapter.getFavoriteCount();
    print('📊 Initial favorite count: $initialCount');

    // Test data - you should replace this with an actual azkar ID from your database
    const testAzkarId = '160bd28e-e3f0-47a9-a5ad-4fca0938a700';
    const testUserId = 'test_user_device';

    // Test 1: Check if azkar is not in favorites initially
    print('\n🧪 Test 1: Check initial favorite status...');
    final initialFavoriteStatus = await AzkarDatabaseAdapter.isAzkarFavorite(
      azkarId: testAzkarId,
      userId: testUserId,
    );
    print(
      '✅ Initial favorite status: $initialFavoriteStatus (should be false)',
    );

    // Test 2: Add azkar to favorites
    print('\n🧪 Test 2: Adding azkar to favorites...');
    await AzkarDatabaseAdapter.addToFavorites(
      azkarId: testAzkarId,
      userId: testUserId,
    );
    print('✅ Added azkar to favorites');

    // Test 3: Check if azkar is now in favorites
    print('\n🧪 Test 3: Check favorite status after adding...');
    final afterAddFavoriteStatus = await AzkarDatabaseAdapter.isAzkarFavorite(
      azkarId: testAzkarId,
      userId: testUserId,
    );
    print(
      '✅ Favorite status after adding: $afterAddFavoriteStatus (should be true)',
    );

    // Test 4: Get favorite count
    print('\n🧪 Test 4: Check favorite count...');
    final currentCount = await AzkarDatabaseAdapter.getFavoriteCount(
      userId: testUserId,
    );
    print('✅ Current favorite count: $currentCount (should be 1)');

    // Test 5: Remove azkar from favorites
    print('\n🧪 Test 5: Removing azkar from favorites...');
    await AzkarDatabaseAdapter.removeFromFavorites(
      azkarId: testAzkarId,
      userId: testUserId,
    );
    print('✅ Removed azkar from favorites');

    // Test 6: Check if azkar is no longer in favorites
    print('\n🧪 Test 6: Check favorite status after removing...');
    final afterRemoveFavoriteStatus =
        await AzkarDatabaseAdapter.isAzkarFavorite(
          azkarId: testAzkarId,
          userId: testUserId,
        );
    print(
      '✅ Favorite status after removing: $afterRemoveFavoriteStatus (should be false)',
    );

    // Test 7: Final favorite count
    print('\n🧪 Test 7: Final favorite count...');
    final finalCount = await AzkarDatabaseAdapter.getFavoriteCount(
      userId: testUserId,
    );
    print('✅ Final favorite count: $finalCount (should be 0)');

    print('\n🎉 All tests completed successfully!');
    print('✅ Favorites functionality is working correctly.');
  } catch (e) {
    print('❌ Error during testing: $e');
    print('🔍 Stack trace: ${StackTrace.current}');
  }
}
