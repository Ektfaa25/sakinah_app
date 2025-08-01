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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.black87),
          onPressed: () => context.go(AppRoutes.home),
          tooltip: 'رجوع',
        ),
        title: Text(
          'الأذكار المفضلة',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
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
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A1A2E)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'جاري تحميل الأذكار المفضلة...',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
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
                    Colors.red.withOpacity(0.1),
                    Colors.orange.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Text(
              'حدث خطأ في تحميل الأذكار',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
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
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A2E), Color(0xFF2D2D42)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A1A2E).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _loadFavoriteAzkar,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
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
                    const Color(0xFFFF6B9D).withOpacity(0.1),
                    const Color(0xFFFF8E9B).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 50,
                color: Color(0xFFFF6B9D),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Text(
              'لا توجد أذكار مفضلة بعد',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
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
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A2E), Color(0xFF2D2D42)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A1A2E).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.azkarCategories),
                icon: const Icon(Icons.explore, color: Colors.white),
                label: const Text(
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
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
    // Use elegant color scheme
    Color primaryColor = const Color(0xFF1A1A2E);
    Color accentColor = const Color(0xFFFF6B9D);

    // Get category information
    final category = _categoriesCache[azkar.categoryId];
    final categoryName = category?.nameAr ?? 'غير محدد';

    // Get category color or use default
    Color categoryColor = accentColor; // Default color
    if (category != null &&
        category.color != null &&
        category.color!.isNotEmpty) {
      try {
        // Parse the hex color from category
        final colorHex = category.color!.replaceAll('#', '');
        categoryColor = Color(int.parse('FF$colorHex', radix: 16));
      } catch (e) {
        // Use default color if parsing fails
        categoryColor = accentColor;
      }
    }

    return GestureDetector(
      onTap: () => _navigateToAzkarDetail(azkar, index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border(right: BorderSide(color: categoryColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Header with heart icon and category title in same row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Heart icon on the left
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.favorite, color: accentColor, size: 20),
                  ),
                  // Category chip on the right
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: categoryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 12,
                        color: categoryColor.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Arabic text
              Text(
                azkar.textAr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  height: 1.8,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              if (azkar.translation != null) ...[
                const SizedBox(height: 12),
                Text(
                  azkar.translation!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Repeat count if applicable
              if (azkar.repeatCount > 1) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'يُكرر ${azkar.repeatCount} مرات',
                    style: TextStyle(
                      fontSize: 12,
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ],
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
