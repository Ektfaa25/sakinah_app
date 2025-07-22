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
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_favorites_screen.dart';
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

/// Create a temporary AzkarCategory object from category ID for navigation
AzkarCategory? _createCategoryFromId(String categoryId) {
  final now = DateTime.now();

  switch (categoryId) {
    case 'morning':
      return AzkarCategory(
        id: 'morning',
        nameAr: 'أذكار الصباح',
        nameEn: 'Morning Azkar',
        description: 'Morning remembrance of Allah',
        icon: 'morning',
        color: '#FF9800',
        orderIndex: 1,
        isActive: true,
        createdAt: now,
      );
    case 'evening':
      return AzkarCategory(
        id: 'evening',
        nameAr: 'أذكار المساء',
        nameEn: 'Evening Azkar',
        description: 'Evening remembrance of Allah',
        icon: 'evening',
        color: '#3F51B5',
        orderIndex: 2,
        isActive: true,
        createdAt: now,
      );
    case 'sleep':
      return AzkarCategory(
        id: 'sleep',
        nameAr: 'أذكار النوم',
        nameEn: 'Sleep Azkar',
        description: 'Bedtime remembrance of Allah',
        icon: 'sleep',
        color: '#9C27B0',
        orderIndex: 3,
        isActive: true,
        createdAt: now,
      );
    case 'after_prayer':
      return AzkarCategory(
        id: 'after_prayer',
        nameAr: 'الأذكار بعد الصلاة',
        nameEn: 'After Prayer Azkar',
        description: 'Remembrance after prayer',
        icon: 'after_prayer',
        color: '#009688',
        orderIndex: 4,
        isActive: true,
        createdAt: now,
      );
    case 'istighfar_tawbah':
      return AzkarCategory(
        id: 'istighfar_tawbah',
        nameAr: 'الاستغفار والتوبة',
        nameEn: 'Istighfar & Tawbah',
        description: 'Seeking forgiveness and repentance',
        icon: 'istighfar',
        color: '#F44336',
        orderIndex: 5,
        isActive: true,
        createdAt: now,
      );
    default:
      return null;
  }
}

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

        // Azkar category route with category parameter
        GoRoute(
          path: '${AppRoutes.azkarCategory}/:${RouteParams.categoryId}',
          name: 'azkar-category',
          builder: (context, state) {
            final categoryId =
                state.pathParameters[RouteParams.categoryId] ?? '';

            // Create a temporary category object for now
            final category = _createCategoryFromId(categoryId);

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
      if (location == AppRoutes.home) {
        _currentIndex = 0;
      } else if (location == AppRoutes.azkarCategories) {
        _currentIndex = 1;
      } else if (location == AppRoutes.azkarFavorites) {
        _currentIndex = 2;
      } else if (location == AppRoutes.progress) {
        _currentIndex = 3;
      } else if (location == AppRoutes.settings) {
        _currentIndex = 4;
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getGradientColor(0).withOpacity(0.3),
            _getGradientColor(1).withOpacity(0.3),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF1A1A2E), // Navy blue dark text
          unselectedItemColor: const Color(0xFF1A1A2E).withOpacity(0.6),
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
            _buildStyledNavItem(Icons.home, 'الرئيسية', 0),
            _buildStyledNavItem(Icons.grid_view, 'الفئات', 1),
            _buildStyledNavItem(Icons.favorite, 'المفضلة', 2),
            _buildStyledNavItem(Icons.show_chart, 'التقدم', 3),
            _buildStyledNavItem(Icons.settings, 'الإعدادات', 4),
          ],
          onTap: _onBottomNavTap,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildStyledNavItem(
    IconData iconData,
    String label,
    int index,
  ) {
    final isSelected = _currentIndex == index;

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
              ? _getGradientColor(index)
              : const Color(0xFF1A1A2E).withOpacity(0.6),
          size: 22,
        ),
      ),
      label: label,
    );
  }

  void _onBottomNavTap(int index) {
    switch (index) {
      case 0:
        // Home
        context.go(AppRoutes.home);
        break;
      case 1:
        // All Categories (Azkar grid)
        context.go(AppRoutes.azkarCategories);
        break;
      case 2:
        // Favorites
        context.go(AppRoutes.azkarFavorites);
        break;
      case 3:
        // Progress
        context.go(AppRoutes.progress);
        break;
      case 4:
        // Settings (placeholder for now)
        _showComingSoonMessage('الإعدادات - قريباً');
        break;
    }
  }

  void _showComingSoonMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
