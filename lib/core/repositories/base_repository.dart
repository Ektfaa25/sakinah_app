/// Base repository interface that all repositories should implement
abstract class BaseRepository {
  /// Initialize the repository
  Future<void> initialize();

  /// Clear all data from the repository
  Future<void> clearAll();

  /// Check if the repository is ready to use
  bool get isInitialized;
}
