import 'package:flutter/material.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';

class MonthlyCalendar extends StatefulWidget {
  final List<UserProgress> monthlyProgress;

  const MonthlyCalendar({super.key, required this.monthlyProgress});

  @override
  State<MonthlyCalendar> createState() => _MonthlyCalendarState();
}

class _MonthlyCalendarState extends State<MonthlyCalendar> {
  late DateTime currentMonth;
  int? selectedDayIndex;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
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

    // Get azkar progress for this day
    final progress = dayIndex < widget.monthlyProgress.length
        ? widget.monthlyProgress[dayIndex]
        : null;
    final azkarCompleted = progress?.azkarCompleted ?? 0;

    final dailyGoal = 5;
    final isGoalCompleted = azkarCompleted >= dailyGoal;
    final isSelected = selectedDayIndex == dayIndex;

    // Same color logic as home page day indicators
    final circleColor = isGoalCompleted
        ? Colors.green.shade500
        : isDarkTheme
        ? Colors.grey.shade600
        : Colors.grey.shade300;

    // Get gradient color for today's border (same as home page)
    final todayBorderColor = _getGradientColor(4);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDayIndex = isSelected ? null : dayIndex;
        });
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
                  ? Border.all(
                      color: isDarkTheme
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                      width: 2,
                    )
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
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isGoalCompleted
                      ? Colors.white
                      : isDarkTheme
                      ? Colors.white.withOpacity(0.8)
                      : const Color(0xFF1A1A2E).withOpacity(0.8),
                ),
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
    final progress = selectedDayIndex! < widget.monthlyProgress.length
        ? widget.monthlyProgress[selectedDayIndex!]
        : null;

    final selectedDate = DateTime(
      currentMonth.year,
      currentMonth.month,
      selectedDayIndex! + 1,
    );
    final azkarCompleted = progress?.azkarCompleted ?? 0;
    final dailyGoal = 5;

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
      child: Row(
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
                    color: isDarkTheme ? Colors.white : const Color(0xFF1A1A1A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: azkarCompleted >= dailyGoal
                          ? Colors.green
                          : Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$azkarCompleted من $dailyGoal أذكار',
                      style: TextStyle(
                        color: isDarkTheme
                            ? Colors.grey[300]
                            : Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ],
            ),
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
}
