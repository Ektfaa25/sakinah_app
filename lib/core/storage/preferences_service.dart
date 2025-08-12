import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _dailyGoalKey = 'daily_goal';
  static const String _dailyGoalsKey =
      'daily_goals_'; // prefix for date-specific goals
  static const int _defaultDailyGoal = 5;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get the daily goal setting (default goal)
  int getDailyGoal() {
    return _prefs.getInt(_dailyGoalKey) ?? _defaultDailyGoal;
  }

  /// Set the daily goal setting (default goal)
  Future<bool> setDailyGoal(int goal) async {
    return await _prefs.setInt(_dailyGoalKey, goal);
  }

  /// Reset daily goal to default
  Future<bool> resetDailyGoal() async {
    return await _prefs.remove(_dailyGoalKey);
  }

  /// Get goal for a specific date
  int getDailyGoalForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    final goalKey = '$_dailyGoalsKey$dateKey';
    return _prefs.getInt(goalKey) ?? getDailyGoal(); // fallback to default goal
  }

  /// Set goal for a specific date
  Future<bool> setDailyGoalForDate(DateTime date, int goal) async {
    final dateKey = _formatDateKey(date);
    final goalKey = '$_dailyGoalsKey$dateKey';
    return await _prefs.setInt(goalKey, goal);
  }

  /// Remove goal for a specific date (falls back to default goal)
  Future<bool> removeDailyGoalForDate(DateTime date) async {
    final dateKey = _formatDateKey(date);
    final goalKey = '$_dailyGoalsKey$dateKey';
    return await _prefs.remove(goalKey);
  }

  /// Check if a specific date has a custom goal set
  bool hasCustomGoalForDate(DateTime date) {
    final dateKey = _formatDateKey(date);
    final goalKey = '$_dailyGoalsKey$dateKey';
    return _prefs.containsKey(goalKey);
  }

  /// Get all dates that have custom goals set
  List<DateTime> getDatesWithCustomGoals() {
    final allKeys = _prefs.getKeys();
    final goalKeys = allKeys.where((key) => key.startsWith(_dailyGoalsKey));

    return goalKeys
        .map((key) {
          final dateKey = key.substring(_dailyGoalsKey.length);
          return _parseDateKey(dateKey);
        })
        .where((date) => date != null)
        .cast<DateTime>()
        .toList();
  }

  /// Format date as key for storage (YYYY-MM-DD)
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Parse date key back to DateTime
  DateTime? _parseDateKey(String dateKey) {
    try {
      final parts = dateKey.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Invalid date key format
    }
    return null;
  }
}
