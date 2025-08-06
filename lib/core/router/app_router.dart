import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/core/theme/app_colors.dart';
import 'package:sakinah_app/features/mood/presentation/pages/mood_selection_page.dart';
import 'package:sakinah_app/features/mood/presentation/bloc/mood_bloc.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_display_page.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_categories_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_favorites_screen.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/progress/presentation/pages/progress_page.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:sakinah_app/features/settings/presentation/pages/settings_page.dart';
import 'package:sakinah_app/features/splash/presentation/pages/splash_screen.dart';

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
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      routes: [
        // Splash route
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
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

            // Azkar Categories route
            GoRoute(
              path: AppRoutes.azkarCategories,
              name: 'azkar-categories',
              builder: (context, state) => const AzkarScreen(),
            ),

            // Azkar Favorites route
            GoRoute(
              path: AppRoutes.azkarFavorites,
              name: 'azkar-favorites',
              builder: (context, state) => const AzkarFavoritesScreen(),
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
              builder: (context, state) => const SettingsPage(),
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

        // New azkar detail route
        GoRoute(
          path: '${AppRoutes.azkarDetailNew}/:${RouteParams.azkarId}',
          name: 'azkar-detail-new',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;

            // Handle both Azkar object and JSON map cases
            Azkar? azkar;
            final azkarData = extra?['azkar'];
            if (azkarData is Azkar) {
              azkar = azkarData;
            } else if (azkarData is Map<String, dynamic>) {
              azkar = Azkar.fromJson(azkarData);
            }

            // Handle both AzkarCategory object and JSON map cases
            AzkarCategory? category;
            final categoryData = extra?['category'];
            if (categoryData is AzkarCategory) {
              category = categoryData;
            } else if (categoryData is Map<String, dynamic>) {
              category = AzkarCategory.fromJson(categoryData);
            }

            final azkarIndex = extra?['azkarIndex'] as int? ?? 0;
            final totalAzkar = extra?['totalAzkar'] as int? ?? 1;

            // Handle azkarList which might be a list of maps
            List<Azkar>? azkarList;
            final azkarListData = extra?['azkarList'];
            if (azkarListData is List<Azkar>) {
              azkarList = azkarListData;
            } else if (azkarListData is List) {
              azkarList = azkarListData
                  .map(
                    (item) => item is Azkar
                        ? item
                        : Azkar.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
            }

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
      errorBuilder: (context, state) =>
          AppRouter._buildErrorPage(state.error.toString()),

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
              onPressed: () {
                final context = _rootNavigatorKey.currentContext;
                if (context != null) {
                  context.push(AppRoutes.moodSelection);
                }
              },
              child: const Text('Navigate Test'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build main app shell with bottom navigation
  static Widget _buildMainShell(Widget child) {
    return _MainShell(child: child);
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

/// Main shell widget with bottom navigation
class _MainShell extends StatefulWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).uri.path;
    setState(() {
      if (location == AppRoutes.settings) {
        _currentIndex = 0; // Settings is at array index 0
      } else if (location == AppRoutes.progress) {
        _currentIndex = 1; // Progress is at array index 1
      } else if (location == AppRoutes.azkarFavorites) {
        _currentIndex = 2; // Favorites is at array index 2
      } else if (location == AppRoutes.azkarCategories) {
        _currentIndex = 3; // Categories is at array index 3
      } else if (location == AppRoutes.home) {
        _currentIndex = 4; // Home is at array index 4 (rightmost)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildStyledBottomNavBar(context),
    );
  }

  Widget _buildStyledBottomNavBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // decoration: BoxDecoration(
      //   // gradient: LinearGradient(
      //   //   begin: Alignment.topCenter,
      //   //   end: Alignment.bottomCenter,
      //   //   colors: isDark
      //   //       ? [
      //   //           AppColors.darkBackground.withOpacity(0.9),
      //   //           AppColors.darkSurface.withOpacity(0.9),
      //   //         ]
      //   //       : [
      //   //           _getGradientColor(0).withOpacity(0.6),
      //   //           _getGradientColor(1).withOpacity(0.4),
      //   //         ],
      //   // ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: isDark
      //           ? Colors.black.withOpacity(0.3)
      //           : Colors.black.withOpacity(0.1),
      //       blurRadius: 10,
      //       offset: const Offset(0, -2),
      //     ),
      //   ],
      // ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.transparent,
        selectedItemColor: isDark
            ? AppColors.darkOnBackground
            : const Color(0xFF1A1A2E), // Navy blue dark text
        unselectedItemColor: isDark
            ? AppColors
                  .darkOnBackground // Full white for dark mode
            : const Color(0xFF1A1A2E).withOpacity(0.6),
        currentIndex: _currentIndex,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
        items: [
          _buildStyledNavItem(Icons.settings, 'الإعدادات', 5, context),
          _buildStyledNavItem(Icons.show_chart, 'التقدم', 4, context),
          _buildStyledNavItem(Icons.favorite, 'المفضلة', 3, context),
          _buildStyledNavItem(Icons.grid_view, 'الفئات', 2, context),
          _buildStyledNavItem(Icons.home, 'الرئيسية', 1, context),
        ],
        onTap: _onBottomNavTap,
      ),
    );
  }

  BottomNavigationBarItem _buildStyledNavItem(
    IconData iconData,
    String label,
    int index,
    BuildContext context,
  ) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          iconData,
          color: isSelected
              ? _getCategoryColorForTab(
                  index,
                ) // Category colors for active items in both modes
              : (isDark
                    ? Colors.white.withOpacity(
                        0.6,
                      ) // Muted white for inactive in dark mode
                    : const Color(0xFF1A1A2E).withOpacity(
                        0.6,
                      )), // Muted dark for inactive in light mode
          size: 22,
        ),
      ),
      label: label,
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Settings (الإعدادات) - tap index 0 -> custom index 5
        context.go(AppRoutes.settings);
        break;
      case 1:
        // Progress (التقدم) - tap index 1 -> custom index 4
        context.go(AppRoutes.progress);
        break;
      case 2:
        // Favorites (المفضلة) - tap index 2 -> custom index 3
        context.go(AppRoutes.azkarFavorites);
        break;
      case 3:
        // Categories (الفئات) - tap index 3 -> custom index 2
        context.go(AppRoutes.azkarCategories);
        break;
      case 4:
        // Home (الرئيسية) - tap index 4 -> custom index 1 (rightmost)
        context.go(AppRoutes.home);
        break;
    }
  }

  // Get gradient colors that match the azkar categories design
  Color _getGradientColor(int index) {
    final colors = [
      _getColorFromHex('#FBF8CC'), // Light yellow
      _getColorFromHex('#A3C4F3'), // Light blue
      _getColorFromHex('#FDE4CF'), // Light peach
      _getColorFromHex('#90DBF4'), // Light cyan
      _getColorFromHex('#98F5E1'), // Light mint
      _getColorFromHex('#B9FBC0'), // Light green
      _getColorFromHex('#FFCFD2'), // Light pink
      _getColorFromHex('#F1C0E8'), // Light purple
      _getColorFromHex('#CFBAF0'), // Light lavender
      _getColorFromHex('#8EECF5'), // Light turquoise
    ];
    return colors[index % colors.length];
  }

  Color _getCategoryColorForTab(int index) {
    switch (index) {
      case 1: // Home (rightmost - custom index 1)
        return _getColorFromHex(
          '#FFD93D',
        ); // Bright warm yellow like morning azkar
      case 2: // Categories (custom index 2)
        return _getColorFromHex(
          '#6FB3FF',
        ); // Vibrant soft blue like evening azkar
      case 3: // Favorites (center - custom index 3)
        return _getColorFromHex('#FF6B9D'); // Pink for favorites
      case 4: // Progress (custom index 4)
        return _getColorFromHex('#4ECDC4'); // Vibrant mint green for progress
      case 5: // Settings (leftmost - custom index 5)
        return _getColorFromHex('#95E1A3'); // Bright light green for settings
      default:
        return _getGradientColor(index);
    }
  }

  /// Helper method to convert hex color string to Color object
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add alpha channel
    }
    return Color(int.parse(hexColor, radix: 16));
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
    go('${AppRoutes.azkarDetailNew}/$azkarId');
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
