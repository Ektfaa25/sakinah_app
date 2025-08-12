import 'dart:io';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/core/config/app_config.dart';
import 'package:sakinah_app/features/progress/domain/repositories/progress_repository.dart';

Future<void> main() async {
  print('🔧 Starting progress database debug (console mode)...');

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

    // Check today's progress
    final today = DateTime.now();
    final todayProgress = await progressRepository.getProgressByDate(today);

    print('📊 Today\'s progress: $todayProgress');
    if (todayProgress != null) {
      print('   - Azkar completed: ${todayProgress.azkarCompleted}');
      print('   - Completed azkar IDs: ${todayProgress.completedAzkarIds}');
      print('   - Date: ${todayProgress.date}');
    } else {
      print('   - No progress found for today');
    }

    // Get all progress entries
    final allProgress = await progressRepository.getAllProgress();
    print('📈 Total progress entries: ${allProgress.length}');

    if (allProgress.isNotEmpty) {
      print('   Recent entries:');
      for (int i = 0; i < allProgress.length && i < 5; i++) {
        final entry = allProgress[i];
        print(
          '   ${i + 1}. ${entry.date}: ${entry.azkarCompleted} azkar, IDs: ${entry.completedAzkarIds}',
        );
      }
    }

    // Test adding an azkar completion
    print('🎯 Testing azkar completion...');
    final testAzkarId = 'debug-test-${DateTime.now().millisecondsSinceEpoch}';

    await progressRepository.addAzkarCompletion(azkarId: testAzkarId);
    print('✅ Added test azkar completion: $testAzkarId');

    // Check progress again
    final updatedProgress = await progressRepository.getProgressByDate(today);
    print('📊 Updated progress: $updatedProgress');
    if (updatedProgress != null) {
      print('   - Azkar completed: ${updatedProgress.azkarCompleted}');
      print('   - Completed azkar IDs: ${updatedProgress.completedAzkarIds}');
    }

    print('🎉 Debug completed successfully!');
  } catch (e, stackTrace) {
    print('❌ Debug failed: $e');
    print('Stack trace: $stackTrace');
  }

  // Exit
  exit(0);
}
