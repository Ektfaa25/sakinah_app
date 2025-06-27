import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sakinah_app/features/mood/data/models/mood_model.dart';
import 'package:sakinah_app/features/mood/domain/entities/mood.dart';
import 'package:sakinah_app/features/mood/domain/repositories/mood_repository.dart';

class MoodRepositoryImpl implements MoodRepository {
  static const String _moodHistoryKey = 'mood_history';
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_moodHistoryKey);
  }

  @override
  Future<List<Mood>> getAllMoods() async {
    // Return predefined moods from the entity
    return Mood.predefinedMoods;
  }

  @override
  Future<Mood?> getMoodByName(String name) async {
    return Mood.getPredefinedMood(name);
  }

  @override
  Future<void> trackMoodSelection(Mood mood) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_moodHistoryKey);

      List<Map<String, dynamic>> history = [];
      if (historyJson != null) {
        final List<dynamic> decodedHistory = json.decode(historyJson);
        history = decodedHistory.cast<Map<String, dynamic>>();
      }

      // Add new mood selection with timestamp
      final moodWithTime = MoodModel(
        name: mood.name,
        emoji: mood.emoji,
        description: mood.description,
        selectedAt: DateTime.now(),
      );

      history.insert(0, moodWithTime.toJson()); // Insert at beginning

      // Keep only last 100 mood selections
      if (history.length > 100) {
        history = history.take(100).toList();
      }

      await prefs.setString(_moodHistoryKey, json.encode(history));
    } catch (e) {
      throw Exception('Failed to track mood selection: $e');
    }
  }

  @override
  Future<List<Mood>> getMoodHistory({int limit = 30}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_moodHistoryKey);

      if (historyJson == null) return [];

      final List<dynamic> decodedHistory = json.decode(historyJson);
      final history = decodedHistory.cast<Map<String, dynamic>>();

      return history
          .take(limit)
          .map((json) => MoodModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get mood history: $e');
    }
  }

  @override
  Future<List<Mood>> getMoodPatterns({int limit = 5}) async {
    try {
      final history = await getMoodHistory(
        limit: 100,
      ); // Get more history for better patterns

      if (history.isEmpty) return [];

      // Count mood occurrences
      final moodCounts = <String, int>{};
      for (final mood in history) {
        moodCounts[mood.name] = (moodCounts[mood.name] ?? 0) + 1;
      }

      // Sort by count and return most frequent moods
      final sortedMoods = moodCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final patterns = <Mood>[];
      for (final entry in sortedMoods.take(limit)) {
        final mood = Mood.getPredefinedMood(entry.key);
        if (mood != null) {
          patterns.add(mood);
        }
      }

      return patterns;
    } catch (e) {
      throw Exception('Failed to get mood patterns: $e');
    }
  }

  @override
  Future<void> clearMoodHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_moodHistoryKey);
    } catch (e) {
      throw Exception('Failed to clear mood history: $e');
    }
  }

  // Additional helper methods
  Future<Mood?> getLastSelectedMood() async {
    final history = await getMoodHistory(limit: 1);
    return history.isNotEmpty ? history.first : null;
  }

  Future<Map<String, int>> getMoodStatistics({int days = 30}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final history = await getMoodHistory(limit: 1000);

    final recentMoods = history.where(
      (mood) => mood.selectedAt != null && mood.selectedAt!.isAfter(cutoffDate),
    );

    final statistics = <String, int>{};
    for (final mood in recentMoods) {
      statistics[mood.name] = (statistics[mood.name] ?? 0) + 1;
    }

    return statistics;
  }
}
