import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/azkar_new.dart';
import 'package:sakinah_app/core/network/supabase_service.dart';

class AzkarSupabaseService {
  static SupabaseClient get _supabase => SupabaseService.instance.client;

  // ==================== AZKAR CATEGORIES ====================

  // ==================== AZKAR CATEGORIES ====================

  /// Test basic database connection
  static Future<bool> testConnection() async {
    try {
      print('🧪 Testing Supabase connection...');

      // Try a simple query to test the connection
      await _supabase.from('azkar_categories').select('count(*)').limit(1);

      print('✅ Connection test successful');
      return true;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }

  /// Fetch all azkar categories from database
  static Future<List<AzkarCategory>> getAzkarCategories() async {
    try {
      print('🔍 Attempting to fetch azkar categories...');
      print('🔗 Supabase client initialized: ${_supabase.toString()}');

      final response = await _supabase
          .from('azkar_categories')
          .select('*')
          .eq('is_active', true)
          .order('order_index', ascending: true);

      print('✅ Successfully fetched ${(response as List).length} categories');

      return (response as List)
          .map((json) => AzkarCategory.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching azkar categories: $e');
      print('🔍 Error type: ${e.runtimeType}');
      throw Exception('Failed to load azkar categories: $e');
    }
  }

  /// Get a single azkar category by ID
  static Future<AzkarCategory?> getAzkarCategoryById(String categoryId) async {
    try {
      final response = await _supabase
          .from('azkar_categories')
          .select('*')
          .eq('id', categoryId)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return null;
      return AzkarCategory.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load azkar category: $e');
    }
  }

  /// Search azkar categories
  static Future<List<AzkarCategory>> searchAzkarCategories(String query) async {
    try {
      final response = await _supabase
          .from('azkar_categories')
          .select('*')
          .eq('is_active', true)
          .or(
            'name_ar.ilike.%$query%,name_en.ilike.%$query%,description.ilike.%$query%',
          )
          .order('order_index', ascending: true);

      return (response as List)
          .map((json) => AzkarCategory.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search azkar categories: $e');
    }
  }

  // ==================== AZKAR ====================

  /// Fetch azkar by category ID
  static Future<List<Azkar>> getAzkarByCategory(String categoryId) async {
    try {
      final response = await _supabase
          .from('azkar')
          .select('*')
          .eq('category_id', categoryId)
          .eq('is_active', true)
          .order('order_index', ascending: true);

      return (response as List).map((json) => Azkar.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load azkar: $e');
    }
  }

  /// Fetch azkar by mood
  static Future<List<Azkar>> getAzkarByMood(String mood) async {
    try {
      final response = await _supabase
          .from('azkar')
          .select('*')
          .contains('associated_moods', [mood.toLowerCase()])
          .eq('is_active', true)
          .order('order_index', ascending: true);

      return (response as List).map((json) => Azkar.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load azkar by mood: $e');
    }
  }

  /// Get a single azkar by ID
  static Future<Azkar?> getAzkarById(String azkarId) async {
    try {
      final response = await _supabase
          .from('azkar')
          .select('*')
          .eq('id', azkarId)
          .eq('is_active', true)
          .maybeSingle();

      if (response == null) return null;
      return Azkar.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load azkar: $e');
    }
  }

  /// Search azkar
  static Future<List<Azkar>> searchAzkar(String query) async {
    try {
      final response = await _supabase
          .from('azkar')
          .select('*')
          .eq('is_active', true)
          .or(
            'text_ar.ilike.%$query%,translation.ilike.%$query%,transliteration.ilike.%$query%,search_tags.ilike.%$query%',
          )
          .order('order_index', ascending: true);

      return (response as List).map((json) => Azkar.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search azkar: $e');
    }
  }

  /// Get azkar with category information
  static Future<List<Map<String, dynamic>>> getAzkarWithCategory(
    String categoryId,
  ) async {
    try {
      final response = await _supabase
          .from('azkar')
          .select('''
            *,
            azkar_categories (
              id,
              name_ar,
              name_en,
              icon,
              color
            )
          ''')
          .eq('category_id', categoryId)
          .eq('is_active', true)
          .order('order_index', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load azkar with category: $e');
    }
  }

  /// Get random azkar for daily suggestions
  static Future<List<Azkar>> getRandomAzkar({int limit = 5}) async {
    try {
      // Use a simple random selection by ordering by random
      final response = await _supabase
          .from('azkar')
          .select('*')
          .eq('is_active', true)
          .limit(limit);

      final azkarList = (response as List)
          .map((json) => Azkar.fromJson(json))
          .toList();

      // Shuffle the list to make it more random
      azkarList.shuffle();
      return azkarList.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to load random azkar: $e');
    }
  }

  // ==================== USER PROGRESS ====================

  /// Get user progress for a specific azkar
  static Future<UserAzkarProgress?> getUserAzkarProgress({
    String? userId,
    required String azkarId,
  }) async {
    try {
      final query = _supabase
          .from('user_azkar_progress')
          .select('*')
          .eq('azkar_id', azkarId);

      if (userId != null) {
        query.eq('user_id', userId);
      } else {
        query.isFilter('user_id', null);
      }

      final response = await query.maybeSingle();

      if (response == null) return null;
      return UserAzkarProgress.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load user azkar progress: $e');
    }
  }

  /// Update or create user progress for an azkar
  static Future<UserAzkarProgress> updateUserAzkarProgress({
    String? userId,
    required String azkarId,
    required int completedCount,
    required int totalCount,
  }) async {
    try {
      final existingProgress = await getUserAzkarProgress(
        userId: userId,
        azkarId: azkarId,
      );

      final now = DateTime.now();
      Map<String, dynamic> progressData;

      if (existingProgress == null) {
        // Create new progress
        progressData = {
          'user_id': userId,
          'azkar_id': azkarId,
          'completed_count': completedCount,
          'total_count': totalCount,
          'last_completed_at': completedCount > 0
              ? now.toIso8601String()
              : null,
          'streak_count': completedCount >= totalCount ? 1 : 0,
        };

        final response = await _supabase
            .from('user_azkar_progress')
            .insert(progressData)
            .select()
            .single();

        return UserAzkarProgress.fromJson(response);
      } else {
        // Update existing progress
        int newStreakCount = existingProgress.streakCount;

        // Update streak if completed today
        if (completedCount >= totalCount) {
          final lastCompleted = existingProgress.lastCompletedAt;
          if (lastCompleted != null) {
            final daysDifference = now.difference(lastCompleted).inDays;
            if (daysDifference == 1) {
              // Consecutive day, increment streak
              newStreakCount = existingProgress.streakCount + 1;
            } else if (daysDifference > 1) {
              // Gap in streak, reset to 1
              newStreakCount = 1;
            }
            // If same day, keep existing streak
          } else {
            newStreakCount = 1;
          }
        }

        progressData = {
          'completed_count': completedCount,
          'total_count': totalCount,
          'last_completed_at': completedCount > 0
              ? now.toIso8601String()
              : null,
          'streak_count': newStreakCount,
          'updated_at': now.toIso8601String(),
        };

        final response = await _supabase
            .from('user_azkar_progress')
            .update(progressData)
            .eq('id', existingProgress.id)
            .select()
            .single();

        return UserAzkarProgress.fromJson(response);
      }
    } catch (e) {
      throw Exception('Failed to update user azkar progress: $e');
    }
  }

  /// Get all user progress
  static Future<List<UserAzkarProgress>> getUserProgress({
    String? userId,
  }) async {
    try {
      final query = _supabase.from('user_azkar_progress').select('*');

      if (userId != null) {
        query.eq('user_id', userId);
      } else {
        query.isFilter('user_id', null);
      }

      final response = await query.order('updated_at', ascending: false);

      return (response as List)
          .map((json) => UserAzkarProgress.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load user progress: $e');
    }
  }

  /// Get user progress with azkar details
  static Future<List<Map<String, dynamic>>> getUserProgressWithAzkar({
    String? userId,
  }) async {
    try {
      final query = _supabase.from('user_azkar_progress').select('''
        *,
        azkar (
          id,
          text_ar,
          translation,
          repeat_count,
          azkar_categories (
            id,
            name_ar,
            name_en,
            icon,
            color
          )
        )
      ''');

      if (userId != null) {
        query.eq('user_id', userId);
      } else {
        query.isFilter('user_id', null);
      }

      final response = await query.order('updated_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load user progress with azkar: $e');
    }
  }

  /// Reset user progress for a specific azkar
  static Future<void> resetUserAzkarProgress({
    String? userId,
    required String azkarId,
  }) async {
    try {
      final query = _supabase
          .from('user_azkar_progress')
          .update({
            'completed_count': 0,
            'last_completed_at': null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('azkar_id', azkarId);

      if (userId != null) {
        query.eq('user_id', userId);
      } else {
        query.isFilter('user_id', null);
      }

      await query;
    } catch (e) {
      throw Exception('Failed to reset user azkar progress: $e');
    }
  }

  // ==================== ANALYTICS & INSIGHTS ====================

  /// Get category completion statistics
  static Future<Map<String, dynamic>> getCategoryStats({String? userId}) async {
    try {
      // This would require a more complex query or multiple queries
      // For now, return basic stats
      final categories = await getAzkarCategories();
      final userProgress = await getUserProgress(userId: userId);

      Map<String, int> categoryCompletions = {};
      Map<String, int> categoryTotals = {};

      for (final category in categories) {
        categoryCompletions[category.id] = 0;
        categoryTotals[category.id] = 0;
      }

      // Count completions and totals per category
      for (final progress in userProgress) {
        final azkar = await getAzkarById(progress.azkarId);
        if (azkar != null) {
          categoryTotals[azkar.categoryId] =
              (categoryTotals[azkar.categoryId] ?? 0) + 1;
          if (progress.isCompleted) {
            categoryCompletions[azkar.categoryId] =
                (categoryCompletions[azkar.categoryId] ?? 0) + 1;
          }
        }
      }

      return {
        'category_completions': categoryCompletions,
        'category_totals': categoryTotals,
        'total_categories': categories.length,
        'completed_categories': categoryCompletions.values
            .where((count) => count > 0)
            .length,
      };
    } catch (e) {
      throw Exception('Failed to get category stats: $e');
    }
  }

  /// Get daily streak information
  static Future<Map<String, dynamic>> getStreakStats({String? userId}) async {
    try {
      final userProgress = await getUserProgress(userId: userId);

      int currentStreak = 0;
      int maxStreak = 0;
      int totalCompletions = 0;

      for (final progress in userProgress) {
        if (progress.streakCount > currentStreak) {
          currentStreak = progress.streakCount;
        }
        if (progress.streakCount > maxStreak) {
          maxStreak = progress.streakCount;
        }
        if (progress.isCompleted) {
          totalCompletions++;
        }
      }

      return {
        'current_streak': currentStreak,
        'max_streak': maxStreak,
        'total_completions': totalCompletions,
        'active_azkar': userProgress.length,
      };
    } catch (e) {
      throw Exception('Failed to get streak stats: $e');
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Get database health check
  static Future<Map<String, dynamic>> getHealthCheck() async {
    try {
      final categoriesResponse = await _supabase
          .from('azkar_categories')
          .select('id')
          .eq('is_active', true);

      final azkarResponse = await _supabase
          .from('azkar')
          .select('id')
          .eq('is_active', true);

      return {
        'status': 'healthy',
        'categories_count': (categoriesResponse as List).length,
        'azkar_count': (azkarResponse as List).length,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}
