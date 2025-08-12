/// Route names for the Sakīnah app
class AppRoutes {
  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  // Authentication routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String moodSelection = '/mood-selection';
  static const String azkarDisplay = '/azkar-display';
  static const String progress = '/progress';
  static const String settings = '/settings';

  // New azkar routes
  static const String azkarCategories = '/azkar-categories';
  static const String azkarDetailNew = '/azkar-detail-new';
  static const String azkarFavorites = '/azkar-favorites';
  static const String azkarCardDemo = '/azkar-card-demo';

  // Secondary routes
  static const String customAzkar = '/custom-azkar';
  static const String addAzkar = '/add-azkar';
  static const String reflection = '/reflection';
  static const String achievements = '/achievements';
  static const String profile = '/profile';

  // Utility routes
  static const String about = '/about';
  static const String help = '/help';
  static const String feedback = '/feedback';
  static const String test = '/test'; // For testing Supabase integration
}

/// Route parameters
class RouteParams {
  static const String azkarId = 'azkarId';
  static const String mood = 'mood';
  static const String date = 'date';
  static const String category = 'category';
  static const String categoryId = 'categoryId';
  static const String azkarIndex = 'azkarIndex';
  static const String totalAzkar = 'totalAzkar';
}
