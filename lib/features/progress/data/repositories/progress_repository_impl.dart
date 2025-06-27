import 'package:sakinah_app/core/network/supabase_service.dart';
import 'package:sakinah_app/features/progress/data/models/user_progress_model.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/features/progress/domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final SupabaseService _supabaseService;
  bool _isInitialized = false;

  ProgressRepositoryImpl(this._supabaseService);

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<void> clearAll() async {
    await _supabaseService.client
        .from('user_progress')
        .delete()
        .neq('id', '00000000-0000-0000-0000-000000000000');
  }

  @override
  Future<List<UserProgress>> getAllProgress() async {
    try {
      final response = await _supabaseService.client
          .from('user_progress')
          .select()
          .order('date', ascending: false);

      return (response as List)
          .map((json) => UserProgressModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all progress: $e');
    }
  }

  @override
  Future<UserProgress?> getProgressByDate(DateTime date) async {
    try {
      final dateString = date.toIso8601String().split('T')[0];
      final response = await _supabaseService.client
          .from('user_progress')
          .select()
          .eq('date', dateString)
          .maybeSingle();

      if (response == null) return null;
      return UserProgressModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch progress by date: $e');
    }
  }

  @override
  Future<List<UserProgress>> getProgressInRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final startString = start.toIso8601String().split('T')[0];
      final endString = end.toIso8601String().split('T')[0];

      final response = await _supabaseService.client
          .from('user_progress')
          .select()
          .gte('date', startString)
          .lte('date', endString)
          .order('date', ascending: false);

      return (response as List)
          .map((json) => UserProgressModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch progress in range: $e');
    }
  }

  @override
  Future<int> getCurrentStreak() async {
    try {
      return await calculateCurrentStreak();
    } catch (e) {
      throw Exception('Failed to get current streak: $e');
    }
  }

  @override
  Future<int> updateDailyProgress(UserProgress progress) async {
    try {
      final progressModel = UserProgressModel(
        date: progress.date,
        azkarCompleted: progress.azkarCompleted,
        streakCount: progress.streakCount,
        completedAzkarIds: progress.completedAzkarIds,
        reflection: progress.reflection,
        moodBefore: progress.moodBefore,
        moodAfter: progress.moodAfter,
      );

      final existingProgress = await getProgressByDate(progress.date);

      if (existingProgress != null) {
        // Update existing progress
        if (existingProgress is UserProgressModel &&
            existingProgress.supabaseId != null) {
          final updateData = progressModel.toJson();
          updateData.remove('id');
          updateData.remove('created_at');
          updateData['updated_at'] = DateTime.now().toIso8601String();

          await _supabaseService.client
              .from('user_progress')
              .update(updateData)
              .eq('id', existingProgress.supabaseId!);

          return existingProgress.supabaseId!.hashCode;
        }
      } else {
        // Create new progress entry
        final response = await _supabaseService.client
            .from('user_progress')
            .insert(progressModel.toSupabaseInsert())
            .select()
            .single();

        return response['id'].hashCode;
      }

      return 0;
    } catch (e) {
      throw Exception('Failed to update daily progress: $e');
    }
  }

  @override
  Future<void> addAzkarCompletion({
    required int azkarId,
    String? moodBefore,
    String? moodAfter,
    String? reflection,
  }) async {
    try {
      final today = DateTime.now();
      final todayProgress = await getProgressByDate(today);

      if (todayProgress != null) {
        // Update existing progress
        final updatedCompletedIds = List<int>.from(
          todayProgress.completedAzkarIds,
        );
        if (!updatedCompletedIds.contains(azkarId)) {
          updatedCompletedIds.add(azkarId);
        }

        final updatedProgress = todayProgress.copyWith(
          azkarCompleted: updatedCompletedIds.length,
          completedAzkarIds: updatedCompletedIds,
          moodBefore: moodBefore ?? todayProgress.moodBefore,
          moodAfter: moodAfter ?? todayProgress.moodAfter,
          reflection: reflection ?? todayProgress.reflection,
        );

        await updateDailyProgress(updatedProgress);
      } else {
        // Create new progress entry
        final newProgress = UserProgress(
          date: today,
          azkarCompleted: 1,
          streakCount: await calculateCurrentStreak() + 1,
          completedAzkarIds: [azkarId],
          moodBefore: moodBefore,
          moodAfter: moodAfter,
          reflection: reflection,
          createdAt: today,
        );

        await updateDailyProgress(newProgress);
      }
    } catch (e) {
      throw Exception('Failed to add azkar completion: $e');
    }
  }

  @override
  Future<List<UserProgress>> getWeeklyProgress([DateTime? weekStart]) async {
    try {
      final start =
          weekStart ?? DateTime.now().subtract(const Duration(days: 7));
      final end = start.add(const Duration(days: 6));

      return await getProgressInRange(start, end);
    } catch (e) {
      throw Exception('Failed to get weekly progress: $e');
    }
  }

  @override
  Future<List<UserProgress>> getMonthlyProgress([DateTime? monthStart]) async {
    try {
      final start =
          monthStart ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
      final end = DateTime(start.year, start.month + 1, 0);

      return await getProgressInRange(start, end);
    } catch (e) {
      throw Exception('Failed to get monthly progress: $e');
    }
  }

  @override
  Future<int> calculateCurrentStreak() async {
    try {
      final allProgress = await getAllProgress();
      if (allProgress.isEmpty) return 0;

      // Sort by date descending
      allProgress.sort((a, b) => b.date.compareTo(a.date));

      int streak = 0;
      DateTime currentDate = DateTime.now();

      for (final progress in allProgress) {
        final daysDifference = currentDate.difference(progress.date).inDays;

        // Check if the progress is for today or consecutive days
        if (daysDifference == streak) {
          if (progress.azkarCompleted > 0) {
            streak++;
            currentDate = progress.date;
          } else {
            break; // Break streak if no azkar completed on this day
          }
        } else if (daysDifference > streak) {
          break; // Gap in progress, streak ends
        }
      }

      return streak;
    } catch (e) {
      throw Exception('Failed to calculate current streak: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAchievementStats() async {
    try {
      final allProgress = await getAllProgress();

      final totalAzkarCompleted = allProgress.fold<int>(
        0,
        (sum, progress) => sum + progress.azkarCompleted,
      );

      final daysActive = allProgress.where((p) => p.azkarCompleted > 0).length;
      final currentStreak = await calculateCurrentStreak();

      final longestStreak = await _calculateLongestStreak(allProgress);

      return {
        'totalAzkarCompleted': totalAzkarCompleted,
        'daysActive': daysActive,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'averageAzkarPerDay': daysActive > 0
            ? totalAzkarCompleted / daysActive
            : 0,
      };
    } catch (e) {
      throw Exception('Failed to get achievement stats: $e');
    }
  }

  @override
  Future<Map<String, int>> getMoodPatterns({int days = 30}) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));

      final progressList = await getProgressInRange(startDate, endDate);

      final moodCounts = <String, int>{};

      for (final progress in progressList) {
        if (progress.moodBefore != null) {
          moodCounts[progress.moodBefore!] =
              (moodCounts[progress.moodBefore!] ?? 0) + 1;
        }
        if (progress.moodAfter != null) {
          moodCounts[progress.moodAfter!] =
              (moodCounts[progress.moodAfter!] ?? 0) + 1;
        }
      }

      return moodCounts;
    } catch (e) {
      throw Exception('Failed to get mood patterns: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportProgressData() async {
    try {
      final allProgress = await getAllProgress();

      return {
        'exportDate': DateTime.now().toIso8601String(),
        'totalEntries': allProgress.length,
        'progress': allProgress
            .map(
              (p) => {
                'date': p.date.toIso8601String(),
                'azkarCompleted': p.azkarCompleted,
                'streakCount': p.streakCount,
                'completedAzkarIds': p.completedAzkarIds,
                'reflection': p.reflection,
                'moodBefore': p.moodBefore,
                'moodAfter': p.moodAfter,
              },
            )
            .toList(),
      };
    } catch (e) {
      throw Exception('Failed to export progress data: $e');
    }
  }

  @override
  Future<void> importProgressData(Map<String, dynamic> data) async {
    try {
      final progressList = data['progress'] as List?;
      if (progressList == null) return;

      for (final progressData in progressList) {
        final progress = UserProgress(
          date: DateTime.parse(progressData['date']),
          azkarCompleted: progressData['azkarCompleted'] ?? 0,
          streakCount: progressData['streakCount'] ?? 0,
          completedAzkarIds: List<int>.from(
            progressData['completedAzkarIds'] ?? [],
          ),
          reflection: progressData['reflection'],
          moodBefore: progressData['moodBefore'],
          moodAfter: progressData['moodAfter'],
        );

        await updateDailyProgress(progress);
      }
    } catch (e) {
      throw Exception('Failed to import progress data: $e');
    }
  }

  // Helper method to calculate longest streak
  Future<int> _calculateLongestStreak(List<UserProgress> allProgress) async {
    if (allProgress.isEmpty) return 0;

    // Sort by date ascending
    allProgress.sort((a, b) => a.date.compareTo(b.date));

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final progress in allProgress) {
      if (progress.azkarCompleted > 0) {
        if (lastDate == null ||
            progress.date.difference(lastDate).inDays == 1) {
          currentStreak++;
          longestStreak = currentStreak > longestStreak
              ? currentStreak
              : longestStreak;
        } else {
          currentStreak = 1;
        }
        lastDate = progress.date;
      } else {
        currentStreak = 0;
        lastDate = null;
      }
    }

    return longestStreak;
  }
}
