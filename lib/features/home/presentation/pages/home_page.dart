import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
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
              // Weekly progress tracker at the top (no spacing)
              _buildDateTracker(context),

              // Add spacing after progress tracker
              const SizedBox(height: 24),
              // Quick mood selection section (no horizontal padding)
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'كيف تشعر الآن؟', // How do you feel now?
                      style: const TextStyle(
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
                        reverse: true, // Enable RTL scrolling
                        itemCount: 6, // Show first 6 moods
                        itemBuilder: (context, index) {
                          final moods = [
                            {'name': 'happy', 'emoji': '😊', 'nameAr': 'سعيد'},
                            {'name': 'sad', 'emoji': '😔', 'nameAr': 'حزين'},
                            {'name': 'anxious', 'emoji': '😰', 'nameAr': 'قلق'},
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        // Group of icons (plus and heart)
                        Row(
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
                          ],
                        ),
                        // Azkar title
                        Text(
                          'الاذكار', // Azkar
                          style: const TextStyle(
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
                            key: const ValueKey('morning'),
                            title: 'أذكار الصباح',
                            subtitle: 'Morning',
                            icon: Icons.wb_sunny,
                            color: _getColorFromHex(
                              '#FBF8CC',
                            ), // Back to original light yellow
                            categoryId: 'morning',
                            onTap: () =>
                                _navigateToAzkarDetail(context, 'morning'),
                          ),
                          _AzkarCategoryCard(
                            key: const ValueKey('evening'),
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
                            key: const ValueKey('waking_up'),
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
                            key: const ValueKey('sleep'),
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
                            key: const ValueKey('prayer_before_salam'),
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
                            key: const ValueKey('after_prayer'),
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

  // Date tracker widget methods
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
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
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
            height: 80, // Fixed height for the week indicators
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
                      return _buildDayIndicator(context, date, state);
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
                        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
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
                        color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
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
                : const Color(0xFF1A1A2E).withValues(alpha: 0.6),
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
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.6),
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
    final colors = [
      _getColorFromHex('#FBF8CC'), // Light yellow
      _getColorFromHex('#A3C4F3'), // Light blue
      _getColorFromHex('#FDE4CF'), // Light peach
      _getColorFromHex('#90DBF4'), // Light cyan
      const Color(0xFFE91E63), // Slightly lighter pink for today's highlight
      _getColorFromHex('#B9FBC0'), // Light green
      _getColorFromHex('#FFCFD2'), // Light pink
      _getColorFromHex('#F1C0E8'), // Light purple
      _getColorFromHex('#CFBAF0'), // Light lavender
      _getColorFromHex('#8EECF5'), // Light turquoise
    ];
    return colors[index % colors.length];
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
    super.key,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E), // Navy blue dark text
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
                style: const TextStyle(
                  color: Color(0xFF1A1A2E), // Navy blue dark text for subtitle
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
