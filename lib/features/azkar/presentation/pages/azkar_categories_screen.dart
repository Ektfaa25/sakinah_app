import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/azkar_new.dart';
import '../../data/services/azkar_database_adapter.dart';

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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkTheme
              ? [
                  AppColors.darkBackground.withOpacity(0.9),
                  AppColors.darkSurface.withOpacity(0.9),
                ]
              : [
                  _getGradientColor(0).withOpacity(0.6),
                  _getGradientColor(1).withOpacity(0.4),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
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
          child: _buildCategoryCard(category, index),
        );
      },
    );
  }

  Widget _buildCategoryCard(AzkarCategory category, int index) {
    final color = _getGradientColor(index);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _onCategoryTap(category),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20), // Reduced padding from 24 to 20
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              16,
            ), // Increased border radius to match homepage
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.4), color.withOpacity(0.25)],
            ),
            border: Border.all(color: color.withOpacity(0.6), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(
                      alpha: 0.3,
                    ), // Darker border using card color
                    width: 4,
                  ),
                ),
                child: Icon(
                  _getIconForCategory(category),
                  size: 22, // Slightly smaller icon
                  color: Color.lerp(
                    color,
                    Colors.black,
                    0.4,
                  ), // Darker shade of the same color
                ),
              ),
              const SizedBox(height: 6), // Reduced spacing from 8 to 6
              Flexible(
                // Wrap text in Flexible to prevent overflow
                child: Text(
                  category.nameAr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for better visibility
                    fontSize: 11, // Slightly smaller font size
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
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

  // Get gradient colors that match the home page design
  Color _getGradientColor(int index) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final darkColors = [
      _getColorFromHex('#E8E2B8'), // Muted warm yellow
      _getColorFromHex('#9BB3D9'), // Muted soft blue
      _getColorFromHex('#E8CDB8'), // Muted warm peach
      _getColorFromHex('#89C5D9'), // Muted cyan
      _getColorFromHex('#94D9CC'), // Muted mint green
      _getColorFromHex('#B0D9B8'), // Muted light green
      _getColorFromHex('#D9B8BC'), // Muted light pink
      _getColorFromHex('#D4B8D1'), // Muted light purple
      _getColorFromHex('#C2A8D4'), // Muted light lavender
      _getColorFromHex('#7FC4D9'), // Muted light turquoise
    ];

    final lightColors = [
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

    final colors = isDarkTheme ? darkColors : lightColors;
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
