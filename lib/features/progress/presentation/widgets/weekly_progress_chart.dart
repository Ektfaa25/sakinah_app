import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';

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

    return GlassyContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
                      color: theme.colorScheme.outline.withOpacity(0.2),
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
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
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
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                    color: theme.colorScheme.outline.withOpacity(0.2),
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
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.3),
                          theme.colorScheme.secondary.withOpacity(0.1),
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
                            color: theme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface,
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
                          TextStyle(
                            color: theme.colorScheme.onInverseSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                    getTooltipColor: (touchedSpot) =>
                        theme.colorScheme.inverseSurface,
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
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
