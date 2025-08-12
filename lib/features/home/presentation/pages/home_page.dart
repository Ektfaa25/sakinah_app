import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/core/theme/app_colors.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
import 'package:sakinah_app/features/azkar/presentation/widgets/azkar_category_card.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Current week offset (0 = current week, -1 = last week, etc.)
  int _weekOffset = 0;
  final PageController _weekPageController = PageController(
    initialPage: 1000,
  ); // Start at a high number to allow backward scrolling

  // Week navigation indicator visibility
  bool _showWeekIndicator = false;
  Timer? _weekIndicatorTimer;

  // Azkar categories state
  List<AzkarCategory> _categories = [];
  bool _isLoadingCategories = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoadingCategories = true;
      });

      final categories = await AzkarDatabaseAdapter.getAzkarCategories();

      if (mounted) {
        setState(() {
          _categories = categories; // Load all categories for filtering
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      print('❌ Error loading categories: $e');
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  /// Get filtered categories to show only specific ones on homepage
  List<AzkarCategory> _getFilteredCategories() {
    // Specific category IDs to show on homepage in order
    final targetCategoryIds = [
      'morning', // أذكار الصباح
      'evening', // أذكار المساء
      'sleep', // أذكار النوم
      'waking_up', // أذكار الاستيقاظ (wake up)
      'opening_dua', // دعاء الاستفتاح (prayer opening)
      'after_prayer', // أذكار بعد الصلاة (after prayer)
    ];

    List<AzkarCategory> filteredCategories = [];

    // Get categories in the specified order
    for (String categoryId in targetCategoryIds) {
      final category = _categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => _createFallbackCategory(categoryId),
      );
      if (category.id.isNotEmpty) {
        filteredCategories.add(category);
      }
    }

    return filteredCategories;
  }

  /// Create fallback category if not found in database
  AzkarCategory _createFallbackCategory(String categoryId) {
    final now = DateTime.now();

    switch (categoryId) {
      case 'morning':
        return AzkarCategory(
          id: 'morning',
          nameAr: 'أذكار الصباح',
          nameEn: 'Morning Azkar',
          description: 'Morning remembrance',
          icon: 'morning',
          color: '#FFFBCC',
          orderIndex: 1,
          isActive: true,
          createdAt: now,
        );
      case 'evening':
        return AzkarCategory(
          id: 'evening',
          nameAr: 'أذكار المساء',
          nameEn: 'Evening Azkar',
          description: 'Evening remembrance',
          icon: 'evening',
          color: '#CCE7FF',
          orderIndex: 2,
          isActive: true,
          createdAt: now,
        );
      case 'sleep':
        return AzkarCategory(
          id: 'sleep',
          nameAr: 'أذكار النوم',
          nameEn: 'Sleep Azkar',
          description: 'Sleep remembrance',
          icon: 'sleep',
          color: '#90DBF4',
          orderIndex: 3,
          isActive: true,
          createdAt: now,
        );
      case 'waking_up':
        return AzkarCategory(
          id: 'waking_up',
          nameAr: 'أذكار الاستيقاظ',
          nameEn: 'Waking Up Azkar',
          description: 'Waking up remembrance',
          icon: 'waking_up',
          color: '#FFE4C4',
          orderIndex: 4,
          isActive: true,
          createdAt: now,
        );
      case 'opening_dua':
        return AzkarCategory(
          id: 'opening_dua',
          nameAr: 'اذكار الصلاه',
          nameEn: 'Prayer Azkar',
          description: 'Prayer remembrance',
          icon: 'prayer',
          color: '#98F5E1',
          orderIndex: 5,
          isActive: true,
          createdAt: now,
        );
      case 'after_prayer':
        return AzkarCategory(
          id: 'after_prayer',
          nameAr: 'أذكار بعد الصلاة',
          nameEn: 'After Prayer Azkar',
          description: 'After prayer remembrance',
          icon: 'after_prayer',
          color: '#B9FBC0',
          orderIndex: 6,
          isActive: true,
          createdAt: now,
        );
      default:
        return AzkarCategory(
          id: '',
          nameAr: '',
          nameEn: '',
          description: '',
          icon: '',
          color: '#FFFFFF',
          orderIndex: 0,
          isActive: false,
          createdAt: now,
        );
    }
  }

  // Helper function to get card color based on category ID (same as azkar categories screen)
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
      case 'opening_dua':
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
        return _getAlternativeGradientColor(
          categoryId.hashCode % 12,
        ); // Increased from 6 to 12 for more variety
    }
  }

  // Get gradient colors with more variety for azkar categories
  Color _getAlternativeGradientColor(int index) {
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
    ];

    final colors = isDarkTheme ? darkColors : lightColors;
    return colors[index % colors.length];
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
      return Icons.auto_awesome; // Love/gratitude azkar
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

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'nights_stay':
        return Icons.nights_stay;
      case 'bedtime':
        return Icons.bedtime;
      case 'light_mode':
        return Icons.light_mode;
      case 'mosque':
        return Icons.mosque;
      case 'check_circle':
        return Icons.check_circle;
      case 'flight':
        return Icons.flight;
      case 'restaurant':
        return Icons.restaurant;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'healing':
        return Icons.healing;
      case 'shield':
        return Icons.shield;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'volunteer_activism':
        return Icons.volunteer_activism;
      case 'book':
        return Icons.book;
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'cloudy_snowing':
        return Icons.cloudy_snowing;
      case 'air':
        return Icons.air;
      case 'menu_book':
      default:
        return Icons.menu_book;
    }
  }

  @override
  void dispose() {
    _weekPageController.dispose();
    _weekIndicatorTimer?.cancel();
    super.dispose();
  }

  void _showWeekIndicatorTemporarily() {
    setState(() {
      _showWeekIndicator = true;
    });

    // Cancel existing timer if any
    _weekIndicatorTimer?.cancel();

    // Hide the indicator after 2 seconds
    _weekIndicatorTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showWeekIndicator = false;
        });
      }
    });
  }

  /// Navigate directly to the first azkar of a category
  void _navigateToAzkarDetail(BuildContext context, String categoryId) async {
    try {
      // Fetch the actual category from database to ensure consistency
      final categories = await AzkarDatabaseAdapter.getAzkarCategories();
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => _createCategoryFromId(categoryId)!,
      );

      // Fetch azkar for the category
      final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
        categoryId,
      );

      if (azkarList.isNotEmpty && context.mounted) {
        // Navigate to the first azkar in the category
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
      } else if (context.mounted) {
        // Show error if no azkar found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No azkar found for this category')),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading azkar: $e')));
      }
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

  /// Get color for mood
  Color _getMoodColor(String moodName) {
    switch (moodName.toLowerCase()) {
      case 'happy':
        return const Color(0xFFFFD54F); // Warm yellow
      case 'sad':
        return const Color(0xFF64B5F6); // Soft blue
      case 'anxious':
        return const Color(0xFFFFB74D); // Orange
      case 'grateful':
        return const Color(0xFF81C784); // Green
      case 'stressed':
        return const Color(0xFFE57373); // Red
      case 'peaceful':
        return const Color(0xFF90CAF9); // Light blue
      default:
        return const Color(0xFF90CAF9);
    }
  }

  /// Create a temporary AzkarCategory object from category ID
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
          color: '#FFF3C4', // Light yellow
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
          color: '#C4E1FF', // Light blue
          orderIndex: 2,
          isActive: true,
          createdAt: now,
        );
      case 'waking_up':
        return AzkarCategory(
          id: 'waking_up',
          nameAr: 'أذكار الاستيقاظ',
          nameEn: 'Waking Up Azkar',
          description: 'Remembrance upon waking up',
          icon: 'waking_up',
          color: '#FFE4C4', // Light peach
          orderIndex: 3,
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
          color: '#C4F0FF', // Light cyan
          orderIndex: 4,
          isActive: true,
          createdAt: now,
        );
      case 'opening_dua':
        return AzkarCategory(
          id: 'opening_dua',
          nameAr: 'اذكار الصلاه',
          nameEn: 'Prayer Azkar',
          description: 'Prayer remembrance',
          icon: 'prayer',
          color: '#C4FFD4', // Light mint
          orderIndex: 5,
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
          color: '#D4FFD4', // Light green
          orderIndex: 6,
          isActive: true,
          createdAt: now,
        );
      // Additional categories using other colors from the image
      case 'istighfar_tawbah':
        return AzkarCategory(
          id: 'istighfar_tawbah',
          nameAr: 'الاستغفار والتوبة',
          nameEn: 'Istighfar & Tawbah',
          description: 'Seeking forgiveness and repentance',
          icon: 'istighfar',
          color: '#FFCFD2', // Additional color from image
          orderIndex: 7,
          isActive: true,
          createdAt: now,
        );
      case 'dhikr_general':
        return AzkarCategory(
          id: 'dhikr_general',
          nameAr: 'التسبيح والتحميد',
          nameEn: 'General Dhikr',
          description: 'General remembrance of Allah',
          icon: 'dhikr',
          color: '#F1C0E8', // Additional color from image
          orderIndex: 8,
          isActive: true,
          createdAt: now,
        );
      case 'ruqyah_sunnah':
        return AzkarCategory(
          id: 'ruqyah_sunnah',
          nameAr: 'الرقية بالسنة',
          nameEn: 'Ruqyah from Sunnah',
          description: 'Spiritual healing from Sunnah',
          icon: 'ruqyah',
          color: '#CFBAF0', // Additional color from image
          orderIndex: 9,
          isActive: true,
          createdAt: now,
        );
      case 'ruqyah_quran':
        return AzkarCategory(
          id: 'ruqyah_quran',
          nameAr: 'الرقية بالقرآن',
          nameEn: 'Ruqyah from Quran',
          description: 'Spiritual healing from Quran',
          icon: 'quran',
          color: '#8EECF5', // Additional color from image
          orderIndex: 10,
          isActive: true,
          createdAt: now,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl, // Force RTL for entire page
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
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
                    offset: const Offset(0, 2), // Reduced from 4
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weekly progress tracker at the top (no spacing)
                  _buildDateTracker(context),

                  // Add spacing after progress tracker
                  const SizedBox(height: 24),
                  // Quick mood selection section (no horizontal padding)
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كيف تشعر الآن؟', // How do you feel now?
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.onBackground, // Use theme text color
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                        const SizedBox(height: 16),
                        // Horizontal mood selector
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            reverse:
                                false, // Normal LTR scrolling to show happy on the right
                            itemCount: 6, // Show first 6 moods
                            itemBuilder: (context, index) {
                              final moods = [
                                {
                                  'name': 'happy',
                                  'emoji': '😊',
                                  'nameAr': 'سعيد',
                                },
                                {
                                  'name': 'sad',
                                  'emoji': '😔',
                                  'nameAr': 'حزين',
                                },
                                {
                                  'name': 'anxious',
                                  'emoji': '😰',
                                  'nameAr': 'قلق',
                                },
                                {
                                  'name': 'grateful',
                                  'emoji': '🙏',
                                  'nameAr': 'شاكر',
                                },
                                {
                                  'name': 'stressed',
                                  'emoji': '😤',
                                  'nameAr': 'متوتر',
                                },
                                {
                                  'name': 'peaceful',
                                  'emoji': '😌',
                                  'nameAr': 'مطمئن',
                                },
                              ];

                              final mood = moods[index];
                              return Container(
                                key: ValueKey('mood_${mood['name']}'),
                                width: 65,
                                margin: const EdgeInsets.only(right: 12),
                                child: GestureDetector(
                                  onTap: () => context.push(
                                    '${AppRoutes.azkarDisplay}?mood=${mood['name']}',
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _getMoodColor(
                                        mood['name'] as String,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _getMoodColor(
                                          mood['name'] as String,
                                        ).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          mood['emoji'] as String,
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          mood['nameAr'] as String,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: _getMoodColor(
                                              mood['name'] as String,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rest of content with horizontal padding
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),

                        // Azkar categories section with + and heart icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الاذكار', // Azkar
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground, // Use theme text color
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            // Group of icons (plus and heart)
                            Row(
                              children: [
                                // Small + icon button to show all categories
                                GestureDetector(
                                  onTap: () =>
                                      context.go(AppRoutes.azkarCategories),
                                  child: Text(
                                    'عرض الكل',
                                    // Azkar
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      height: 1.5,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface, // Use theme text color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Azkar category cards - now using a fixed height container
                        SizedBox(
                          height:
                              600, // Increased height to show all 6 cards (3 rows)
                          child: GridView.count(
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable internal scrolling
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: _isLoadingCategories
                                ? List.generate(
                                    6,
                                    (index) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : _getFilteredCategories()
                                      .map(
                                        (category) => AzkarCategoryCard(
                                          key: ValueKey(category.id),
                                          category: category,
                                          icon: _getIconForCategory(category),
                                          color: _getCategoryCardColor(
                                            category.id,
                                          ),
                                          onTap: () => _navigateToAzkarDetail(
                                            context,
                                            category.id,
                                          ),
                                        ),
                                      )
                                      .toList(),
                          ),
                        ),

                        // Demo button for AzkarCard widget
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                context.push(AppRoutes.azkarCardDemo),
                            icon: const Icon(Icons.credit_card, size: 20),
                            label: const Text(
                              'عرض بطاقة الأذكار التفاعلية',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } // Date tracker widget methods

  Widget _buildDateTracker(BuildContext context) {
    // Try to get the ProgressBloc from context, but don't require it
    try {
      context.read<ProgressBloc>();
      // If ProgressBloc is available, use it with BlocBuilder
      return BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          return _buildDateTrackerContent(context, state);
        },
      );
    } catch (e) {
      // If no ProgressBloc, use mock data
      return _buildDateTrackerContent(context, null);
    }
  }

  Widget _buildDateTrackerContent(BuildContext context, ProgressState? state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Use theme surface color
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ), // Use theme outline color
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.end, // Align to the right for RTL
        textDirection: TextDirection.rtl, // RTL for the entire column
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align to the right for RTL
            textDirection: TextDirection.rtl, // RTL for the entire row
            children: [
              Text(
                'التقدم الأسبوعي', // Weekly Progress in Arabic
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface, // Use theme text color
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getGradientColor(2).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_view_week_rounded,
                  color: _getGradientColor(2),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Scrollable week view
          SizedBox(
            height: 60, // Fixed height for the week indicators
            child: PageView.builder(
              controller: _weekPageController,
              onPageChanged: (index) {
                setState(() {
                  _weekOffset =
                      index - 1000; // Convert page index to week offset
                });
                // Show the week indicator temporarily when scrolling
                _showWeekIndicatorTemporarily();
              },
              itemBuilder: (context, pageIndex) {
                final weekOffset =
                    pageIndex - 1000; // Convert page index to week offset
                final today = DateTime.now();

                // Calculate week start from Sunday (RTL week start)
                // Sunday = 7, Monday = 1, so we need to adjust
                final daysFromSunday = today.weekday == 7 ? 0 : today.weekday;
                final weekStart = today.subtract(
                  Duration(days: daysFromSunday + (weekOffset * 7)),
                );

                // Generate 7 days starting from Sunday
                final weekDays = List.generate(7, (index) {
                  return weekStart.add(Duration(days: index));
                });

                return Container(
                  // Remove key to avoid potential conflicts in PageView.builder
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ), // Add horizontal padding between weeks
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl, // RTL for the entire row
                    children: weekDays.map((date) {
                      return Flexible(
                        child: _buildDayIndicator(context, date, state),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),

          // Week navigation indicator with conditional spacing
          AnimatedOpacity(
            opacity: _showWeekIndicator ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: _showWeekIndicator
                  ? null
                  : 0, // Remove height when hidden
              margin: EdgeInsets.only(
                top: _showWeekIndicator
                    ? 8
                    : 0, // Remove top margin when hidden
                bottom: _showWeekIndicator
                    ? 12
                    : 0, // Remove bottom margin when hidden
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_weekOffset == -1)
                    Text(
                      'الأسبوع القادم',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(
                              alpha: 0.6,
                            ), // Use theme text color with opacity
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  if (_weekOffset == 0)
                    Text(
                      'هذا الأسبوع',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getGradientColor(4),
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  if (_weekOffset == 1)
                    Text(
                      'الأسبوع الماضي',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(
                              alpha: 0.6,
                            ), // Use theme text color with opacity
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                ],
              ),
            ),
          ),

          // Color legend with conditional visibility
          AnimatedOpacity(
            opacity: _showWeekIndicator ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: _showWeekIndicator
                  ? null
                  : 0, // Remove height when hidden
              margin: EdgeInsets.only(
                top: _showWeekIndicator
                    ? 8
                    : 0, // Remove top margin when hidden
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl, // RTL for Arabic labels
                children: [
                  _buildLegendItem(
                    'غير مكتمل',
                    Colors.grey.shade300,
                  ), // Not completed
                  const SizedBox(width: 16),
                  _buildLegendItem('مكتمل', Colors.green.shade500), // Completed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayIndicator(
    BuildContext context,
    DateTime date,
    ProgressState? state,
  ) {
    final today = DateTime.now();
    final isToday =
        date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;

    // Get azkar completed for this date - use real data if available, otherwise mock
    int azkarCompleted;
    if (state != null) {
      if (isToday && state is TodayProgressLoaded) {
        azkarCompleted = state.progress.azkarCompleted;
      } else if (state is WeeklyProgressLoaded) {
        // Try to find this date in weekly progress
        final dayIndex = today.difference(date).inDays;
        if (dayIndex >= 0 && dayIndex < state.weeklyProgress.length) {
          azkarCompleted = state
              .weeklyProgress[state.weeklyProgress.length - 1 - dayIndex]
              .azkarCompleted;
        } else {
          azkarCompleted = _getMockAzkarForDate(date);
        }
      } else {
        azkarCompleted = _getMockAzkarForDate(date);
      }
    } else {
      // No state available, use mock data
      azkarCompleted = _getMockAzkarForDate(date);
    }

    final dailyGoal = 5;
    // Check if goal is completed for green circle
    final isGoalCompleted = azkarCompleted >= dailyGoal;
    // Use green circle for completed goals, gray for others
    final circleColor = isGoalCompleted
        ? Colors.green.shade500
        : Colors.grey.shade300;

    // Format day name in Arabic (RTL week starting from Sunday)
    final dayNames = [
      'الأحد', // Sunday (rightmost in RTL)
      'الإثنين', // Monday
      'الثلاثاء', // Tuesday
      'الأربعاء', // Wednesday
      'الخميس', // Thursday
      'الجمعة', // Friday
      'السبت', // Saturday (leftmost in RTL)
    ];

    // Map Flutter's weekday (1=Monday, 7=Sunday) to our RTL array (0=Sunday, 6=Saturday)
    final dayNameIndex = date.weekday == 7 ? 0 : date.weekday;
    final dayName = dayNames[dayNameIndex];

    return Column(
      // Only add key if needed for state preservation
      children: [
        Text(
          dayName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isToday
                ? _getGradientColor(4)
                : Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: 0.7,
                  ), // Use theme text color with opacity
          ),
          textDirection: TextDirection.rtl, // RTL for Arabic text
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: _getGradientColor(4), width: 2)
                : null,
            // Shadow removed for today's highlight
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isGoalCompleted
                    ? Colors.white
                    : const Color(0xFF1A1A2E).withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, {Color? borderColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl, // RTL for Arabic text
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: 0.7,
            ), // Use theme text color with opacity
            fontWeight: FontWeight.w500,
          ),
          textDirection: TextDirection.rtl, // RTL for Arabic text
        ),
      ],
    );
  }

  // Mock method to simulate azkar data for different dates
  // In real app, this would fetch from your progress data
  int _getMockAzkarForDate(DateTime date) {
    final today = DateTime.now();
    final daysDifference = today.difference(date).inDays;

    // Create varied patterns for different weeks
    final weeksSinceDate = (daysDifference / 7).floor();
    final dayOfWeek = date.weekday;

    // Current week pattern
    if (daysDifference >= 0 && daysDifference <= 6) {
      switch (daysDifference) {
        case 0:
          return 3; // Today - 3 azkar
        case 1:
          return 5; // Yesterday - completed
        case 2:
          return 2; // 2 days ago - 2 azkar
        case 3:
          return 0; // 3 days ago - not started
        case 4:
          return 4; // 4 days ago - 4 azkar
        case 5:
          return 5; // 5 days ago - completed
        case 6:
          return 1; // 6 days ago - 1 azkar
        default:
          return 0;
      }
    }

    // Previous weeks - create patterns based on week and day
    if (weeksSinceDate == 1) {
      // Last week - generally good progress
      return [5, 4, 5, 3, 5, 2, 4][dayOfWeek % 7];
    } else if (weeksSinceDate == 2) {
      // 2 weeks ago - moderate progress
      return [3, 2, 4, 1, 3, 5, 2][dayOfWeek % 7];
    } else if (weeksSinceDate == 3) {
      // 3 weeks ago - lower progress
      return [2, 1, 3, 0, 2, 1, 3][dayOfWeek % 7];
    } else if (weeksSinceDate >= 4) {
      // Older weeks - sporadic progress
      return [1, 0, 2, 0, 1, 0, 2][dayOfWeek % 7];
    }

    // Future dates
    return 0;
  }

  // Get gradient colors that match the azkar categories design
  Color _getGradientColor(int index) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final darkColors = [
      _getColorFromHex('#E8E2B8'), // Muted warm yellow
      _getColorFromHex('#9BB3D9'), // Muted soft blue
      _getColorFromHex('#E8CDB8'), // Muted warm peach
      _getColorFromHex('#89C5D9'), // Muted cyan
      const Color(0xFFE91E63), // Slightly lighter pink for today's highlight
      _getColorFromHex('#B0D9B8'), // Muted light green
      _getColorFromHex('#D9B8BC'), // Muted light pink
      _getColorFromHex('#D4B8D1'), // Muted light purple
      _getColorFromHex('#C2A8D4'), // Muted light lavender
      _getColorFromHex('#7FC4D9'), // Muted light turquoise
    ];

    final lightColors = [
      _getColorFromHex('#FBF8CC'), // Bright warm yellow
      _getColorFromHex('#A3C4F3'), // Bright soft blue
      _getColorFromHex('#FDE4CF'), // Bright warm peach
      _getColorFromHex('#90DBF4'), // Bright cyan
      const Color(0xFFE91E63), // Pink for today's highlight
      _getColorFromHex('#B9FBC0'), // Bright light green
      _getColorFromHex('#FFCFD2'), // Bright light pink
      _getColorFromHex('#F1C0E8'), // Bright light purple
      _getColorFromHex('#CFBAF0'), // Bright light lavender
      _getColorFromHex('#8EECF5'), // Bright light turquoise
    ];

    final colors = isDarkTheme ? darkColors : lightColors;
    return colors[index % colors.length];
  }
}
