import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sakinah_app/core/config/app_config.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseClient? _client;

  SupabaseService._internal();

  static SupabaseService get instance {
    _instance ??= SupabaseService._internal();
    return _instance!;
  }

  SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase client not initialized. Call initialize() first.',
      );
    }
    return _client!;
  }

  /// Initialize Supabase with environment variables
  static Future<void> initialize() async {
    // Load environment variables
    await AppConfig.loadEnv();

    // Validate configuration
    if (!AppConfig.validateConfig()) {
      throw Exception(
        'Supabase configuration invalid. Please check your .env file and ensure '
        'SUPABASE_URL and SUPABASE_ANON_KEY are properly set.',
      );
    }

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      debug: AppConfig.isDevelopment,
    );

    _client = Supabase.instance.client;
  }

  // Authentication methods

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: displayName != null ? {'display_name': displayName} : null,
    );
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out current user
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Get current user
  User? get currentUser => client.auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => client.auth.currentUser != null;

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Cloud sync methods for progress and settings

  /// Sync user progress to cloud
  Future<void> syncProgressToCloud({
    required String userId,
    required Map<String, dynamic> progressData,
  }) async {
    try {
      await client.from('user_progress').upsert({
        'user_id': userId,
        'progress_data': progressData,
        'last_synced': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to sync progress to cloud: $e');
    }
  }

  /// Get user progress from cloud
  Future<Map<String, dynamic>?> getProgressFromCloud(String userId) async {
    try {
      final response = await client
          .from('user_progress')
          .select('progress_data, last_synced')
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Failed to get progress from cloud: $e');
    }
  }

  /// Sync user settings to cloud
  Future<void> syncSettingsToCloud({
    required String userId,
    required Map<String, dynamic> settings,
  }) async {
    try {
      await client.from('user_settings').upsert({
        'user_id': userId,
        'settings': settings,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to sync settings to cloud: $e');
    }
  }

  /// Get user settings from cloud
  Future<Map<String, dynamic>?> getSettingsFromCloud(String userId) async {
    try {
      final response = await client
          .from('user_settings')
          .select('settings, updated_at')
          .eq('user_id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Failed to get settings from cloud: $e');
    }
  }

  /// Sync custom azkar to cloud
  Future<void> syncCustomAzkarToCloud({
    required String userId,
    required List<Map<String, dynamic>> customAzkar,
  }) async {
    try {
      // Delete existing custom azkar for this user
      await client.from('custom_azkar').delete().eq('user_id', userId);

      // Insert new custom azkar
      if (customAzkar.isNotEmpty) {
        final azkarWithUserId = customAzkar
            .map(
              (azkar) => {
                ...azkar,
                'user_id': userId,
                'created_at': DateTime.now().toIso8601String(),
              },
            )
            .toList();

        await client.from('custom_azkar').insert(azkarWithUserId);
      }
    } catch (e) {
      throw Exception('Failed to sync custom azkar to cloud: $e');
    }
  }

  /// Get custom azkar from cloud
  Future<List<Map<String, dynamic>>> getCustomAzkarFromCloud(
    String userId,
  ) async {
    try {
      final response = await client
          .from('custom_azkar')
          .select()
          .eq('user_id', userId)
          .order('created_at');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get custom azkar from cloud: $e');
    }
  }

  // Analytics and insights (anonymized)

  /// Track app usage analytics (anonymized)
  Future<void> trackUsageAnalytics({
    required String eventType,
    required Map<String, dynamic> eventData,
  }) async {
    try {
      await client.from('analytics').insert({
        'event_type': eventType,
        'event_data': eventData,
        'timestamp': DateTime.now().toIso8601String(),
        // No user_id to keep it anonymous
      });
    } catch (e) {
      // Fail silently for analytics to not affect user experience
      print('Analytics tracking failed: $e');
    }
  }

  // Utility methods

  /// Test connection to Supabase
  Future<bool> testConnection() async {
    try {
      await client.from('_health_check').select().limit(1);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get app configuration from Supabase
  Future<Map<String, dynamic>?> getAppConfig() async {
    try {
      final response = await client
          .from('app_config')
          .select()
          .eq('is_active', true)
          .order('version', ascending: false)
          .limit(1)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Failed to get app config: $e');
      return null;
    }
  }
}
