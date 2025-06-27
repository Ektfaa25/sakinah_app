import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String _supabaseUrlKey = 'SUPABASE_URL';
  static const String _supabaseAnonKeyKey = 'SUPABASE_ANON_KEY';
  static const String _environmentKey = 'ENVIRONMENT';

  /// Load environment variables from .env file
  static Future<void> loadEnv() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // If .env doesn't exist or can't be loaded, continue with defaults
      print('Warning: Could not load .env file: $e');
    }
  }

  /// Get Supabase URL from environment
  static String get supabaseUrl {
    final url = dotenv.env[_supabaseUrlKey];
    if (url == null || url.isEmpty || url == 'your_supabase_project_url_here') {
      throw Exception(
        'SUPABASE_URL not configured. Please set it in your .env file.\n'
        'Example: SUPABASE_URL=https://your-project.supabase.co',
      );
    }
    return url;
  }

  /// Get Supabase Anonymous Key from environment
  static String get supabaseAnonKey {
    final key = dotenv.env[_supabaseAnonKeyKey];
    if (key == null || key.isEmpty || key == 'your_supabase_anon_key_here') {
      throw Exception(
        'SUPABASE_ANON_KEY not configured. Please set it in your .env file.\n'
        'Get your key from: https://app.supabase.com/project/[your-project]/settings/api',
      );
    }
    return key;
  }

  /// Get current environment (development/production)
  static String get environment {
    return dotenv.env[_environmentKey] ?? 'production';
  }

  /// Check if running in development mode
  static bool get isDevelopment {
    return environment.toLowerCase() == 'development';
  }

  /// Check if running in production mode
  static bool get isProduction {
    return environment.toLowerCase() == 'production';
  }

  /// Validate that all required configuration is present
  static bool validateConfig() {
    try {
      // Try to access required configuration
      supabaseUrl; // ignore: unnecessary_statements
      supabaseAnonKey; // ignore: unnecessary_statements
      return true;
    } catch (e) {
      print('Configuration validation failed: $e');
      return false;
    }
  }

  /// Get all configuration as a map (for debugging)
  static Map<String, String> getAllConfig() {
    return {
      'supabaseUrl': supabaseUrl,
      'environment': environment,
      'isDevelopment': isDevelopment.toString(),
      'isProduction': isProduction.toString(),
      // Don't include the anon key in debug output for security
    };
  }
}
