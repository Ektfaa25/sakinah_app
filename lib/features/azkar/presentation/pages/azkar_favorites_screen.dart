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

  Future<void> _debugFavoritesIssue() async {
    try {
      print('🧪 [Debug] Starting favorites debugging...');

      // Check database connection
      print('🧪 [Debug] Step 1: Testing database connection...');
      final connected = await AzkarDatabaseAdapter.testConnection();
      print('🧪 [Debug] Connection result: $connected');

      if (!connected) {
        throw Exception('Database connection failed');
      }

      // Get some azkar to test with
      print('🧪 [Debug] Step 2: Getting test azkar...');
      final categories = await AzkarDatabaseAdapter.getAzkarCategories();

      if (categories.isNotEmpty) {
        final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
          categories.first.id,
        );

        if (azkarList.isNotEmpty) {
          final testAzkar = azkarList.first;
          print('🧪 [Debug] Using test azkar: ${testAzkar.id}');

          // Add to favorites for testing
          print('🧪 [Debug] Step 3: Adding test azkar to favorites...');
          await AzkarDatabaseAdapter.addToFavorites(azkarId: testAzkar.id);
          print('🧪 [Debug] Added to favorites');

          // Test the adapter method
          final adapterResult = await AzkarDatabaseAdapter.getFavoriteAzkar();
          print('🧪 [Debug] Adapter result count: ${adapterResult.length}');

          // Refresh UI
          await _loadFavoriteAzkar();
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debug completed - check console'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('🧪 [Debug] Error: $e');
      print('🧪 [Debug] Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debug error: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.black87),
            onPressed: _debugFavoritesIssue,
            tooltip: 'Debug Test',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _loadFavoriteAzkar,
            tooltip: 'تحديث',
          ),
        ],
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A1A2E)),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحميل الأذكار المفضلة...',
            style: TextStyle(fontSize: 16, color: Color(0xFF1A1A2E)),
            textDirection: TextDirection.rtl,
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
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'حدث خطأ في تحميل الأذكار المفضلة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
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
                  color: const Color(0xFF1A1A2E),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
              child: ElevatedButton.icon(
                onPressed: _loadFavoriteAzkar,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  foregroundColor: Colors.white,
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
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.amber[700],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'لا توجد أذكار مفضلة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Text(
                'اضغط على أيقونة القلب في صفحة الذكر لإضافته للمفضلة',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF1A1A2E).withOpacity(0.7),
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
                onPressed: () => context.go(AppRoutes.azkarCategories),
                icon: const Icon(Icons.explore),
                label: const Text(
                  'تصفح الأذكار',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  foregroundColor: Colors.white,
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

  Widget _buildFavoritesList() {
    return RefreshIndicator(
      onRefresh: _loadFavoriteAzkar,
      color: const Color(0xFF1A1A2E),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _favoriteAzkar.length,
        itemBuilder: (context, index) {
          final azkar = _favoriteAzkar[index];
          return FadeInUp(
            duration: Duration(milliseconds: 600 + (index * 100)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildAzkarCard(azkar, index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAzkarCard(Azkar azkar, int index) {
    // Use the category color for this azkar as the border color
    Color borderColor = const Color(0xFFE91E63); // Default pink fallback

    // Try to get the actual category color
    try {
      // Parse the category color if available
      if (azkar.categoryId.isNotEmpty) {
        // We'll get the color from the category lookup in a FutureBuilder approach
        // For now, use a method to get category color synchronously if possible
        borderColor = _getCategoryColorForAzkar(azkar);
      }
    } catch (e) {
      print('⚠️ Error getting category color for azkar ${azkar.id}: $e');
      // Keep the default pink color
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: ListTile(
        onTap: () => _navigateToAzkarDetail(azkar, index),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(Icons.favorite, color: borderColor, size: 20),
        ),
        title: Text(
          azkar.textAr,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            height: 1.6,
          ),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (azkar.translation != null) ...[
              const SizedBox(height: 4),
              Text(
                azkar.translation!,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF1A1A2E).withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (azkar.repeatCount > 1) ...[
              const SizedBox(height: 4),
              Text(
                'يُكرر ${azkar.repeatCount} مرات',
                style: TextStyle(
                  fontSize: 11,
                  color: borderColor,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: borderColor, size: 16),
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

  // Helper method to get category color for an azkar
  Color _getCategoryColorForAzkar(Azkar azkar) {
    try {
      final category = _categoriesCache[azkar.categoryId];
      if (category != null && category.color != null) {
        // Parse hex color string to Color
        final colorString = category.color!.replaceAll('#', '');
        final colorValue = int.tryParse('FF$colorString', radix: 16);
        if (colorValue != null) {
          return Color(colorValue);
        }
      }
    } catch (e) {
      print('⚠️ Error parsing category color: $e');
    }

    // Fallback to pink color
    return const Color(0xFFE91E63);
  }

  // Create a fallback category with default properties that match the design
  AzkarCategory _createFallbackCategory() {
    return AzkarCategory(
      id: 'favorites',
      nameAr: 'المفضلة',
      nameEn: 'Favorites',
      description: 'Your favorite azkar',
      icon: 'favorite',
      color: '#E91E63', // Pink color to match favorites theme
      orderIndex: 0,
      isActive: true,
      createdAt: DateTime.now(),
    );
  }
}
