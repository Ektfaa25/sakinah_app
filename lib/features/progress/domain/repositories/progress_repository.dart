import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/core/repositories/base_repository.dart';

/// Repository interface for progress tracking operations
abstract class ProgressRepository extends BaseRepository {
  /// Get all progress entries
  Future<List<UserProgress>> getAllProgress();

  /// Get progress for a specific date
  Future<UserProgress?> getProgressByDate(DateTime date);

  /// Get progress for a date range
  Future<List<UserProgress>> getProgressInRange(DateTime start, DateTime end);

  /// Get current streak count
  Future<int> getCurrentStreak();

  /// Update daily progress
  Future<int> updateDailyProgress(UserProgress progress);

  /// Add azkar completion to today's progress
  Future<void> addAzkarCompletion({
    required int azkarId,
    String? moodBefore,
    String? moodAfter,
    String? reflection,
  });

  /// Get weekly progress summary
  Future<List<UserProgress>> getWeeklyProgress([DateTime? weekStart]);

  /// Get monthly progress summary
  Future<List<UserProgress>> getMonthlyProgress([DateTime? monthStart]);

  /// Calculate streak from progress history
  Future<int> calculateCurrentStreak();

  /// Get achievement statistics
  Future<Map<String, dynamic>> getAchievementStats();

  /// Get mood patterns from progress history
  Future<Map<String, int>> getMoodPatterns({int days = 30});

  /// Export progress data
  Future<Map<String, dynamic>> exportProgressData();

  /// Import progress data
  Future<void> importProgressData(Map<String, dynamic> data);
}
