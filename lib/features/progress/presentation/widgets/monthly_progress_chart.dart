import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';

class MonthlyProgressChart extends StatefulWidget {
  final List<UserProgress> monthlyProgress;

  const MonthlyProgressChart({super.key, required this.monthlyProgress});

  @override
  State<MonthlyProgressChart> createState() => _MonthlyProgressChartState();
}

class _MonthlyProgressChartState extends State<MonthlyProgressChart> {
  int touchedIndex = -1;
  late int currentYear;
  late List<int> availableYears;

  @override
  void initState() {
    super.initState();
    _initializeYears();
  }

  void _initializeYears() {
    if (widget.monthlyProgress.isEmpty) {
      currentYear = DateTime.now().year;
      availableYears = [currentYear];
    } else {
      availableYears = widget.monthlyProgress
          .map((progress) => progress.date.year)
          .toSet()
          .toList()
        ..sort();
      currentYear = availableYears.isNotEmpty ? availableYears.last : DateTime.now().year;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkTheme ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkTheme ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and year selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Year navigation
              Row(
                children: [
                  IconButton(
                    onPressed: _canGoToPreviousYear() ? _goToPreviousYear : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: _canGoToPreviousYear()
                          ? (isDarkTheme ? Colors.white : const Color(0xFF1A1A2E))
                          : Colors.grey,
                    ),
                  ),
                  Text(
                    currentYear.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: _canGoToNextYear() ? _goToNextYear : null,
                    icon: Icon(
                      Icons.chevron_right,
                      color: _canGoToNextYear()
                          ? (isDarkTheme ? Colors.white : const Color(0xFF1A1A2E))
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              // Title and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'التقدم الشهري',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getGradientColor(
                        1,
                        isDarkTheme,
                      ).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.calendar_month,
                      color: _getGradientColor(1, isDarkTheme),
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: _getGridInterval(),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: (isDarkTheme ? Colors.white : Colors.grey)
                          .withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const arabicMonths = [
                          'ديسمبر',   // 0 -> December (leftmost in RTL)
                          'نوفمبر',   // 1 -> November
                          'أكتوبر',   // 2 -> October
                          'سبتمبر',   // 3 -> September
                          'أغسطس',   // 4 -> August
                          'يوليو',   // 5 -> July
                          'يونيو',    // 6 -> June
                          'مايو',     // 7 -> May
                          'أبريل',    // 8 -> April
                          'مارس',     // 9 -> March
                          'فبراير',   // 10 -> February
                          'يناير',    // 11 -> January (rightmost in RTL)
                        ];
                        if (value >= 0 && value < arabicMonths.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              arabicMonths[value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDarkTheme
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.grey[600]!.withOpacity(0.8),
                                fontSize: 10,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDarkTheme
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey[600]!.withOpacity(0.8),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: (isDarkTheme ? Colors.white : Colors.grey)
                        .withOpacity(0.3),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: _getMaxY(),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getSpots(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        _getGradientColor(1, isDarkTheme), // Light blue
                        _getGradientColor(3, isDarkTheme), // Light cyan
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          _getGradientColor(
                            1,
                            isDarkTheme,
                          ).withValues(alpha: 0.6), // Light blue
                          _getGradientColor(
                            3,
                            isDarkTheme,
                          ).withValues(alpha: 0.4), // Light cyan
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: _getGradientColor(
                              1,
                              isDarkTheme,
                            ), // Light blue
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        const arabicMonths = [
                          'ديسمبر',   // 0 -> December (leftmost in RTL)
                          'نوفمبر',   // 1 -> November
                          'أكتوبر',   // 2 -> October
                          'سبتمبر',   // 3 -> September
                          'أغسطس',   // 4 -> August
                          'يوليو',   // 5 -> July
                          'يونيو',    // 6 -> June
                          'مايو',     // 7 -> May
                          'أبريل',    // 8 -> April
                          'مارس',     // 9 -> March
                          'فبراير',   // 10 -> February
                          'يناير',    // 11 -> January (rightmost in RTL)
                        ];
                        final month = arabicMonths[spot.x.toInt()];
                        final count = spot.y.toInt();
                        return LineTooltipItem(
                          '$month $currentYear\n$count أذكار',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                    getTooltipColor: (touchedSpot) => _getGradientColor(
                      1,
                      isDarkTheme,
                    ).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildYearlyStats(context),
        ],
      ),
    );
  }

  // Navigation methods for years
  bool _canGoToPreviousYear() {
    return availableYears.isNotEmpty && currentYear > availableYears.first;
  }

  bool _canGoToNextYear() {
    return availableYears.isNotEmpty && currentYear < availableYears.last;
  }

  void _goToPreviousYear() {
    if (_canGoToPreviousYear()) {
      setState(() {
        final currentIndex = availableYears.indexOf(currentYear);
        if (currentIndex > 0) {
          currentYear = availableYears[currentIndex - 1];
        }
      });
    }
  }

  void _goToNextYear() {
    if (_canGoToNextYear()) {
      setState(() {
        final currentIndex = availableYears.indexOf(currentYear);
        if (currentIndex < availableYears.length - 1) {
          currentYear = availableYears[currentIndex + 1];
        }
      });
    }
  }

  List<FlSpot> _getSpots() {
    // Get monthly data for the current year
    final currentYearProgress = widget.monthlyProgress
        .where((progress) => progress.date.year == currentYear)
        .toList();

    if (currentYearProgress.isEmpty) {
      return List.generate(12, (index) => FlSpot(index.toDouble(), 0));
    }

    // Group progress by month and sum up the azkar completed
    final monthlyData = <int, int>{};
    for (final progress in currentYearProgress) {
      final month = progress.date.month;
      monthlyData[month] = (monthlyData[month] ?? 0) + progress.azkarCompleted;
    }

    // Create spots for each month in RTL order (December to January, right to left)
    final spots = <FlSpot>[];
    for (int month = 1; month <= 12; month++) {
      // Reverse the index to display RTL (11-(month-1) to flip the order)
      final reversedIndex = 11 - (month - 1);
      final azkarCount = monthlyData[month] ?? 0;
      spots.add(FlSpot(reversedIndex.toDouble(), azkarCount.toDouble()));
    }
    return spots;
  }

  double _getMaxY() {
    final currentYearProgress = widget.monthlyProgress
        .where((progress) => progress.date.year == currentYear)
        .toList();

    if (currentYearProgress.isEmpty) return 50;

    // Group by month and sum azkar completed
    final monthlyData = <int, int>{};
    for (final progress in currentYearProgress) {
      final month = progress.date.month;
      monthlyData[month] = (monthlyData[month] ?? 0) + progress.azkarCompleted;
    }

    final maxCompleted = monthlyData.values.isNotEmpty
        ? monthlyData.values.reduce((a, b) => a > b ? a : b)
        : 0;

    return (maxCompleted + 10).toDouble();
  }

  double _getGridInterval() {
    final maxY = _getMaxY();
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 200) return 50;
    return 100;
  }

  Widget _buildYearlyStats(BuildContext context) {
    final currentYearProgress = widget.monthlyProgress
        .where((progress) => progress.date.year == currentYear)
        .toList();

    final totalAzkar = currentYearProgress.fold<int>(
      0,
      (sum, progress) => sum + progress.azkarCompleted,
    );

    // Group by month to count active months
    final monthlyData = <int, int>{};
    for (final progress in currentYearProgress) {
      final month = progress.date.month;
      monthlyData[month] = (monthlyData[month] ?? 0) + progress.azkarCompleted;
    }

    final activeMonths = monthlyData.values.where((count) => count > 0).length;
    final averagePerMonth = activeMonths > 0
        ? (totalAzkar / activeMonths).toStringAsFixed(1)
        : '0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(context, 'المجموع', totalAzkar.toString(), Colors.green),
        _buildStatItem(
          context,
          'الأشهر النشطة',
          activeMonths.toString(),
          Colors.blue,
        ),
        _buildStatItem(context, 'المتوسط/شهر', averagePerMonth, Colors.orange),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDarkTheme ? Colors.grey[400] : const Color(0xFF1A1A2E),
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  // Get gradient colors that match the azkar categories design
  Color _getGradientColor(int index, bool isDarkTheme) {
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
