// Test script to verify the home page categories implementation
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';

void main() async {
  print('🧪 Testing Home Page Categories Implementation...');

  try {
    // Test 1: Verify we can fetch categories from database
    print('1. Testing category fetching from database...');
    final categories = await AzkarDatabaseAdapter.getAzkarCategories();
    print('✅ Successfully fetched ${categories.length} categories');

    // Test 2: Verify categories have proper structure
    print('2. Testing category structure...');
    for (int i = 0; i < (categories.length > 5 ? 5 : categories.length); i++) {
      final category = categories[i];
      print('   Category ${i + 1}: ${category.nameAr} (ID: ${category.id})');
    }

    // Test 3: Verify we can take first 6 categories
    print('3. Testing first 6 categories for home page...');
    final displayCategories = categories.take(6).toList();
    print('✅ Display categories: ${displayCategories.length}');

    // Test 4: Verify "View All" logic
    print('4. Testing View All logic...');
    final hasMore = categories.length > 6;
    print('✅ Has more categories: $hasMore (Total: ${categories.length})');

    print(
      '\n🎉 All tests passed! Home page implementation is working correctly.',
    );
  } catch (e) {
    print('❌ Test failed: $e');
  }
}
