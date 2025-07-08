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
          Text(
            'Monthly Activity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
        (MediaQuery.of(context).size.width - 90) /
        7; // 7 columns with more padding

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          (daysInMonth / 7).ceil(),
          (weekIndex) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex;
              if (dayNumber >= daysInMonth) {
                return SizedBox(width: cellSize, height: cellSize);
              }

              final progress = dayNumber < widget.monthlyProgress.length
                  ? widget.monthlyProgress[dayNumber]
                  : null;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDayIndex = dayNumber;
                  });
                },
                child: Container(
                  width: cellSize - 4,
                  height: cellSize - 4,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _getHeatmapColor(
                      context,
                      progress?.azkarCompleted ?? 0,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    border: selectedDayIndex == dayNumber
                        ? Border.all(color: theme.colorScheme.primary, width: 2)
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
        color: theme.colorScheme.primary.withOpacity(0.1),
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
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Color _getHeatmapColor(BuildContext context, int azkarCount) {
    final theme = Theme.of(context);

    if (azkarCount == 0) {
      return theme.colorScheme.outline.withOpacity(0.1);
    } else if (azkarCount <= 2) {
      return theme.colorScheme.primary.withOpacity(0.3);
    } else if (azkarCount <= 5) {
      return theme.colorScheme.primary.withOpacity(0.6);
    } else if (azkarCount <= 8) {
      return theme.colorScheme.primary.withOpacity(0.8);
    } else {
      return theme.colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context, int azkarCount) {
    final theme = Theme.of(context);

    if (azkarCount == 0) {
      return theme.colorScheme.onSurface.withOpacity(0.6);
    } else if (azkarCount <= 2) {
      return theme.colorScheme.onSurface;
    } else {
      return theme.colorScheme.onPrimary;
    }
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
}
