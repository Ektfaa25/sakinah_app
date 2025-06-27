import 'package:drift/drift.dart';
import 'package:sakinah_app/core/database/database.dart';

class DriftService {
  static DriftService? _instance;
  static AppDatabase? _database;

  DriftService._internal();

  static DriftService get instance {
    _instance ??= DriftService._internal();
    return _instance!;
  }

  AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }

  Future<void> initializeDatabase() async {
    // Database is initialized lazily, so we just access it
    await database.customSelect('SELECT 1').get();
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Convenience methods for common operations

  // Mood operations
  Future<List<MoodEntry>> getAllMoods() => database.getAllMoods();

  Future<void> trackMoodSelection(String mood, String emoji) async {
    await database.insertMood(
      MoodEntriesCompanion.insert(mood: mood, emoji: emoji),
    );
  }

  Future<List<MoodEntry>> getMoodHistory({int limit = 30}) =>
      database.getMoodHistory(limit: limit);

  // Azkar operations
  Future<List<AzkarEntry>> getAzkarByMood(String mood) =>
      database.getAzkarByMood(mood);

  Future<List<AzkarEntry>> getAllAzkar() => database.getAllAzkar();

  Future<void> addAzkar({
    required String arabicText,
    String? transliteration,
    String? translation,
    required String category,
    required List<String> associatedMoods,
    int repetitions = 1,
  }) async {
    await database.insertAzkar(
      AzkarEntriesCompanion.insert(
        arabicText: arabicText,
        transliteration: transliteration != null
            ? Value(transliteration)
            : const Value.absent(),
        translation: translation != null
            ? Value(translation)
            : const Value.absent(),
        category: category,
        associatedMoods: associatedMoods.join(
          ',',
        ), // Store as comma-separated string
        repetitions: Value(repetitions),
      ),
    );
  }

  // Progress operations
  Future<ProgressEntry?> getTodayProgress() async {
    final today = DateTime.now();
    return database.getProgressByDate(today);
  }

  Future<void> updateDailyProgress({
    required List<int> completedAzkarIds,
    String? reflection,
    String? moodBefore,
    String? moodAfter,
  }) async {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final existingProgress = await database.getProgressByDate(today);

    if (existingProgress != null) {
      // Update existing progress
      await database.updateProgress(
        ProgressEntriesCompanion(
          id: Value(existingProgress.id),
          date: Value(today),
          azkarCompleted: Value(completedAzkarIds.length),
          completedAzkarIds: Value(completedAzkarIds.join(',')),
          reflection: reflection != null
              ? Value(reflection)
              : const Value.absent(),
          moodBefore: moodBefore != null
              ? Value(moodBefore)
              : Value(existingProgress.moodBefore),
          moodAfter: moodAfter != null
              ? Value(moodAfter)
              : const Value.absent(),
        ),
      );
    } else {
      // Create new progress entry
      await database.insertProgress(
        ProgressEntriesCompanion.insert(
          date: today,
          azkarCompleted: Value(completedAzkarIds.length),
          completedAzkarIds: completedAzkarIds.join(','),
          reflection: reflection != null
              ? Value(reflection)
              : const Value.absent(),
          moodBefore: moodBefore != null
              ? Value(moodBefore)
              : const Value.absent(),
          moodAfter: moodAfter != null
              ? Value(moodAfter)
              : const Value.absent(),
        ),
      );
    }

    // Update streak count
    await _updateStreakCount(today);
  }

  Future<void> _updateStreakCount(DateTime date) async {
    final yesterday = date.subtract(const Duration(days: 1));
    final yesterdayProgress = await database.getProgressByDate(yesterday);

    int newStreakCount = 1; // At least 1 since today has progress

    if (yesterdayProgress != null && yesterdayProgress.azkarCompleted > 0) {
      newStreakCount = yesterdayProgress.streakCount + 1;
    }

    final todayProgress = await database.getProgressByDate(date);
    if (todayProgress != null) {
      await database.updateProgress(
        ProgressEntriesCompanion(
          id: Value(todayProgress.id),
          streakCount: Value(newStreakCount),
        ),
      );
    }
  }

  Future<int> getCurrentStreak() => database.getCurrentStreak();

  Future<List<ProgressEntry>> getWeeklyProgress() {
    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return database.getProgressInRange(weekStart, weekEnd);
  }

  Future<List<ProgressEntry>> getMonthlyProgress() {
    final today = DateTime.now();
    final monthStart = DateTime(today.year, today.month, 1);
    final monthEnd = DateTime(today.year, today.month + 1, 0);

    return database.getProgressInRange(monthStart, monthEnd);
  }

  // Settings operations
  Future<String?> getSetting(String key) => database.getSetting(key);

  Future<void> setSetting(String key, String value) =>
      database.setSetting(key, value);

  // Theme settings
  Future<bool> isDarkMode() async {
    final darkMode = await getSetting('dark_mode');
    return darkMode == 'true';
  }

  Future<void> setDarkMode(bool isDark) =>
      setSetting('dark_mode', isDark.toString());

  // Notification settings
  Future<bool> areNotificationsEnabled() async {
    final enabled = await getSetting('notifications_enabled');
    return enabled != 'false'; // Default to true
  }

  Future<void> setNotificationsEnabled(bool enabled) =>
      setSetting('notifications_enabled', enabled.toString());

  // Daily goal settings
  Future<int> getDailyAzkarGoal() async {
    final goal = await getSetting('daily_azkar_goal');
    return int.tryParse(goal ?? '5') ?? 5; // Default to 5
  }

  Future<void> setDailyAzkarGoal(int goal) =>
      setSetting('daily_azkar_goal', goal.toString());
}
