import 'package:sakinah_app/features/mood/domain/entities/mood.dart';
import 'package:sakinah_app/core/repositories/base_repository.dart';

/// Repository interface for mood-related operations
abstract class MoodRepository extends BaseRepository {
  /// Get all available moods
  Future<List<Mood>> getAllMoods();

  /// Get mood by name
  Future<Mood?> getMoodByName(String name);

  /// Track a mood selection
  Future<void> trackMoodSelection(Mood mood);

  /// Get mood history
  Future<List<Mood>> getMoodHistory({int limit = 30});

  /// Get mood patterns (most selected moods)
  Future<List<Mood>> getMoodPatterns({int limit = 5});

  /// Delete mood history
  Future<void> clearMoodHistory();
}
