import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/core/repositories/base_repository.dart';

/// Repository interface for azkar-related operations
abstract class AzkarRepository extends BaseRepository {
  /// Get all azkar
  Future<List<Azkar>> getAllAzkar();

  /// Get azkar by mood
  Future<List<Azkar>> getAzkarByMood(String mood);

  /// Get azkar by category
  Future<List<Azkar>> getAzkarByCategory(String category);

  /// Get azkar by ID
  Future<Azkar?> getAzkarById(int id);

  /// Add new azkar
  Future<int> addAzkar(Azkar azkar);

  /// Update existing azkar
  Future<bool> updateAzkar(Azkar azkar);

  /// Delete azkar
  Future<bool> deleteAzkar(int id);

  /// Search azkar by text
  Future<List<Azkar>> searchAzkar(String query);

  /// Get azkar recommendations based on mood and user history
  Future<List<Azkar>> getRecommendations({
    required String mood,
    int limit = 5,
    List<int>? excludeIds,
  });

  /// Get user's custom azkar
  Future<List<Azkar>> getCustomAzkar();

  /// Import default azkar data
  Future<void> importDefaultAzkar();
}
