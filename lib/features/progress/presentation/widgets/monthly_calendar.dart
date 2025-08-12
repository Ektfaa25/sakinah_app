import 'package:flutter/material.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/core/storage/preferences_service.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
import '../../../../core/di/service_locator.dart';

class MonthlyCalendar extends StatefulWidget {
  final List<UserProgress> monthlyProgress;
  final DateTime? initialSelectedDate;

  const MonthlyCalendar({
    super.key,
    required this.monthlyProgress,
    this.initialSelectedDate,
  });

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime currentMonth;
  int? selectedDayIndex;

  @override
  void initState() {
    super.initState();
    // Set currentMonth to the month/year of the selected date, or current month
    if (widget.initialSelectedDate != null) {
      currentMonth = DateTime(
        widget.initialSelectedDate!.year,
        widget.initialSelectedDate!.month,
        1,
      );
      // Set selectedDayIndex to the day number minus 1 (day 1 = index 0, day 2 = index 1, etc.)
      selectedDayIndex = widget.initialSelectedDate!.day - 1;
    } else {
      currentMonth = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Month header with navigation
        _buildMonthHeader(context),
        const SizedBox(height: 16),

        // Days of week header (Arabic RTL)
        _buildDaysOfWeekHeader(context),
        const SizedBox(height: 12),

        // Calendar grid
        _buildCalendarGrid(context),

        // Selected day info
        if (selectedDayIndex != null) ...[
          const SizedBox(height: 16),
          _buildSelectedDayInfo(context),
        ],
      ],
    );
  }

  Widget _buildMonthHeader(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final monthNames = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        // Month and year (right side in RTL)
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Text(
              '${monthNames[currentMonth.month - 1]} ${currentMonth.year}',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : const Color(0xFF1A1A1A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_month,
              color: isDarkTheme ? Colors.white70 : Colors.grey[600],
              size: 20,
            ),
          ],
        ),

        // Navigation buttons (left side in RTL)
        Row(
          textDirection: TextDirection.rtl,
          children: [
            IconButton(
              onPressed: _goToNextMonth,
              icon: Icon(
                Icons.chevron_right,
                color: isDarkTheme ? Colors.white70 : Colors.grey[600],
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            IconButton(
              onPressed: _goToPreviousMonth,
              icon: Icon(
                Icons.chevron_left,
                color: isDarkTheme ? Colors.white70 : Colors.grey[600],
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDaysOfWeekHeader(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Arabic day names starting from Sunday (RTL layout)
    final dayNames = [
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      textDirection: TextDirection.rtl,
      children: dayNames.map((dayName) {
        return Expanded(
          child: Center(
            child: Text(
              dayName,
              style: TextStyle(
                color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final daysInMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);

    // Calculate starting day offset (Sunday = 0, Monday = 1, etc.)
    // Flutter weekday: Monday=1, Sunday=7, we want Sunday=0
    final firstWeekday = firstDayOfMonth.weekday == 7
        ? 0
        : firstDayOfMonth.weekday;

    // Total cells needed (including empty cells at start)
    final totalCells = ((daysInMonth + firstWeekday - 1) / 7).ceil() * 7;

    return Column(
      children: List.generate(
        (totalCells / 7).ceil(),
        (weekIndex) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            textDirection: TextDirection.rtl,
            children: List.generate(7, (dayIndex) {
              final cellIndex = weekIndex * 7 + dayIndex;
              final dayNumber = cellIndex - firstWeekday + 1;

              // Empty cell before month starts or after month ends
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return Expanded(
                  child: Container(height: 40, child: const SizedBox()),
                );
              }

              final currentDate = DateTime(
                currentMonth.year,
                currentMonth.month,
                dayNumber,
              );
              return Expanded(
                child: _buildDayCircle(context, currentDate, dayNumber - 1),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCircle(BuildContext context, DateTime date, int dayIndex) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final isToday =
        date.day == today.day &&
        date.month == today.month &&
        date.year == today.year;

    // Find progress for this specific date (not by index)
    final progress = widget.monthlyProgress.cast<UserProgress?>().firstWhere(
      (p) =>
          p != null &&
          p.date.day == date.day &&
          p.date.month == date.month &&
          p.date.year == date.year,
      orElse: () => null,
    );
    final azkarCompleted = progress?.azkarCompleted ?? 0;

    final dailyGoal = sl<PreferencesService>().getDailyGoalForDate(date);
    final hasCustomGoal = sl<PreferencesService>().hasCustomGoalForDate(date);
    final isGoalCompleted = azkarCompleted >= dailyGoal;
    final isSelected = selectedDayIndex == dayIndex;

    // Determine colors based on completion status
    Color circleColor;
    Color textColor;

    if (azkarCompleted == 0) {
      // No azkar completed - grey
      circleColor = isDarkTheme ? Colors.grey[700]! : Colors.grey[300]!;
      textColor = isDarkTheme ? Colors.grey[400]! : Colors.grey[600]!;
    } else if (isGoalCompleted) {
      // Goal completed - green
      circleColor = Colors.green.shade500;
      textColor = Colors.white;
    } else {
      // Partial completion - orange/amber
      circleColor = Colors.orange.shade400;
      textColor = Colors.white;
    }

    // Get gradient color for today's border (same as home page)
    final todayBorderColor = _getGradientColor(4);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDayIndex = isSelected ? null : dayIndex;
        });
      },
      onLongPress: () {
        _showSetGoalDialog(context, date);
      },
      child: Container(
        height: 40,
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(color: todayBorderColor, width: 2)
                  : isSelected
                  ? Border.all(color: Colors.purple.shade500, width: 3)
                  : null,
              boxShadow: isSelected && !isToday
                  ? [
                      BoxShadow(
                        color:
                            (isDarkTheme
                                    ? Colors.white
                                    : const Color(0xFF1A1A2E))
                                .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Day number only
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  // Custom goal indicator (small dot in top-right)
                  if (hasCustomGoal)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDayInfo(BuildContext context) {
    if (selectedDayIndex == null) return const SizedBox();

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final selectedDate = DateTime(
      currentMonth.year,
      currentMonth.month,
      selectedDayIndex! + 1,
    );

    // Find progress for this specific date (not by index)
    final progress = widget.monthlyProgress.cast<UserProgress?>().firstWhere(
      (p) =>
          p != null &&
          p.date.day == selectedDate.day &&
          p.date.month == selectedDate.month &&
          p.date.year == selectedDate.year,
      orElse: () => null,
    );

    final azkarCompleted = progress?.azkarCompleted ?? 0;
    final completedAzkarIds = progress?.completedAzkarIds ?? [];
    final dailyGoal = sl<PreferencesService>().getDailyGoalForDate(
      selectedDate,
    );
    final hasCustomGoal = sl<PreferencesService>().hasCustomGoalForDate(
      selectedDate,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkTheme
            ? Colors.grey[800]?.withOpacity(0.5)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkTheme ? Colors.grey[600]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Date header
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getGradientColor(4).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: _getGradientColor(4),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                      style: TextStyle(
                        color: isDarkTheme
                            ? Colors.white
                            : const Color(0xFF1A1A1A),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 4),
                    // Goal completion status with detailed info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: azkarCompleted >= dailyGoal
                            ? Colors.green.withOpacity(0.1)
                            : azkarCompleted > 0
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: azkarCompleted >= dailyGoal
                              ? Colors.green.withOpacity(0.3)
                              : azkarCompleted > 0
                              ? Colors.orange.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        textDirection: TextDirection.rtl,
                        children: [
                          Icon(
                            azkarCompleted >= dailyGoal
                                ? Icons.check_circle
                                : azkarCompleted > 0
                                ? Icons.access_time
                                : Icons.circle_outlined,
                            color: azkarCompleted >= dailyGoal
                                ? Colors.green
                                : azkarCompleted > 0
                                ? Colors.orange
                                : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  azkarCompleted >= dailyGoal
                                      ? 'تم إنجاز الهدف اليومي!'
                                      : azkarCompleted > 0
                                      ? 'قراءة جزئية'
                                      : 'لم يتم قراءة أذكار',
                                  style: TextStyle(
                                    color: azkarCompleted >= dailyGoal
                                        ? Colors.green[700]
                                        : azkarCompleted > 0
                                        ? Colors.orange[700]
                                        : Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Text(
                                      '$azkarCompleted',
                                      style: TextStyle(
                                        color: azkarCompleted >= dailyGoal
                                            ? Colors.green[800]
                                            : azkarCompleted > 0
                                            ? Colors.orange[800]
                                            : Colors.grey[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' من ',
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '$dailyGoal',
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? Colors.grey[300]
                                            : Colors.grey[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' أذكار',
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (hasCustomGoal) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          'مخصص',
                                          style: TextStyle(
                                            color: Colors.amber[800],
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
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
            ],
          ),

          // Completed azkar section
          if (completedAzkarIds.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(
              color: isDarkTheme ? Colors.grey[600] : Colors.grey[300],
              height: 1,
            ),
            const SizedBox(height: 12),

            // Section title
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 6),
                Text(
                  'الأذكار المقروءة:',
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white : const Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Future builder to get azkar details and group by category
            FutureBuilder<Map<String, int>>(
              future: _getAzkarCategoryCounts(completedAzkarIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDarkTheme
                                ? Colors.white70
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'جاري تحميل تفاصيل الأذكار...',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'تم قراءة ${completedAzkarIds.length} من الأذكار',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey[200]
                                : Colors.grey[700],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  );
                }

                final categoryCounts = snapshot.data!;
                return Column(
                  children: categoryCounts.entries.map((entry) {
                    final categoryId = entry.key;
                    final count = entry.value;
                    final azkarName = _getAzkarCategoryName(categoryId);
                    final categoryColor = _getCategoryColor(categoryId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: categoryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '$azkarName ($count)',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.grey[200]
                                    : Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ] else if (azkarCompleted == 0) ...[
            const SizedBox(height: 12),
            Divider(
              color: isDarkTheme ? Colors.grey[600] : Colors.grey[300],
              height: 1,
            ),
            const SizedBox(height: 12),

            Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.info_outline,
                  color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'لم يتم قراءة أذكار في هذا اليوم',
                  style: TextStyle(
                    color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ],

          // Add goal setting hint at the bottom
          const SizedBox(height: 12),
          Divider(
            color: isDarkTheme ? Colors.grey[600] : Colors.grey[300],
            height: 1,
          ),
          const SizedBox(height: 8),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.touch_app,
                color: isDarkTheme ? Colors.grey[500] : Colors.grey[500],
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'اضغط مطولاً على أي يوم لتعديل الهدف اليومي',
                  style: TextStyle(
                    color: isDarkTheme ? Colors.grey[500] : Colors.grey[500],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      selectedDayIndex = null; // Clear selection when changing months
    });
  }

  void _goToNextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      selectedDayIndex = null; // Clear selection when changing months
    });
  }

  String _getMonthName(int month) {
    const monthNames = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return monthNames[month - 1];
  }

  // Same gradient color logic as home page
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

  /// Helper method to get category colors and counts for azkar
  Future<Map<String, int>> _getAzkarCategoryCounts(
    List<String> azkarIds,
  ) async {
    if (azkarIds.isEmpty) return {};

    try {
      // Fetch azkar details by IDs
      final azkarList = await AzkarDatabaseAdapter.getAzkarByIds(azkarIds);

      // Group azkar by categories and count them
      final Map<String, int> categoryCounts = {};

      for (final azkar in azkarList) {
        final categoryId = azkar.categoryId;
        categoryCounts[categoryId] = (categoryCounts[categoryId] ?? 0) + 1;
      }

      return categoryCounts;
    } catch (e) {
      // If fetching fails, return empty map
      debugPrint('Error fetching azkar category counts: $e');
      return {};
    }
  }

  /// Show dialog to set daily goal for a specific date
  Future<void> _showSetGoalDialog(BuildContext context, DateTime date) async {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final preferencesService = sl<PreferencesService>();
    final currentGoal = preferencesService.getDailyGoalForDate(date);
    final hasCustomGoal = preferencesService.hasCustomGoalForDate(date);
    final defaultGoal = preferencesService.getDailyGoal();

    final TextEditingController controller = TextEditingController(
      text: currentGoal.toString(),
    );

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: isDarkTheme ? Colors.grey[800] : Colors.white,
            title: Text(
              'تعديل الهدف اليومي',
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${date.day} ${_getMonthName(date.month)} ${date.year}',
                  style: TextStyle(
                    color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                    fontSize: 16,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                Text(
                  hasCustomGoal
                      ? 'الهدف الحالي: $currentGoal أذكار (مخصص)'
                      : 'الهدف الحالي: $currentGoal أذكار (افتراضي)',
                  style: TextStyle(
                    color: isDarkTheme ? Colors.grey[400] : Colors.grey[700],
                    fontSize: 14,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'الهدف الجديد',
                    labelStyle: TextStyle(
                      color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkTheme
                            ? Colors.grey[600]!
                            : Colors.grey[400]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _getGradientColor(4),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkTheme
                            ? Colors.grey[600]!
                            : Colors.grey[400]!,
                      ),
                    ),
                  ),
                ),
                if (hasCustomGoal) ...[
                  const SizedBox(height: 12),
                  Text(
                    'الهدف الافتراضي: $defaultGoal أذكار',
                    style: TextStyle(
                      color: isDarkTheme ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 12,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ],
            ),
            actions: [
              if (hasCustomGoal)
                TextButton(
                  onPressed: () async {
                    await preferencesService.removeDailyGoalForDate(date);
                    setState(() {}); // Refresh the calendar
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'استخدام الافتراضي',
                    style: TextStyle(
                      color: isDarkTheme
                          ? Colors.orange[300]
                          : Colors.orange[700],
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final newGoal = int.tryParse(controller.text);
                  if (newGoal != null && newGoal > 0) {
                    await preferencesService.setDailyGoalForDate(date, newGoal);
                    setState(() {}); // Refresh the calendar
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'حفظ',
                  style: TextStyle(
                    color: _getGradientColor(4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper method to get Arabic name for azkar category
  String _getAzkarCategoryName(String categoryId) {
    switch (categoryId) {
      case 'morning':
        return 'أذكار الصباح';
      case 'evening':
        return 'أذكار المساء';
      case 'sleep':
        return 'أذكار النوم';
      case 'waking_up':
        return 'أذكار الاستيقاظ';
      case 'opening_dua':
        return 'اذكار الصلاه';
      case 'after_prayer':
        return 'أذكار بعد الصلاة';
      case 'general':
        return 'أذكار عامة';
      case 'stress':
        return 'أذكار الضغط';
      case 'gratitude':
        return 'أذكار الشكر';
      case 'travel':
        return 'أذكار السفر';
      case 'eating':
        return 'أذكار الطعام';
      default:
        return categoryId; // Fallback to category ID if no mapping found
    }
  }

  /// Helper method to get color for azkar category
  Color _getCategoryColor(String categoryId) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    switch (categoryId) {
      case 'morning':
        return isDarkTheme ? const Color(0xFFE5C068) : const Color(0xFFF2D68A);
      case 'evening':
        return isDarkTheme ? const Color(0xFF7BB3E0) : const Color(0xFF9BC7ED);
      case 'sleep':
        return isDarkTheme ? const Color(0xFFB68DC7) : const Color(0xFFCBA8DC);
      case 'waking_up':
        return isDarkTheme ? const Color(0xFFE6A67A) : const Color(0xFFF0BF9A);
      case 'opening_dua':
        return isDarkTheme ? const Color(0xFF8BC797) : const Color(0xFFA6D4B2);
      case 'after_prayer':
        return isDarkTheme ? const Color(0xFF7AC7D8) : const Color(0xFF9DE2F2);
      case 'general':
        return isDarkTheme ? const Color(0xFF9BB3D9) : const Color(0xFFB8CBE8);
      case 'stress':
        return isDarkTheme ? const Color(0xFFE8CDB8) : const Color(0xFFF2E0CC);
      case 'gratitude':
        return isDarkTheme ? const Color(0xFF94D9CC) : const Color(0xFFB0E8DC);
      case 'travel':
        return isDarkTheme ? const Color(0xFFD9B8BC) : const Color(0xFFE8CCD0);
      case 'eating':
        return isDarkTheme ? const Color(0xFFD4B8D1) : const Color(0xFFE2CCE0);
      default:
        return isDarkTheme ? Colors.grey[600]! : Colors.grey[400]!;
    }
  }
}
