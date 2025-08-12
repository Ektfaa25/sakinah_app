import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/azkar_new.dart';
import '../../data/services/azkar_database_adapter.dart';
import '../widgets/azkar_category_card.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen>
    with TickerProviderStateMixin {
  List<AzkarCategory> _categories = [];
  bool _isLoading = true;
  bool _isNavigating = false; // Add loading state for navigation
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadCategories();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Test connection first
      print('🔧 Testing Supabase connection...');
      final connectionTest = await AzkarDatabaseAdapter.testConnection();
      if (!connectionTest) {
        throw Exception('Failed to connect to Supabase');
      }
      print('✅ Supabase connection successful');

      print('🔍 Fetching azkar categories...');
      final categories = await AzkarDatabaseAdapter.getAzkarCategories();
      print('✅ Fetched ${categories.length} categories');

      for (final category in categories) {
        print(
          '📂 Category: ${category.id} - ${category.nameAr} (${category.nameEn ?? 'N/A'})',
        );
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading categories: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme ? null : Colors.white,
        gradient: isDarkTheme
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.darkBackground.withOpacity(0.9),
                  AppColors.darkSurface.withOpacity(0.9),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? Colors.black.withOpacity(0.15) // Reduced from 0.3
                : Colors.black.withOpacity(0.04), // Reduced from 0.1
            blurRadius: 6, // Reduced from 10
            offset: const Offset(0, -1), // Reduced from -2
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () => context.go(AppRoutes.home),
            tooltip: 'رجوع',
          ),
          title: Text(
            'الأذكار',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              FadeTransition(opacity: _fadeAnimation, child: _buildBody()),

              // Loading overlay when navigating
              if (_isNavigating)
                Container(
                  color: Theme.of(
                    context,
                  ).colorScheme.background.withOpacity(0.8),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'جاري تحميل الأذكار...',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_categories.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadCategories,
      color: const Color(0xFF1A1A2E), // Dark blue icon
      backgroundColor: Colors.grey[50], // Off-white background
      strokeWidth: 3.0,
      child: _buildCategoriesList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل الأذكار...',
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'حدث خطأ في تحميل الأذكار',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
              child: ElevatedButton.icon(
                onPressed: _loadCategories,
                icon: const Icon(Icons.refresh, color: Color(0xFF1A1A2E)),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(color: Color(0xFF1A1A2E)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[50],
                  foregroundColor: const Color(0xFF1A1A2E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.book_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'لا توجد فئات أذكار متاحة',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Text(
                'تحقق من اتصال الإنترنت وحاول مرة أخرى',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
              child: ElevatedButton.icon(
                onPressed: _loadCategories,
                icon: const Icon(Icons.refresh, color: Color(0xFF1A1A2E)),
                label: const Text(
                  'تحديث',
                  style: TextStyle(color: Color(0xFF1A1A2E)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[50],
                  foregroundColor: const Color(0xFF1A1A2E),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          delay: Duration(milliseconds: 100 * index),
          child: AzkarCategoryCard(
            category: category,
            color: _getCategoryCardColor(category.id),
            icon: _getIconForCategory(category),
            onTap: () => _onCategoryTap(category),
          ),
        );
      },
    );
  }

  void _onCategoryTap(AzkarCategory category) async {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Check if widget is still mounted and not already navigating
    if (!mounted || _isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    try {
      // Load azkar for this category
      print(
        '🔍 Loading azkar for category: ${category.nameAr} (ID: ${category.id})',
      );
      final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
        category.id,
      );

      // Check again if widget is still mounted after async operation
      if (!mounted) return;

      if (azkarList.isNotEmpty) {
        print(
          '✅ Successfully loaded ${azkarList.length} azkar for category: ${category.nameAr}',
        );
        print(
          '🚀 Navigating to AzkarDetailScreen with first azkar: ${azkarList.first.textAr.substring(0, 50)}...',
        );

        // Reset loading state before navigation
        setState(() {
          _isNavigating = false;
        });

        // Navigate to detail screen with first azkar using GoRouter
        context.push(
          '${AppRoutes.azkarDetailNew}/${azkarList.first.id}',
          extra: {
            'azkar': azkarList.first,
            'category': category,
            'azkarIndex': 0,
            'totalAzkar': azkarList.length,
            'azkarList': azkarList,
          },
        );
      } else {
        // Show error if no azkar found
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('لا توجد أذكار متاحة في هذه الفئة'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في تحميل الأذكار: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('❌ Error loading azkar for category: $e');
    } finally {
      // Always reset navigation state
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  // Helper function to get card color based on category ID (same as home page)
  Color _getCategoryCardColor(String categoryId) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    switch (categoryId) {
      case 'morning':
        return isDarkTheme
            ? const Color(0xFFE5C068) // Warmer golden beige for dark theme
            : const Color(0xFFF2D68A); // Light golden beige for light theme
      case 'evening':
        return isDarkTheme
            ? const Color(
                0xFF7BB3E0,
              ) // Soft blue with more color for dark theme
            : const Color(0xFF9BC7ED); // Light soft blue for light theme
      case 'waking_up':
        return isDarkTheme
            ? const Color(
                0xFFE6A67A,
              ) // Warm peach with more color for dark theme
            : const Color(0xFFF0BF9A); // Light warm peach for light theme
      case 'sleep':
        return isDarkTheme
            ? const Color(
                0xFFB68DC7,
              ) // Soft lavender with more color for dark theme
            : const Color(0xFFCBA8DC); // Light soft lavender for light theme
      case 'prayer_before_salam':
        return isDarkTheme
            ? const Color(
                0xFF8BC797,
              ) // Fresh sage green with more color for dark theme
            : const Color(0xFFA6D4B2); // Light fresh sage for light theme
      case 'after_prayer':
        return isDarkTheme
            ? const Color(
                0xFF7AC7D8,
              ) // Soft teal with more color for dark theme
            : const Color(0xFF9AD4E3); // Light soft teal for light theme
      default:
        // For categories not in home page, use a default color based on index
        return _getGradientColor(
          categoryId.hashCode % 12,
        ); // Increased from 6 to 12 for more variety
    }
  }

  // Get gradient colors with more variety for azkar categories
  Color _getGradientColor(int index) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final darkColors = [
      const Color(0xFFE5C068), // Golden beige (morning)
      const Color(0xFF7BB3E0), // Soft blue (evening)
      const Color(0xFFE6A67A), // Warm peach (waking up)
      const Color(0xFFB68DC7), // Soft lavender (sleep)
      const Color(0xFF8BC797), // Fresh sage green (prayer)
      const Color(0xFF7AC7D8), // Soft teal (after prayer)
      const Color(0xFFE8A87C), // Warm coral
      const Color(0xFFC9A9DD), // Light purple
      const Color(0xFF87D3C4), // Mint green
      const Color(0xFFFFB4A2), // Salmon pink
      const Color(0xFFB5A7E6), // Periwinkle blue
      const Color(0xFFFFC3A0), // Apricot
      const Color(0xFFA8E6CF), // Pale green
      const Color(0xFFFFD3E1), // Light pink
      const Color(0xFFC4E5F7), // Sky blue
      const Color(0xFFD4C5F9), // Lavender mist
    ];

    final lightColors = [
      const Color(0xFFF2D68A), // Light golden beige (morning)
      const Color(0xFF9BC7ED), // Light soft blue (evening)
      const Color(0xFFF0BF9A), // Light warm peach (waking up)
      const Color(0xFFCBA8DC), // Light soft lavender (sleep)
      const Color(0xFFA6D4B2), // Light fresh sage (prayer)
      const Color(0xFF9AD4E3), // Light soft teal (after prayer)
      const Color(0xFFF5C2A3), // Light coral
      const Color(0xFFE0C3F7), // Very light purple
      const Color(0xFFAAE5D7), // Light mint
      const Color(0xFFFFCDBA), // Light salmon
      const Color(0xFFCFC3F0), // Light periwinkle
      const Color(0xFFFFD6BA), // Light apricot
      const Color(0xFFC5F2E2), // Very pale green
      const Color(0xFFFFE5EC), // Very light pink
      const Color(0xFFDAF0FC), // Very light sky blue
      const Color(0xFFE8DFFC), // Very light lavender
    ];

    final colors = isDarkTheme ? darkColors : lightColors;
    return colors[index % colors.length];
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wb_sunny':
        return Icons.wb_sunny; // Morning sun
      case 'nights_stay':
        return Icons.nights_stay; // Evening/night
      case 'bedtime':
        return Icons.bedtime; // Sleep
      case 'light_mode':
        return Icons.light_mode; // Waking up
      case 'mosque':
        return Icons.mosque; // Prayer/mosque
      case 'check_circle':
        return Icons.check_circle; // After prayer completion
      case 'flight':
        return Icons.flight; // Travel
      case 'restaurant':
        return Icons.restaurant; // Eating/meals
      case 'favorite':
        return Icons
            .auto_awesome; // Love/gratitude (changed from heart to star)
      case 'spa':
        return Icons.spa; // Relaxation/dhikr
      case 'shield':
        return Icons.shield; // Protection
      case 'auto_awesome':
        return Icons.auto_awesome; // Beautiful names of Allah
      case 'self_improvement':
        return Icons.self_improvement; // Personal development/dhikr
      case 'nature':
        return Icons.nature; // Nature/creation
      case 'psychology':
        return Icons.psychology; // Reflection/contemplation
      case 'healing':
        return Icons.healing; // Healing/ruqyah
      case 'star':
        return Icons.star; // Special/blessed
      case 'book':
        return Icons.book; // Quran/reading
      case 'home':
        return Icons.home; // Home/family
      case 'work':
        return Icons.work; // Work/business
      case 'school':
        return Icons.school; // Learning/knowledge
      case 'celebration':
        return Icons.celebration; // Celebration/joy
      case 'handshake':
        return Icons.handshake; // Community/brotherhood
      case 'volunteer_activism':
        return Icons.volunteer_activism; // Charity/helping others
      case 'security':
        return Icons.security; // Safety/protection
      case 'health_and_safety':
        return Icons.health_and_safety; // Health/wellbeing
      case 'elderly':
        return Icons.elderly; // Elderly/respect
      case 'child_care':
        return Icons.child_care; // Children/family
      case 'directions_walk':
        return Icons.directions_walk; // Walking/journey
      case 'directions_car':
        return Icons.directions_car; // Vehicle/transportation
      case 'weather_sunny':
        return Icons.wb_sunny; // Weather/sun
      case 'cloudy_snowing':
        return Icons.cloudy_snowing; // Weather/rain
      case 'water_drop':
        return Icons.water_drop; // Water/purity
      case 'local_florist':
        return Icons.local_florist; // Nature/flowers
      case 'agriculture':
        return Icons.agriculture; // Agriculture/farming
      case 'menu_book':
      default:
        return Icons.menu_book; // Default book icon
    }
  }

  /// Get appropriate icon based on category name
  IconData _getIconForCategory(AzkarCategory category) {
    // First try to get icon from the category's icon name
    final iconFromName = _getIconData(category.getIconName());
    if (iconFromName != Icons.menu_book) {
      return iconFromName;
    }

    // If no specific icon found, determine based on Arabic name
    final nameAr = category.nameAr.toLowerCase();

    if (nameAr.contains('صباح')) {
      return Icons.wb_sunny; // Morning azkar
    } else if (nameAr.contains('مساء')) {
      return Icons.nights_stay; // Evening azkar
    } else if (nameAr.contains('نوم') || nameAr.contains('منام')) {
      return Icons.bedtime; // Sleep azkar
    } else if (nameAr.contains('استيقاظ') || nameAr.contains('يقظة')) {
      return Icons.light_mode; // Waking up azkar
    } else if (nameAr.contains('صلاة') || nameAr.contains('صلوات')) {
      return Icons.mosque; // Prayer azkar
    } else if (nameAr.contains('بعد الصلاة')) {
      return Icons.check_circle; // After prayer azkar
    } else if (nameAr.contains('سفر') || nameAr.contains('طريق')) {
      return Icons.flight; // Travel azkar
    } else if (nameAr.contains('طعام') || nameAr.contains('أكل')) {
      return Icons.restaurant; // Eating azkar
    } else if (nameAr.contains('حب') || nameAr.contains('محبة')) {
      return Icons
          .auto_awesome; // Love/gratitude azkar (changed from heart to star)
    } else if (nameAr.contains('رقية') || nameAr.contains('شفاء')) {
      return Icons.healing; // Ruqyah/healing azkar
    } else if (nameAr.contains('حماية') || nameAr.contains('حفظ')) {
      return Icons.shield; // Protection azkar
    } else if (nameAr.contains('أسماء') || nameAr.contains('حسنى')) {
      return Icons.auto_awesome; // Beautiful names of Allah
    } else if (nameAr.contains('تسبيح') || nameAr.contains('ذكر')) {
      return Icons.self_improvement; // Dhikr/tasbih
    } else if (nameAr.contains('استغفار')) {
      return Icons.volunteer_activism; // Istighfar
    } else if (nameAr.contains('دعاء')) {
      return Icons.volunteer_activism; // Dua
    } else if (nameAr.contains('قرآن')) {
      return Icons.book; // Quran
    } else if (nameAr.contains('بيت') || nameAr.contains('منزل')) {
      return Icons.home; // Home azkar
    } else if (nameAr.contains('عمل')) {
      return Icons.work; // Work azkar
    } else if (nameAr.contains('مطر')) {
      return Icons.cloudy_snowing; // Rain azkar
    } else if (nameAr.contains('ريح') || nameAr.contains('عاصفة')) {
      return Icons.air; // Wind azkar
    } else {
      return Icons.menu_book; // Default icon
    }
  }
}
