import 'package:sakinah_app/features/azkar/data/datasources/local_azkar_data_source.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/features/azkar/domain/repositories/azkar_repository.dart';

class LocalAzkarRepositoryImpl implements AzkarRepository {
  final LocalAzkarDataSource _localDataSource;
  bool _isInitialized = false;

  LocalAzkarRepositoryImpl(this._localDataSource);

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<void> clearAll() async {
    _localDataSource.clearCache();
  }

  @override
  Future<List<Azkar>> getAllAzkar() async {
    try {
      return await _localDataSource.getAllAzkar();
    } catch (e) {
      throw Exception('Failed to fetch azkar: $e');
    }
  }

  @override
  Future<List<Azkar>> getAzkarByMood(String mood) async {
    try {
      return await _localDataSource.getAzkarByMood(mood);
    } catch (e) {
      throw Exception('Failed to fetch azkar by mood: $e');
    }
  }

  @override
  Future<List<Azkar>> getAzkarByCategory(String category) async {
    try {
      return await _localDataSource.getAzkarByCategory(category);
    } catch (e) {
      throw Exception('Failed to fetch azkar by category: $e');
    }
  }

  @override
  Future<Azkar?> getAzkarById(int id) async {
    try {
      final allAzkar = await _localDataSource.getAllAzkar();
      return allAzkar.where((azkar) => azkar.id == id).firstOrNull;
    } catch (e) {
      throw Exception('Failed to fetch azkar by ID: $e');
    }
  }

  @override
  Future<List<Azkar>> searchAzkar(String query) async {
    try {
      return await _localDataSource.searchAzkar(query);
    } catch (e) {
      throw Exception('Failed to search azkar: $e');
    }
  }

  Future<void> markAsCompleted(int azkarId) async {
    // For local data, we don't persist completion state
    // This could be implemented with SharedPreferences if needed
  }

  Future<void> markAsIncomplete(int azkarId) async {
    // For local data, we don't persist completion state
    // This could be implemented with SharedPreferences if needed
  }

  Future<Set<int>> getCompletedAzkarIds() async {
    // For now, return empty set
    // This could be implemented with SharedPreferences if needed
    return {};
  }

  @override
  Future<int> addAzkar(Azkar azkar) async {
    throw UnimplementedError(
      'Adding custom azkar not supported with local CSV data',
    );
  }

  @override
  Future<bool> updateAzkar(Azkar azkar) async {
    throw UnimplementedError(
      'Updating azkar not supported with local CSV data',
    );
  }

  @override
  Future<bool> deleteAzkar(int id) async {
    throw UnimplementedError(
      'Deleting azkar not supported with local CSV data',
    );
  }

  @override
  Future<List<Azkar>> getRecommendations({
    required String mood,
    int limit = 5,
    List<int>? excludeIds,
  }) async {
    try {
      final moodAzkar = await _localDataSource.getAzkarByMood(mood);
      if (excludeIds != null) {
        return moodAzkar
            .where((azkar) => !excludeIds.contains(azkar.id))
            .take(limit)
            .toList();
      }
      return moodAzkar.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }

  @override
  Future<List<Azkar>> getCustomAzkar() async {
    // For local CSV data, there are no custom azkar
    return [];
  }

  @override
  Future<void> importDefaultAzkar() async {
    // For local CSV data, azkar are already loaded from CSV
    // This method is a no-op
  }
}
