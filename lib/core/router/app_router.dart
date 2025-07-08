import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/features/mood/presentation/pages/mood_selection_page.dart';
import 'package:sakinah_app/features/mood/presentation/bloc/mood_bloc.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_display_page.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_categories_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_category_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/progress/presentation/pages/progress_page.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';

// Import pages (will be created later)
// import 'package:sakinah_app/features/splash/presentation/pages/splash_page.dart';
// import 'package:sakinah_app/features/onboarding/presentation/pages/onboarding_page.dart';
// import 'package:sakinah_app/features/auth/presentation/pages/login_page.dart';
// import 'package:sakinah_app/features/auth/presentation/pages/signup_page.dart';
// import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';
// import 'package:sakinah_app/features/azkar/presentation/pages/azkar_display_page.dart';
// import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_page.dart';
// import 'package:sakinah_app/features/progress/presentation/pages/progress_page.dart';
// import 'package:sakinah_app/features/settings/presentation/pages/settings_page.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  /// Get the root navigator key
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  /// Get the shell navigator key
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;

  /// Create and configure the router
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.home,
      debugLogDiagnostics: true,
      routes: [
        // Splash route
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) =>
              _buildPlaceholderPage('Splash', 'Loading Sakīnah...'),
        ),

        // Onboarding route
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          builder: (context, state) =>
              _buildPlaceholderPage('Onboarding', 'Welcome to Sakīnah'),
        ),

        // Authentication routes
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) =>
              _buildPlaceholderPage('Login', 'Sign in to continue'),
        ),

        GoRoute(
          path: AppRoutes.signup,
          name: 'signup',
          builder: (context, state) =>
              _buildPlaceholderPage('Sign Up', 'Create your account'),
        ),

        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgot-password',
          builder: (context, state) =>
              _buildPlaceholderPage('Forgot Password', 'Reset your password'),
        ),

        // Main app routes with bottom navigation shell
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return _buildMainShell(child);
          },
          routes: [
            // Home route
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),

            // Progress route
            GoRoute(
              path: AppRoutes.progress,
              name: 'progress',
              builder: (context, state) => BlocProvider(
                create: (context) => sl<ProgressBloc>(),
                child: const ProgressPage(),
              ),
            ),

            // Settings route
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              builder: (context, state) =>
                  _buildPlaceholderPage('Settings', 'App preferences'),
            ),
          ],
        ),

        // Mood selection route (outside shell for full screen)
        GoRoute(
          path: AppRoutes.moodSelection,
          name: 'mood-selection',
          builder: (context, state) => BlocProvider(
            create: (context) => sl<MoodBloc>(),
            child: const MoodSelectionPage(),
          ),
        ),

        // Azkar routes (outside shell for full screen)
        GoRoute(
          path: AppRoutes.azkarDisplay,
          name: 'azkar-display',
          builder: (context, state) {
            final mood = state.uri.queryParameters[RouteParams.mood];
            final category = state.uri.queryParameters[RouteParams.category];
            return AzkarDisplayPage(mood: mood, category: category);
          },
        ),

        // New azkar categories route
        GoRoute(
          path: AppRoutes.azkarCategories,
          name: 'azkar-categories',
          builder: (context, state) => const AzkarScreen(),
        ),

        // Azkar category route with category parameter
        GoRoute(
          path: '${AppRoutes.azkarCategory}/:${RouteParams.categoryId}',
          name: 'azkar-category',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final category = extra?['category'] as AzkarCategory?;

            if (category == null) {
              return _buildPlaceholderPage('Error', 'Category not found');
            }

            return AzkarCategoryScreen(category: category);
          },
        ),

        // New azkar detail route
        GoRoute(
          path: '${AppRoutes.azkarDetailNew}/:${RouteParams.azkarId}',
          name: 'azkar-detail-new',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final azkar = extra?['azkar'] as Azkar?;
            final category = extra?['category'] as AzkarCategory?;
            final azkarIndex = extra?['azkarIndex'] as int? ?? 0;
            final totalAzkar = extra?['totalAzkar'] as int? ?? 1;
            final azkarList = extra?['azkarList'] as List<Azkar>?;

            if (azkar == null || category == null) {
              return _buildPlaceholderPage('Error', 'Azkar not found');
            }

            return AzkarDetailScreen(
              azkar: azkar,
              category: category,
              azkarIndex: azkarIndex,
              totalAzkar: totalAzkar,
              azkarList: azkarList,
            );
          },
        ),

        GoRoute(
          path: '${AppRoutes.azkarDetail}/:${RouteParams.azkarId}',
          name: 'azkar-detail',
          builder: (context, state) {
            final azkarId = state.pathParameters[RouteParams.azkarId] ?? '0';
            return _buildPlaceholderPage('Azkar Detail', 'Azkar ID: $azkarId');
          },
        ),

        // Secondary routes
        GoRoute(
          path: AppRoutes.customAzkar,
          name: 'custom-azkar',
          builder: (context, state) =>
              _buildPlaceholderPage('Custom Azkar', 'Your personal azkar'),
        ),

        GoRoute(
          path: AppRoutes.addAzkar,
          name: 'add-azkar',
          builder: (context, state) =>
              _buildPlaceholderPage('Add Azkar', 'Create new azkar'),
        ),

        GoRoute(
          path: AppRoutes.reflection,
          name: 'reflection',
          builder: (context, state) =>
              _buildPlaceholderPage('Reflection', 'How do you feel now?'),
        ),

        GoRoute(
          path: AppRoutes.achievements,
          name: 'achievements',
          builder: (context, state) =>
              _buildPlaceholderPage('Achievements', 'Your milestones'),
        ),

        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) =>
              _buildPlaceholderPage('Profile', 'Your account'),
        ),

        // Utility routes
        GoRoute(
          path: AppRoutes.about,
          name: 'about',
          builder: (context, state) =>
              _buildPlaceholderPage('About', 'About Sakīnah'),
        ),

        GoRoute(
          path: AppRoutes.help,
          name: 'help',
          builder: (context, state) =>
              _buildPlaceholderPage('Help', 'How to use Sakīnah'),
        ),

        GoRoute(
          path: AppRoutes.feedback,
          name: 'feedback',
          builder: (context, state) =>
              _buildPlaceholderPage('Feedback', 'Share your thoughts'),
        ),
      ],

      // Error handling
      errorBuilder: (context, state) => _buildErrorPage(state.error.toString()),

      // Redirect logic
      redirect: (context, state) {
        // TODO: Add authentication checks
        // final isLoggedIn = context.read<AuthBloc>().state.isAuthenticated;
        // if (!isLoggedIn && !_isPublicRoute(state.location)) {
        //   return AppRoutes.login;
        // }
        return null; // No redirect
      },
    );
  }

  /// Build placeholder page for development
  static Widget _buildPlaceholderPage(String title, String subtitle) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.teal[100]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 64, color: Colors.teal[300]),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _navigateToTestRoute(),
              child: const Text('Navigate Test'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build main app shell with bottom navigation
  static Widget _buildMainShell(Widget child) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Build bottom navigation bar
  static Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.teal[50],
      selectedItemColor: Colors.teal[700],
      unselectedItemColor: Colors.grey[500],
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Progress',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) => _onBottomNavTap(index),
    );
  }

  /// Handle bottom navigation tap
  static void _onBottomNavTap(int index) {
    final context = _shellNavigatorKey.currentContext;
    if (context == null) return;

    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.progress);
        break;
      case 2:
        context.go(AppRoutes.settings);
        break;
    }
  }

  /// Navigate to mood selection for testing
  static void _navigateToTestRoute() {
    final context = _rootNavigatorKey.currentContext;
    if (context == null) return;

    context.push(AppRoutes.moodSelection);
  }

  /// Build error page
  static Widget _buildErrorPage(String error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Colors.red[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final context = _rootNavigatorKey.currentContext;
                if (context != null) {
                  context.go(AppRoutes.home);
                }
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation helper extensions
extension AppNavigation on BuildContext {
  /// Navigate to mood selection with optional mood parameter
  void goToMoodSelection({String? initialMood}) {
    if (initialMood != null) {
      go('${AppRoutes.moodSelection}?${RouteParams.mood}=$initialMood');
    } else {
      go(AppRoutes.moodSelection);
    }
  }

  /// Navigate to azkar display with mood
  void goToAzkarDisplay(String mood) {
    go('${AppRoutes.azkarDisplay}?${RouteParams.mood}=$mood');
  }

  /// Navigate to azkar detail with ID
  void goToAzkarDetail(int azkarId) {
    go('${AppRoutes.azkarDetail}/$azkarId');
  }

  /// Navigate to reflection with optional mood
  void goToReflection({String? mood}) {
    if (mood != null) {
      go('${AppRoutes.reflection}?${RouteParams.mood}=$mood');
    } else {
      go(AppRoutes.reflection);
    }
  }
}
