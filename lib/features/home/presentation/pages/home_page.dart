import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Navigate directly to the first azkar of a category
  void _navigateToAzkarDetail(BuildContext context, String categoryId) async {
    try {
      // Fetch azkar for the category
      final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
        categoryId,
      );

      if (azkarList.isNotEmpty && context.mounted) {
        // Create category object
        final category = _createCategoryFromId(categoryId);
        if (category != null) {
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
        }
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
      case 'prayer_before_salam':
        return AzkarCategory(
          id: 'prayer_before_salam',
          nameAr: 'أذكار الصلاة',
          nameEn: 'Prayer Azkar',
          description: 'Remembrance during prayer',
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content with horizontal padding (greeting and azkar sections)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Arabic greeting
                    Text(
                      'السلام عليكم',
                      style: GoogleFonts.playpenSans(
                        locale: const Locale('ar'),
                        fontSize: 32,
                        fontWeight: FontWeight.normal,
                        color: Colors
                            .black87, // Changed to black87 for better visibility
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    // English greeting
                    Text(
                      'Peace be upon you',
                      style: GoogleFonts.playpenSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors
                            .black87, // Changed to black87 for better visibility
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),

              // Quick mood selection section with card (no horizontal padding)
              Card(
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.1),
                margin: const EdgeInsets.symmetric(
                  vertical: 0,
                ), // Remove horizontal margin
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.grey.shade50.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'كيف تشعر الآن؟', // How do you feel now?
                        style: GoogleFonts.playpenSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 16),
                      // Horizontal mood selector
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6, // Show first 6 moods
                          itemBuilder: (context, index) {
                            final moods = [
                              {
                                'name': 'happy',
                                'emoji': '😊',
                                'nameAr': 'سعيد',
                              },
                              {'name': 'sad', 'emoji': '😔', 'nameAr': 'حزين'},
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        mood['emoji'] as String,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        mood['nameAr'] as String,
                                        style: GoogleFonts.playpenSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: _getMoodColor(
                                            mood['name'] as String,
                                          ),
                                        ),
                                        textDirection: TextDirection.rtl,
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
              ),

              // Rest of content with horizontal padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // Azkar categories section with + icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Small + icon button to show all categories
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () =>
                                context.push(AppRoutes.azkarCategories),
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.primary,
                              size: 16,
                            ),
                            padding: EdgeInsets.zero,
                            tooltip: 'المزيد من الأذكار',
                          ),
                        ),
                        // Azkar title
                        Text(
                          'الاذكار', // Azkar
                          style: GoogleFonts.playpenSans(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .black87, // Changed to black87 for better visibility
                          ),
                          textDirection: TextDirection.rtl,
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
                        children: [
                          _AzkarCategoryCard(
                            title: 'أذكار الصباح',
                            subtitle: 'Morning',
                            icon: Icons.wb_sunny,
                            color: _getColorFromHex(
                              '#FBF8CC',
                            ), // From image - light yellow
                            categoryId: 'morning',
                            onTap: () =>
                                _navigateToAzkarDetail(context, 'morning'),
                          ),
                          _AzkarCategoryCard(
                            title: 'أذكار المساء',
                            subtitle: 'Evening',
                            icon: Icons.nights_stay,
                            color: _getColorFromHex(
                              '#A3C4F3',
                            ), // From image - light blue
                            categoryId: 'evening',
                            onTap: () =>
                                _navigateToAzkarDetail(context, 'evening'),
                          ),
                          _AzkarCategoryCard(
                            title: 'أذكار الاستيقاظ',
                            subtitle: 'Waking Up',
                            icon: Icons.light_mode,
                            color: _getColorFromHex(
                              '#FDE4CF',
                            ), // From image - light peach
                            categoryId: 'waking_up',
                            onTap: () =>
                                _navigateToAzkarDetail(context, 'waking_up'),
                          ),
                          _AzkarCategoryCard(
                            title: 'أذكار النوم',
                            subtitle: 'Sleep',
                            icon: Icons.bedtime,
                            color: _getColorFromHex(
                              '#90DBF4',
                            ), // From image - light cyan
                            categoryId: 'sleep',
                            onTap: () =>
                                _navigateToAzkarDetail(context, 'sleep'),
                          ),
                          _AzkarCategoryCard(
                            title: 'أذكار الصلاة',
                            subtitle: 'During Prayer',
                            icon: Icons.mosque,
                            color: _getColorFromHex(
                              '#98F5E1',
                            ), // From image - light mint
                            categoryId: 'prayer_before_salam',
                            onTap: () => _navigateToAzkarDetail(
                              context,
                              'prayer_before_salam',
                            ),
                          ),
                          _AzkarCategoryCard(
                            title: 'أذكار بعد الصلاة',
                            subtitle: 'After Prayer',
                            icon: Icons.check_circle,
                            color: _getColorFromHex(
                              '#B9FBC0',
                            ), // From image - light green
                            categoryId: 'after_prayer',
                            onTap: () =>
                                _navigateToAzkarDetail(context, 'after_prayer'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AzkarCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? categoryId;
  final VoidCallback onTap;

  const _AzkarCategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.categoryId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ], // Use the actual color for better readability
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withOpacity(
                      0.3,
                    ), // Darker border using card color
                    width: 4,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color, // Use the original card color for the icon
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing
              Text(
                title,
                style: GoogleFonts.playpenSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E), // Navy blue dark text
                  fontSize: 12, // Smaller font size for card titles
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), // Reduced spacing
              Text(
                subtitle,
                style: GoogleFonts.playpenSans(
                  color: const Color(
                    0xFF1A1A2E,
                  ), // Navy blue dark text for subtitle
                  fontSize: 10, // Smaller font size for subtitles
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
