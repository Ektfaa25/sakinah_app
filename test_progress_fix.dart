import 'package:flutter/material.dart';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/core/config/app_config.dart';
import 'package:sakinah_app/features/progress/domain/repositories/progress_repository.dart';

/// Test script to verify progress system fixes
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔧 Testing progress system fixes...');

  try {
    // Load environment configuration
    await AppConfig.loadEnv();
    print('✅ App config loaded');

    // Initialize dependencies
    await initializeDependencies();
    print('✅ Dependencies initialized');

    // Get progress repository
    final progressRepository = sl<ProgressRepository>();
    print('✅ Progress repository obtained');

    // Create today's date (date only, no time)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    print('📅 Testing with date: $today');

    // Clear any existing progress to start fresh
    print('🧹 Clearing existing progress...');
    try {
      await progressRepository.clearAll();
      print('✅ Cleared existing progress');
    } catch (e) {
      print('⚠️ Could not clear progress (might be empty): $e');
    }

    // Test 1: Add first azkar completion
    print('\n🎯 Test 1: Adding first azkar completion...');
    await progressRepository.addAzkarCompletion(azkarId: 'test-azkar-1');
    print('✅ Added first azkar completion');

    // Check progress after first azkar
    final progress1 = await progressRepository.getProgressByDate(today);
    print('📊 Progress after 1st azkar: $progress1');
    if (progress1 != null) {
      print('   - Azkar completed: ${progress1.azkarCompleted}');
      print('   - Completed azkar IDs: ${progress1.completedAzkarIds}');
      print('   - Date: ${progress1.date}');
    }

    // Test 2: Add second azkar completion (same category)
    print('\n🎯 Test 2: Adding second azkar from same category...');
    await progressRepository.addAzkarCompletion(azkarId: 'test-azkar-2');
    print('✅ Added second azkar completion');

    // Check progress after second azkar
    final progress2 = await progressRepository.getProgressByDate(today);
    print('📊 Progress after 2nd azkar: $progress2');
    if (progress2 != null) {
      print('   - Azkar completed: ${progress2.azkarCompleted}');
      print('   - Completed azkar IDs: ${progress2.completedAzkarIds}');
      print('   - Date: ${progress2.date}');
    }

    // Test 3: Add azkar from different category
    print('\n🎯 Test 3: Adding azkar from different category...');
    await progressRepository.addAzkarCompletion(
      azkarId: 'different-category-azkar',
    );
    print('✅ Added azkar from different category');

    // Check final progress
    final finalProgress = await progressRepository.getProgressByDate(today);
    print('📊 Final progress: $finalProgress');
    if (finalProgress != null) {
      print('   - Azkar completed: ${finalProgress.azkarCompleted}');
      print('   - Completed azkar IDs: ${finalProgress.completedAzkarIds}');
      print('   - Date: ${finalProgress.date}');
    }

    print('\n🎉 Progress system test completed successfully!');

    // Test 4: Verify data persistence
    print('\n🔄 Test 4: Verifying data persistence...');
    final persistedProgress = await progressRepository.getProgressByDate(today);
    if (persistedProgress != null) {
      print('✅ Data persisted correctly');
      print('   - Azkar completed: ${persistedProgress.azkarCompleted}');
      print('   - Completed azkar IDs: ${persistedProgress.completedAzkarIds}');
    } else {
      print('❌ Data was not persisted');
    }
  } catch (e, stackTrace) {
    print('❌ Test failed: $e');
    print('Stack trace: $stackTrace');
  }
}
