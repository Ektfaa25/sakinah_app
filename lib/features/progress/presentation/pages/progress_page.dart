import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/streak_counter.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/animated_progress_ring.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/weekly_progress_chart.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/monthly_heatmap.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/daily_goal_dialog.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/motivational_message.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/progress_sharing_widget.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';
import 'package:sakinah_app/l10n/app_localizations.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load initial progress data
    context.read<ProgressBloc>().add(const LoadTodayProgress());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, l10n),
            _buildTabBar(context, l10n),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTodayTab(context, l10n),
                  _buildWeeklyTab(context, l10n),
                  _buildMonthlyTab(context, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: theme.colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            l10n.myProgress,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProgressBloc>().add(const RefreshProgress());
            },
            tooltip: 'Refresh Progress',
          ),
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () => _showGoalDialog(context),
            tooltip: 'Set Daily Goal',
          ),
          QuickShareButton(
            shareTitle: 'My Progress in Sakinah',
            shareText: _getShareText(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassyContainer(
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          onTap: (index) {
            switch (index) {
              case 0:
                context.read<ProgressBloc>().add(const LoadTodayProgress());
                break;
              case 1:
                context.read<ProgressBloc>().add(const LoadWeeklyProgress());
                break;
              case 2:
                context.read<ProgressBloc>().add(const LoadMonthlyProgress());
                break;
            }
          },
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTab(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state is ProgressLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProgressError) {
          return _buildErrorState(context, state.message);
        } else if (state is TodayProgressLoaded) {
          return _buildTodayContent(context, state, l10n);
        } else if (state is FullProgressLoaded) {
          return _buildTodayContent(
            context,
            TodayProgressLoaded(
              progress: state.todayProgress,
              currentStreak: state.currentStreak,
            ),
            l10n,
          );
        }

        return const Center(child: Text('No progress data available'));
      },
    );
  }

  Widget _buildTodayContent(
    BuildContext context,
    TodayProgressLoaded state,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final progress = state.progress;
    final dailyGoal = 5; // TODO: Get from settings
    final completionRate = progress.azkarCompleted / dailyGoal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Main progress ring
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: AnimatedProgressRing(
              progress: completionRate.clamp(0.0, 1.0),
              size: 200,
              strokeWidth: 12,
              centerWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${progress.azkarCompleted}',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    'of $dailyGoal',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Azkar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Motivational message
          MotivationalMessage(
            completedCount: progress.azkarCompleted,
            goalCount: dailyGoal,
            currentStreak: state.currentStreak,
          ),

          const SizedBox(height: 20),

          // Streak counter
          StreakCounter(streakCount: state.currentStreak, label: l10n.streak),

          const SizedBox(height: 30),

          // Stats grid
          _buildStatsGrid(context, progress, l10n),

          if (progress.reflection != null) ...[
            const SizedBox(height: 24),
            _buildReflectionCard(context, progress.reflection!, l10n),
          ],

          if (progress.moodBefore != null || progress.moodAfter != null) ...[
            const SizedBox(height: 24),
            _buildMoodCard(context, progress, l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildWeeklyTab(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state is ProgressLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProgressError) {
          return _buildErrorState(context, state.message);
        } else if (state is WeeklyProgressLoaded) {
          return _buildWeeklyContent(context, state, l10n);
        }

        return const Center(child: Text('No weekly data available'));
      },
    );
  }

  Widget _buildWeeklyContent(
    BuildContext context,
    WeeklyProgressLoaded state,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekly summary cards
          Row(
            children: [
              // Removed Total Azkar count display as requested
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Active Days',
                  state.weeklyProgress
                      .where((p) => p.azkarCompleted > 0)
                      .length
                      .toString(),
                  Icons.calendar_today,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Weekly chart
          WeeklyProgressChart(weeklyProgress: state.weeklyProgress),
        ],
      ),
    );
  }

  Widget _buildMonthlyTab(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<ProgressBloc, ProgressState>(
      builder: (context, state) {
        if (state is ProgressLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProgressError) {
          return _buildErrorState(context, state.message);
        } else if (state is MonthlyProgressLoaded) {
          return _buildMonthlyContent(context, state, l10n);
        }

        return const Center(child: Text('No monthly data available'));
      },
    );
  }

  Widget _buildMonthlyContent(
    BuildContext context,
    MonthlyProgressLoaded state,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Monthly summary
          Row(
            children: [
              // Removed Total Azkar count display as requested
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Active Days',
                  state.monthlyProgress
                      .where((p) => p.azkarCompleted > 0)
                      .length
                      .toString(),
                  Icons.calendar_month,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Monthly calendar heatmap
          MonthlyHeatmap(monthlyProgress: state.monthlyProgress),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    progress,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Completed',
            progress.azkarCompleted.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'This Week',
            '12', // TODO: Calculate actual weekly count
            Icons.calendar_view_week,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: GlassyContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return GlassyContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionCard(
    BuildContext context,
    String reflection,
    AppLocalizations l10n,
  ) {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: GlassyContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Today\'s Reflection',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reflection,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, progress, AppLocalizations l10n) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: GlassyContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.mood,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Mood Journey',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (progress.moodBefore != null) ...[
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Before',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          progress.moodBefore!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  if (progress.moodAfter != null) ...[
                    const Icon(Icons.arrow_forward, size: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'After',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            progress.moodAfter!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ProgressBloc>().add(const RefreshProgress());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DailyGoalDialog(
        currentGoal: 5, // TODO: Get from settings/preferences
        onGoalSet: (goal) {
          // TODO: Save goal to settings/preferences
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Daily goal set to $goal azkar'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }

  String _getShareText() {
    return '''
🕌 My Progress in Sakinah App 🕌

Today's Journey:
• Made spiritual progress
• Engaged in dhikr and azkar
• Continuing my path of remembrance

Join me in this beautiful journey of Islamic spirituality!

#IslamicApp #Dhikr #Azkar #Spirituality #Islam
''';
  }
}
