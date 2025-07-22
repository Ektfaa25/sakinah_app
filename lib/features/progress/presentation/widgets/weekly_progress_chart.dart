import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';

class WeeklyProgressChart extends StatefulWidget {
  final List<UserProgress> weeklyProgress;

  const WeeklyProgressChart({super.key, required this.weeklyProgress});

  @override
  State<WeeklyProgressChart> createState() => _WeeklyProgressChartState();
}

class _WeeklyProgressChartState extends State<WeeklyProgressChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getGradientColor(1).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.trending_up,
                  color: _getGradientColor(1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Weekly Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.3),
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
                        const weekdays = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        if (value >= 0 && value < weekdays.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              weekdays[value.toInt()],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
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
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
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
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: _getMaxY(),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getSpots(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        _getGradientColor(1), // Light blue
                        _getGradientColor(3), // Light cyan
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
                          ).withValues(alpha: 0.3), // Light blue
                          _getGradientColor(
                            3,
                          ).withValues(alpha: 0.1), // Light cyan
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
                            color: _getGradientColor(1), // Light blue
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
                        const weekdays = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        final day = weekdays[spot.x.toInt()];
                        final count = spot.y.toInt();
                        return LineTooltipItem(
                          '$day\n$count azkar',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                    getTooltipColor: (touchedSpot) =>
                        _getGradientColor(1).withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildWeeklyStats(context),
        ],
      ),
    );
  }

  List<FlSpot> _getSpots() {
    if (widget.weeklyProgress.isEmpty) {
      return List.generate(7, (index) => FlSpot(index.toDouble(), 0));
    }

    // Create spots for each day of the week
    final spots = <FlSpot>[];
    for (int i = 0; i < 7; i++) {
      if (i < widget.weeklyProgress.length) {
        spots.add(
          FlSpot(
            i.toDouble(),
            widget.weeklyProgress[i].azkarCompleted.toDouble(),
          ),
        );
      } else {
        spots.add(FlSpot(i.toDouble(), 0));
      }
    }
    return spots;
  }

  double _getMaxY() {
    if (widget.weeklyProgress.isEmpty) return 10;

    final maxCompleted = widget.weeklyProgress
        .map((p) => p.azkarCompleted)
        .fold(0, (prev, current) => current > prev ? current : prev);

    return (maxCompleted + 2).toDouble();
  }

  Widget _buildWeeklyStats(BuildContext context) {
    final totalAzkar = widget.weeklyProgress.fold<int>(
      0,
      (sum, progress) => sum + progress.azkarCompleted,
    );
    final activeDays = widget.weeklyProgress
        .where((p) => p.azkarCompleted > 0)
        .length;
    final averagePerDay = activeDays > 0
        ? (totalAzkar / activeDays).toStringAsFixed(1)
        : '0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(context, 'Total', totalAzkar.toString(), Colors.green),
        _buildStatItem(
          context,
          'Active Days',
          activeDays.toString(),
          Colors.blue,
        ),
        _buildStatItem(context, 'Avg/Day', averagePerDay, Colors.orange),
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
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF1A1A2E), // Navy blue dark text
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF1A1A2E), // Navy blue dark text
          ),
        ),
      ],
    );
  }

  // Get gradient colors that match the azkar categories design
  Color _getGradientColor(int index) {
    final colors = [
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
