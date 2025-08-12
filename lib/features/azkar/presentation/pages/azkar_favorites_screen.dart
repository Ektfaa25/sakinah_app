import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
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
      print(
        '📋 [Favorites] Available category IDs: ${_categoriesCache.keys.toList()}',
      );

      // Add debugging info
      print('🔍 [Favorites] Calling AzkarDatabaseAdapter.getFavoriteAzkar()');
      final favoriteAzkar = await AzkarDatabaseAdapter.getFavoriteAzkar();
      print(
        '✅ [Favorites] Received ${favoriteAzkar.length} favorite azkar from database',
      );

      // Log each favorite for debugging and check for missing categories
      if (favoriteAzkar.isNotEmpty) {
        print('📋 [Favorites] List of favorites with category check:');
        for (int i = 0; i < favoriteAzkar.length; i++) {
          final azkar = favoriteAzkar[i];
          final categoryExists = _categoriesCache.containsKey(azkar.categoryId);
          print('  ${i + 1}. ID: ${azkar.id}');
          print(
            '     CategoryId: ${azkar.categoryId} ${categoryExists ? "✅" : "❌ NOT FOUND"}',
          );
          print(
            '     Text: ${azkar.textAr.length > 50 ? azkar.textAr.substring(0, 50) + '...' : azkar.textAr}',
          );

          if (!categoryExists) {
            print(
              '     ⚠️ Category ${azkar.categoryId} not found in available categories!',
            );
          }
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
        // Remove the boxShadow to eliminate navigation shadows
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
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
              color: Theme.of(context).colorScheme.onBackground,
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
      ),
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
            'جاري تحميل الأذكار المفضلة...',
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
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
                          ? Colors.white
                          : const Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 8),
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

    // Debug logging to understand the issue
    if (category == null) {
      print('⚠️ [Favorites] Category not found for azkar:');
      print('  - Azkar ID: ${azkar.id}');
      print('  - CategoryId: ${azkar.categoryId}');
      print(
        '  - Available categories in cache: ${_categoriesCache.keys.toList()}',
      );
    }

    // Get category name with better fallback
    String categoryName;
    if (category != null) {
      categoryName = category.nameAr;
    } else {
      // Provide better fallback based on categoryId
      categoryName = _getFallbackCategoryName(azkar.categoryId);
    }

    // Get category color using the same system as home page
    final categoryColor = _getCategoryCardColor(azkar.categoryId);

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
              categoryColor.withOpacity(
                0.8,
              ), // Use category color for border gradient
              categoryColor.withOpacity(0.5), // Medium opacity
              Colors.transparent, // Fade to transparent on the left
            ],
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(2), // Create space for border
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? null
                : Colors.white, // White background for light mode
            gradient: theme.brightness == Brightness.dark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.darkSurface,
                      AppColors.darkSurface.withOpacity(0.8),
                    ],
                  )
                : null, // No gradient for light mode, use solid white
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: categoryColor.withOpacity(
                  0.04,
                ), // Use category color for shadow
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? categoryColor.withOpacity(
                      0.1,
                    ) // Use category color for border
                  : categoryColor.withOpacity(
                      0.2,
                    ), // Use category color for border
              width: 1,
            ),
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

                  // Bismillah
                  const SizedBox(height: 8),

                  // Arabic text
                  Text(
                    azkar.textAr,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'AmiriQuran',
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
      color: '#E8A87C', // Warm coral color to match defaults
      orderIndex: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  // Helper function to get fallback category name based on categoryId
  String _getFallbackCategoryName(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return 'أذكار الصباح';
      case 'evening':
        return 'أذكار المساء';
      case 'waking_up':
        return 'أذكار الاستيقاظ';
      case 'sleep':
        return 'أذكار النوم';
      case 'prayer_before_salam':
        return 'أذكار الصلاة';
      case 'after_prayer':
        return 'أذكار بعد الصلاة';
      case 'travel':
        return 'أذكار السفر';
      case 'eating':
        return 'أذكار الطعام';
      case 'istighfar':
      case 'istighfar_tawbah':
        return 'الاستغفار';
      case 'tasbih':
      case 'dhikr_general':
        return 'التسبيح';
      case 'dua':
      case 'dua_times_places':
        return 'الأدعية';
      case 'quran':
        return 'القرآن الكريم';
      case 'ruqyah':
      case 'ruqyah_sunnah':
      case 'ruqyah_quran':
        return 'الرقية الشرعية';
      case 'protection':
        return 'أذكار الحماية';
      case 'home':
        return 'أذكار البيت';
      case 'work':
        return 'أذكار العمل';
      case 'rain':
        return 'أذكار المطر';
      case 'wind':
        return 'أذكار الريح';
      case 'general':
        return 'أذكار عامة';
      case 'adhan_dhikr':
        return 'أذكار الآذان';
      case 'sujood_dua':
        return 'دعاء السجود';
      case 'ruku_dua':
        return 'دعاء الركوع';
      case 'opening_dua':
        return 'دعاء الاستفتاح';
      case 'after_wudu':
        return 'أذكار الوضوء';
      case 'salawat_virtue':
        return 'الصلاة على النبي';
      case 'funeral_prayer':
        return 'دعاء الجنازة';
      case 'distress_dua':
        return 'دعاء الكرب';
      case 'spreading_salam':
        return 'إفشاء السلام';
      case 'rising_from_ruku':
        return 'دعاء الرفع من الركوع';
      case 'meeting_enemy_authority':
        return 'دعاء لقاء العدو';
      default:
        print('⚠️ [Favorites] Unknown categoryId: $categoryId');
        return 'فئة غير معروفة ($categoryId)';
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

      // Additional categories with extended color palette
      case 'general':
      case 'dhikr_general':
      case 'tasbih':
        return isDarkTheme
            ? const Color(0xFFE8A87C) // Warm coral for dark theme
            : const Color(0xFFF5C2A3); // Light coral for light theme
      case 'istighfar':
      case 'istighfar_tawbah':
        return isDarkTheme
            ? const Color(0xFFC9A9DD) // Light purple for dark theme
            : const Color(0xFFE0C3F7); // Very light purple for light theme
      case 'ruqyah_sunnah':
      case 'ruqyah_quran':
      case 'ruqyah':
        return isDarkTheme
            ? const Color(0xFF87D3C4) // Mint green for dark theme
            : const Color(0xFFAAE5D7); // Light mint for light theme
      case 'travel':
        return isDarkTheme
            ? const Color(0xFFFFB4A2) // Salmon pink for dark theme
            : const Color(0xFFFFCDBA); // Light salmon for light theme
      case 'eating':
        return isDarkTheme
            ? const Color(0xFFB5A7E6) // Periwinkle blue for dark theme
            : const Color(0xFFCFC3F0); // Light periwinkle for light theme
      case 'dua':
      case 'dua_times_places':
        return isDarkTheme
            ? const Color(0xFFFFC3A0) // Apricot for dark theme
            : const Color(0xFFFFD6BA); // Light apricot for light theme
      default:
        // For unknown categories, use a default color
        return isDarkTheme
            ? const Color(0xFFA8E6CF) // Pale green for dark theme
            : const Color(0xFFC5F2E2); // Very pale green for light theme
    }
  }
}
