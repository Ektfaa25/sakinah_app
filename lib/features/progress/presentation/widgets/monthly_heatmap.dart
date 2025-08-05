import 'package:flutter/material.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';

class MonthlyHeatmap extends StatefulWidget {
  final List<UserProgress> monthlyProgress;

  const MonthlyHeatmap({super.key, required this.monthlyProgress});

  @override
  State<MonthlyHeatmap> createState() => _MonthlyHeatmapState();
}

class _MonthlyHeatmapState extends State<MonthlyHeatmap> {
  int? selectedDayIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassyContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_month,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Monthly Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHeatmapGrid(context),
          const SizedBox(height: 16),
          _buildHeatmapLegend(context),
          if (selectedDayIndex != null) ...[
            const SizedBox(height: 16),
            _buildSelectedDayInfo(context),
          ],
          const SizedBox(height: 16),
          _buildMonthlyStats(context),
        ],
      ),
    );
  }

  Widget _buildHeatmapGrid(BuildContext context) {
    final theme = Theme.of(context);
    const daysInMonth = 30; // Simplified for now
    final cellSize =
        (MediaQuery.of(context).size.width - 120) /
        7; // 7 columns with increased padding to prevent overflow

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          (daysInMonth / 7).ceil(),
          (weekIndex) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex;
              if (dayNumber >= daysInMonth) {
                return Expanded(child: SizedBox(height: cellSize));
              }

              final progress = dayNumber < widget.monthlyProgress.length
                  ? widget.monthlyProgress[dayNumber]
                  : null;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDayIndex = dayNumber;
                    });
                  },
                  child: Container(
                    height: cellSize - 4,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _getHeatmapColor(
                        context,
                        progress?.azkarCompleted ?? 0,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      border: selectedDayIndex == dayNumber
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${dayNumber + 1}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getTextColor(
                            context,
                            progress?.azkarCompleted ?? 0,
                          ),
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmapLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Less',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: _getHeatmapColor(context, index * 2),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          'More',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedDayInfo(BuildContext context) {
    final theme = Theme.of(context);
    final progress = selectedDayIndex! < widget.monthlyProgress.length
        ? widget.monthlyProgress[selectedDayIndex!]
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Day ${selectedDayIndex! + 1}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (progress != null) ...[
            Icon(
              Icons.auto_awesome,
              color: theme.colorScheme.secondary,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              '${progress.azkarCompleted} azkar',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Text(
              'No activity',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthlyStats(BuildContext context) {
    final totalAzkar = widget.monthlyProgress.fold<int>(
      0,
      (sum, progress) => sum + progress.azkarCompleted,
    );
    final activeDays = widget.monthlyProgress
        .where((p) => p.azkarCompleted > 0)
        .length;
    final longestStreak = _calculateLongestStreak();
    final averagePerDay = activeDays > 0
        ? (totalAzkar / activeDays).toStringAsFixed(1)
        : '0';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(context, 'Total', totalAzkar.toString(), Colors.green),
        _buildStatItem(context, 'Active', activeDays.toString(), Colors.blue),
        _buildStatItem(
          context,
          'Streak',
          longestStreak.toString(),
          Colors.orange,
        ),
        _buildStatItem(context, 'Avg/Day', averagePerDay, Colors.purple),
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
            color: theme.colorScheme.onSurface,
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

  Color _getHeatmapColor(BuildContext context, int azkarCount) {
    if (azkarCount == 0) {
      return _getGradientColor(
        9,
      ).withValues(alpha: 0.1); // Light turquoise, very light
    } else if (azkarCount <= 2) {
      return _getGradientColor(4).withValues(alpha: 0.3); // Light mint
    } else if (azkarCount <= 5) {
      return _getGradientColor(4).withValues(alpha: 0.6); // Light mint
    } else if (azkarCount <= 8) {
      return _getGradientColor(4).withValues(alpha: 0.8); // Light mint
    } else {
      return _getGradientColor(4); // Light mint
    }
  }

  Color _getTextColor(BuildContext context, int azkarCount) {
    // Use consistent navy blue text for all cases
    return const Color(0xFF1A1A2E);
  }

  int _calculateLongestStreak() {
    if (widget.monthlyProgress.isEmpty) return 0;

    int longestStreak = 0;
    int currentStreak = 0;

    for (final progress in widget.monthlyProgress) {
      if (progress.azkarCompleted > 0) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak
            ? currentStreak
            : longestStreak;
      } else {
        currentStreak = 0;
      }
    }

    return longestStreak;
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
