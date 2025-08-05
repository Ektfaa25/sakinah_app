import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/azkar_new.dart';
import '../../data/services/azkar_database_adapter.dart';

class AzkarFavoritesScreen extends StatefulWidget {
  const AzkarFavoritesScreen({super.key});

  @override
  State<AzkarFavoritesScreen> createState() => _AzkarFavoritesScreenState();
}

class _AzkarFavoritesScreenState extends State<AzkarFavoritesScreen>
    with TickerProviderStateMixin {
  List<Azkar> _favoriteAzkar = [];
  bool _isLoading = true;
  bool _isNavigating = false;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Cache for categories to avoid repeated database calls
  Map<String, AzkarCategory> _categoriesCache = {};

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadFavoriteAzkar();
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

  Future<void> _loadFavoriteAzkar() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('🔍 [Favorites] Starting to fetch favorite azkar...');

      // Load categories first to cache them
      final categories = await AzkarDatabaseAdapter.getAzkarCategories();
      _categoriesCache = {for (var cat in categories) cat.id: cat};
      print('✅ [Favorites] Cached ${_categoriesCache.length} categories');

      // Add debugging info
      print('🔍 [Favorites] Calling AzkarDatabaseAdapter.getFavoriteAzkar()');
      final favoriteAzkar = await AzkarDatabaseAdapter.getFavoriteAzkar();
      print(
        '✅ [Favorites] Received ${favoriteAzkar.length} favorite azkar from database',
      );

      // Log each favorite for debugging
      if (favoriteAzkar.isNotEmpty) {
        print('📋 [Favorites] List of favorites:');
        for (int i = 0; i < favoriteAzkar.length; i++) {
          final azkar = favoriteAzkar[i];
          print('  ${i + 1}. ID: ${azkar.id}');
          print(
            '     Text: ${azkar.textAr.length > 50 ? azkar.textAr.substring(0, 50) + '...' : azkar.textAr}',
          );
        }
      } else {
        print('💔 [Favorites] No favorites found in database');
      }

      if (mounted) {
        setState(() {
          _favoriteAzkar = favoriteAzkar;
          _isLoading = false;
        });
        print(
          '🎯 [Favorites] Updated UI state with ${_favoriteAzkar.length} favorites',
        );
      }
    } catch (e, stackTrace) {
      print('❌ [Favorites] Error loading favorite azkar: $e');
      print('❌ [Favorites] Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _error = 'خطأ في تحميل المفضلة: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0D1B2A)
          : const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: isDark ? const Color(0xFFE6F3FF) : const Color(0xFF2C2C2C),
          ),
          onPressed: () => context.go(AppRoutes.home),
          tooltip: 'رجوع',
        ),
        title: Text(
          'الأذكار المفضلة',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFE6F3FF) : const Color(0xFF1A1A1A),
          ),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? _buildLoadingState()
            : _error != null
            ? _buildErrorState()
            : _favoriteAzkar.isEmpty
            ? _buildEmptyState()
            : _buildFavoritesList(),
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1B2B41)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? const Color(0xFF64B5F6) : const Color(0xFF2196F3),
                ),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'جاري تحميل الأذكار المفضلة...',
              style: TextStyle(
                fontSize: 16,
                color: isDark
                    ? const Color(0xFFB3D9FF)
                    : const Color(0xFF666666),
                fontWeight: FontWeight.w500,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark
                        ? const Color(0xFFE53E3E).withOpacity(0.3)
                        : const Color(0xFFE53E3E).withOpacity(0.4),
                    isDark
                        ? const Color(0xFFE53E3E).withOpacity(0.2)
                        : const Color(0xFFE53E3E).withOpacity(0.25),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFFE53E3E).withOpacity(0.5)
                      : const Color(0xFFE53E3E).withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 50,
                color: isDark
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFFE53E3E),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Text(
              'حدث خطأ في تحميل الأذكار',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? const Color(0xFFE6F3FF)
                    : const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Text(
                _error!,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFFB3D9FF)
                      : const Color(0xFF666666),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          const SizedBox(height: 40),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 400),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    isDark ? const Color(0xFF64B5F6) : const Color(0xFF2196F3),
                    isDark
                        ? const Color(0xFF64B5F6).withOpacity(0.8)
                        : const Color(0xFF2196F3).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0xFF64B5F6).withOpacity(0.2)
                        : const Color(0xFF2196F3).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _loadFavoriteAzkar,
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.brightness == Brightness.dark
                        ? const Color(0xFFFF6B9D).withOpacity(0.3)
                        : const Color(0xFFFF6B9D).withOpacity(0.4),
                    theme.brightness == Brightness.dark
                        ? const Color(0xFFFF8E9B).withOpacity(0.2)
                        : const Color(0xFFFF8E9B).withOpacity(0.25),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFFFF6B9D).withOpacity(0.5)
                      : const Color(0xFFFF6B9D).withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 50,
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFFFF8E9B)
                    : const Color(0xFFFF6B9D),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Text(
              'لا توجد أذكار مفضلة بعد',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFFE6F3FF)
                    : const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 300),
            child: Text(
              'اضغط على أيقونة القلب في أي ذكر لإضافته إلى المفضلة\nوستجده هنا ليسهل الوصول إليه',
              style: TextStyle(
                fontSize: 16,
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFFB3D9FF)
                    : const Color(0xFF666666),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 400),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.brightness == Brightness.dark
                        ? const Color(0xFF64B5F6)
                        : const Color(0xFF2196F3),
                    theme.brightness == Brightness.dark
                        ? const Color(0xFF64B5F6).withOpacity(0.8)
                        : const Color(0xFF2196F3).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF64B5F6).withOpacity(0.2)
                        : const Color(0xFF2196F3).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.azkarCategories),
                icon: Icon(Icons.explore, color: Colors.white),
                label: Text(
                  'تصفح الأذكار',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'لديك ${_favoriteAzkar.length} من الأذكار المفضلة',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFFB3D9FF)
                          : const Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B9D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_favoriteAzkar.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF6B9D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Favorites list
          ...List.generate(_favoriteAzkar.length, (index) {
            final azkar = _favoriteAzkar[index];
            return FadeInUp(
              duration: Duration(milliseconds: 500 + (index * 100)),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildAzkarCard(azkar, index),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAzkarCard(Azkar azkar, int index) {
    final theme = Theme.of(context);
    // Get category information
    final category = _categoriesCache[azkar.categoryId];
    final categoryName = category?.nameAr ?? 'غير محدد';

    // Get category color or use default
    Color categoryColor = const Color(0xFFFF6B9D); // Default pink color
    if (category != null &&
        category.color != null &&
        category.color!.isNotEmpty) {
      try {
        // Parse the hex color from category
        final colorHex = category.color!.replaceAll('#', '');
        categoryColor = Color(int.parse('FF$colorHex', radix: 16));

        // Special handling for yellow color in light mode for better visibility
        if (theme.brightness == Brightness.light) {
          // Check if the color is yellow-ish (hue around 60 degrees)
          final hsl = HSLColor.fromColor(categoryColor);
          if (hsl.hue >= 45 && hsl.hue <= 75 && hsl.lightness > 0.7) {
            // Use a darker, more visible yellow for light mode
            categoryColor = const Color(0xFFD4A017); // Dark golden yellow
          }
        }
      } catch (e) {
        // Use default color if parsing fails
        categoryColor = const Color(0xFFFF6B9D);
      }
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: const [0.0, 0.05, 1.0],
            colors: [
              categoryColor, // Vibrant color on the right
              categoryColor.withOpacity(0.7), // Medium opacity
              Colors.transparent, // Fade to transparent on the left
            ],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(2), // Create space for border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: theme.brightness == Brightness.light
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF1B2B41),
          ),
          child: InkWell(
            onTap: () => _navigateToAzkarDetail(azkar, index),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Top row with heart icon and category chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Heart icon on the left
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B9D).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFFF6B9D),
                          size: 20,
                        ),
                      ),
                      // Category chip on the right
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 12,
                            color: categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Bismillah
                  const SizedBox(height: 8),

                  // Arabic text
                  Text(
                    azkar.textAr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFFE6F3FF)
                          : const Color(0xFF2C2C2C),
                      height: 1.6,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Translation section
                  if (azkar.translation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      azkar.translation!,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFFB3D9FF)
                            : const Color(0xFF666666),
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Repeat count if applicable
                  if (azkar.repeatCount > 1) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'تكرر ${azkar.repeatCount} مرات',
                          style: TextStyle(
                            fontSize: 10,
                            color: categoryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAzkarDetail(Azkar azkar, int index) async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    try {
      print('🔍 Navigating to AzkarDetailScreen from favorites');
      print('  - Azkar: ${azkar.textAr.substring(0, 50)}...');
      print('  - Azkar categoryId: ${azkar.categoryId}');

      // Get the actual category for this azkar using cached categories
      AzkarCategory? category;
      List<Azkar> categoryAzkarList = [];
      int azkarIndexInCategory = 0;

      try {
        // Use cached category first
        category = _categoriesCache[azkar.categoryId];
        if (category == null) {
          print(
            '⚠️ Category ${azkar.categoryId} not found in cache, using fallback',
          );
          category = _createFallbackCategory();
        } else {
          print(
            '✅ Found cached category: ${category.nameAr} with color: ${category.color}',
          );
        }

        // Get all azkar for this category to provide proper context
        categoryAzkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
          azkar.categoryId,
        );
        azkarIndexInCategory = categoryAzkarList.indexWhere(
          (a) => a.id == azkar.id,
        );
        if (azkarIndexInCategory == -1) azkarIndexInCategory = 0;

        print(
          '📝 Category has ${categoryAzkarList.length} azkar, current index: $azkarIndexInCategory',
        );
      } catch (e) {
        print('⚠️ Error loading category azkar, using fallback: $e');
        category = _createFallbackCategory();
        categoryAzkarList = [azkar]; // Fallback to just this azkar
        azkarIndexInCategory = 0;
      }

      // Navigate using the same route as categories screen with proper context
      if (mounted) {
        context.push(
          '${AppRoutes.azkarDetailNew}/${azkar.id}',
          extra: {
            'azkar': azkar,
            'category': category,
            'azkarIndex': azkarIndexInCategory,
            'totalAzkar': categoryAzkarList.length,
            'azkarList': categoryAzkarList,
          },
        );
      }

      // Refresh favorites list when returning (in case azkar was unfavorited)
      _loadFavoriteAzkar();
    } catch (e) {
      print('❌ Error navigating to azkar detail: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ في فتح الذكر: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  // Create a fallback category with default properties that match the design
  AzkarCategory _createFallbackCategory() {
    return AzkarCategory(
      id: 'favorites',
      nameAr: 'المفضلة',
      nameEn: 'Favorites',
      description: 'Your favorite azkar',
      icon: 'favorite',
      color: '#FF6B9D', // Pink color to match favorites theme
      orderIndex: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }
}
