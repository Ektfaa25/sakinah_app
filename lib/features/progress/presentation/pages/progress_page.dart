import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/animated_progress_ring.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/monthly_progress_chart.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/monthly_calendar.dart';
import 'package:sakinah_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedYear = DateTime.now().year; // Track current selected year

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);

    // Add listener to handle swipe gestures
    _tabController.addListener(() {
      // Update indicator color immediately when tab starts changing
      if (mounted) {
        setState(() {});
      }

      if (!_tabController.indexIsChanging) {
        // Tab animation has completed, load appropriate data
        // Add a small delay to ensure smooth animation completion
        Future.microtask(() => _loadDataForTab(_tabController.index));
      }
    });

    // Load initial progress data
    context.read<ProgressBloc>().add(
      const LoadTodayProgress(),
    ); // Start with today's data
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Navigation methods for year selection
  void _goToPreviousYear() {
    setState(() {
      selectedYear--;
    });
  }

  void _goToNextYear() {
    final currentYear = DateTime.now().year;
    if (selectedYear < currentYear) {
      setState(() {
        selectedYear++;
      });
    }
  }

  // Helper method to load data based on tab index
  void _loadDataForTab(int index) {
    // Only load data if the widget is still mounted
    if (!mounted) return;

    switch (index) {
      case 0:
        context.read<ProgressBloc>().add(
          const LoadWeeklyProgress(),
        ); // Treating as yearly for now
        break;
      case 1:
        context.read<ProgressBloc>().add(const LoadMonthlyProgress());
        break;
      case 2:
        context.read<ProgressBloc>().add(const LoadTodayProgress());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme ? null : Colors.white,
        gradient: isDarkTheme
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.darkBackground.withOpacity(0.9),
                  AppColors.darkSurface.withOpacity(0.9),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDarkTheme
                ? Colors.black.withOpacity(0.15) // Reduced from 0.3
                : Colors.black.withOpacity(0.04), // Reduced from 0.1
            blurRadius: 6, // Reduced from 10
            offset: const Offset(0, -1), // Reduced from -2
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () => Navigator.pop(context),
            tooltip: 'رجوع',
          ),
          title: Text(
            'التقدم',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            labelColor: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
            unselectedLabelColor: isDarkTheme
                ? Colors.grey[400]
                : Colors.grey[600],
            indicatorColor: _getTabIndicatorColor(),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: 0.3,
            ),
            onTap: (index) {
              _loadDataForTab(index);
            },
            tabs: const [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today, size: 18),
                    SizedBox(width: 8),
                    Text('السنة'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month, size: 18),
                    SizedBox(width: 8),
                    Text('الشهر'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.today, size: 18),
                    SizedBox(width: 8),
                    Text('اليوم'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            physics:
                const BouncingScrollPhysics(), // Enable smooth swiping with bounce effect
            children: [
              _buildWeeklyTab(context, l10n), // Using weekly as yearly for now
              _buildMonthlyTab(context, l10n),
              _buildTodayTab(context, l10n),
            ],
          ),
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

        // Show loading for other states (when switching tabs)
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildTodayContent(
    BuildContext context,
    TodayProgressLoaded state,
    AppLocalizations l10n,
  ) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final progress = state.progress;
    final dailyGoal = 5; // TODO: Get from settings
    final completionRate = progress.azkarCompleted / dailyGoal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          // Welcome Message
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkTheme ? null : Colors.white,
                gradient: isDarkTheme
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isDarkTheme ? 24 : 12,
                    offset: Offset(0, isDarkTheme ? 8 : 4),
                    spreadRadius: 0,
                  ),
                  if (isDarkTheme)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: Border.all(
                  color: isDarkTheme
                      ? Color.lerp(
                          _getGradientColor(0),
                          Colors.black,
                          0.2,
                        )!.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    completionRate >= 1.0
                        ? '🎉 عمل ممتاز!'
                        : completionRate >= 0.8
                        ? '⭐ أوشكت على الانتهاء!'
                        : completionRate >= 0.5
                        ? '💪 تقدم رائع!'
                        : completionRate > 0
                        ? '🌱 بداية جيدة!'
                        : '🕌 ابدأ رحلتك',
                    style: TextStyle(
                      color: isDarkTheme
                          ? Colors.white
                          : const Color(0xFF1A1A1A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    completionRate >= 1.0
                        ? 'لقد أكملت هدفك اليومي! استمر في العمل الرائع.'
                        : 'كل ذكر يقربك إلى الله. واصل رحلتك الروحية.',
                    style: TextStyle(
                      color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Main Progress Section
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkTheme ? null : Colors.white,
                gradient: isDarkTheme
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isDarkTheme ? 24 : 12,
                    offset: Offset(0, isDarkTheme ? 8 : 4),
                    spreadRadius: 0,
                  ),
                  if (isDarkTheme)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: Border.all(
                  color: isDarkTheme
                      ? Color.lerp(
                          _getGradientColor(0),
                          Colors.black,
                          0.2,
                        )!.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Progress Ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedProgressRing(
                        progress: completionRate.clamp(0.0, 1.0),
                        size: 90,
                        strokeWidth: 8,
                        centerWidget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${progress.azkarCompleted}',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.white
                                    : Color(0xFF1A1A2E),
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Color.lerp(
                                  _getGradientColor(0),
                                  Colors.black,
                                  0.2,
                                )!.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$dailyGoal',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.grey[400]
                                    : Colors.grey[500],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Progress Label
                  Text(
                    'تقدم الأذكار اليومية',
                    style: TextStyle(
                      color: isDarkTheme ? Colors.white : Color(0xFF1A1A2E),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 8),

                  // Percentage
                  Text(
                    '${(completionRate * 100).toInt()}% مكتمل',
                    style: TextStyle(
                      color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Streak and Stats Row
          Row(
            children: [
              // Streak Card
              Expanded(
                child: FadeInLeft(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkTheme ? null : Colors.white,
                      gradient: isDarkTheme
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.darkSurface,
                                AppColors.darkSurface.withOpacity(0.8),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkTheme
                              ? Color.lerp(
                                  _getGradientColor(0),
                                  Colors.black,
                                  0.2,
                                )!.withOpacity(0.08)
                              : Colors.grey.withOpacity(0.1),
                          blurRadius: isDarkTheme ? 24 : 12,
                          offset: Offset(0, isDarkTheme ? 8 : 4),
                          spreadRadius: 0,
                        ),
                        if (isDarkTheme)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                      border: Border.all(
                        color: isDarkTheme
                            ? Color.lerp(
                                _getGradientColor(0),
                                Colors.black,
                                0.2,
                              )!.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.lerp(
                              _getGradientColor(0),
                              Colors.black,
                              0.2,
                            )!.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_fire_department,
                            color: Colors.orange[300],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${state.currentStreak}',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'أيام متتالية',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey[300]
                                : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Today's Count Card
              Expanded(
                child: FadeInRight(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkTheme ? null : Colors.white,
                      gradient: isDarkTheme
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.darkSurface,
                                AppColors.darkSurface.withOpacity(0.8),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkTheme
                              ? Color.lerp(
                                  _getGradientColor(0),
                                  Colors.black,
                                  0.2,
                                )!.withOpacity(0.08)
                              : Colors.grey.withOpacity(0.1),
                          blurRadius: isDarkTheme ? 24 : 12,
                          offset: Offset(0, isDarkTheme ? 8 : 4),
                          spreadRadius: 0,
                        ),
                        if (isDarkTheme)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                      border: Border.all(
                        color: isDarkTheme
                            ? Color.lerp(
                                _getGradientColor(0),
                                Colors.black,
                                0.2,
                              )!.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.lerp(
                              _getGradientColor(0),
                              Colors.black,
                              0.2,
                            )!.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.green[300],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${progress.azkarCompleted}',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اليوم',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey[300]
                                : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Additional Cards
          if (progress.reflection != null) ...[
            _buildReflectionCard(context, progress.reflection!, l10n),
            const SizedBox(height: 24),
          ],

          if (progress.moodBefore != null || progress.moodAfter != null) ...[
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

        // Show loading for other states (when switching tabs)
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildWeeklyContent(
    BuildContext context,
    WeeklyProgressLoaded state,
    AppLocalizations l10n,
  ) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final activeDays = state.weeklyProgress
        .where((p) => p.azkarCompleted > 0)
        .length;
    final totalAzkar = state.weeklyProgress.fold<int>(
      0,
      (sum, p) => sum + p.azkarCompleted,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16), // Reduced from 24 to 16
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8), // Reduced from 12 to 8
          // Weekly Overview Card
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkTheme ? null : Colors.white,
                gradient: isDarkTheme
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isDarkTheme ? 24 : 12,
                    offset: Offset(0, isDarkTheme ? 8 : 4),
                    spreadRadius: 0,
                  ),
                  if (isDarkTheme)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: Border.all(
                  color: isDarkTheme
                      ? Color.lerp(
                          _getGradientColor(0),
                          Colors.black,
                          0.2,
                        )!.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_view_week,
                        color: isDarkTheme
                            ? Color.lerp(
                                _getGradientColor(0),
                                Colors.black,
                                0.2,
                              )
                            : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'رحلة هذه السنة',
                        style: TextStyle(
                          color: isDarkTheme
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeeklyStatItem(
                          'أيام نشطة',
                          '$activeDays/365',
                          Icons.event_available,
                          const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildWeeklyStatItem(
                          'إجمالي الأذكار',
                          '$totalAzkar',
                          Icons.auto_awesome,
                          const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24), // Reduced from 32 to 24
          // Yearly Chart Card
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkTheme ? null : Colors.white,
                gradient: isDarkTheme
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isDarkTheme ? 24 : 12,
                    offset: Offset(0, isDarkTheme ? 8 : 4),
                    spreadRadius: 0,
                  ),
                  if (isDarkTheme)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: Border.all(
                  color: isDarkTheme
                      ? Color.lerp(
                          _getGradientColor(0),
                          Colors.black,
                          0.2,
                        )!.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with padding
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Year navigation controls (left side)
                        Row(
                          children: [
                            // Previous year button
                            IconButton(
                              onPressed: _goToPreviousYear,
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: isDarkTheme
                                    ? Colors.white
                                    : Colors.grey[700],
                                size: 18,
                              ),
                              tooltip: 'السنة السابقة',
                              padding: const EdgeInsets.all(8),
                            ),
                            // Current year display
                            Text(
                              '$selectedYear',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // Next year button (disabled if current year)
                            IconButton(
                              onPressed: selectedYear >= DateTime.now().year
                                  ? null
                                  : _goToNextYear,
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: selectedYear >= DateTime.now().year
                                    ? (isDarkTheme
                                          ? Colors.grey[600]
                                          : Colors.grey[400])
                                    : (isDarkTheme
                                          ? Colors.white
                                          : Colors.grey[700]),
                                size: 18,
                              ),
                              tooltip: 'السنة التالية',
                              padding: const EdgeInsets.all(8),
                            ),
                          ],
                        ),
                        // Title and icon (right side in RTL)
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'التقدم السنوي',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.bar_chart,
                              color: isDarkTheme
                                  ? Colors.white
                                  : Colors.grey[600],
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Chart with no padding - takes full width
                  GestureDetector(
                    onPanEnd: (details) {
                      // Handle swipe gestures
                      if (details.velocity.pixelsPerSecond.dx > 500) {
                        // Swipe right - go to next year (if not current year)
                        if (selectedYear < DateTime.now().year) {
                          _goToNextYear();
                        }
                      } else if (details.velocity.pixelsPerSecond.dx < -500) {
                        // Swipe left - go to previous year
                        _goToPreviousYear();
                      }
                    },
                    child: _buildYearlyBarChart(
                      isDarkTheme,
                      state.weeklyProgress,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkTheme ? color.withOpacity(0.15) : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(isDarkTheme ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Color(0xFF1A1A2E),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
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

        // Show loading for other states (when switching tabs)
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildMonthlyContent(
    BuildContext context,
    MonthlyProgressLoaded state,
    AppLocalizations l10n,
  ) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final activeDays = state.monthlyProgress
        .where((p) => p.azkarCompleted > 0)
        .length;
    final totalAzkar = state.monthlyProgress.fold<int>(
      0,
      (sum, p) => sum + p.azkarCompleted,
    );
    final daysInMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
    ).day;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          // Monthly Overview Card
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkTheme ? null : Colors.white,
                gradient: isDarkTheme
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isDarkTheme ? 24 : 12,
                    offset: Offset(0, isDarkTheme ? 8 : 4),
                    spreadRadius: 0,
                  ),
                  if (isDarkTheme)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: Border.all(
                  color: isDarkTheme
                      ? Color.lerp(
                          _getGradientColor(0),
                          Colors.black,
                          0.2,
                        )!.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: isDarkTheme
                            ? Color.lerp(
                                _getGradientColor(0),
                                Colors.black,
                                0.2,
                              )
                            : Colors.grey[600],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'إنجازات هذا الشهر',
                        style: TextStyle(
                          color: isDarkTheme
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMonthlyStatItem(
                          'أيام نشطة',
                          '$activeDays/$daysInMonth',
                          Icons.event_available,
                          const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMonthlyStatItem(
                          'إجمالي الأذكار',
                          '$totalAzkar',
                          Icons.auto_awesome,
                          const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMonthlyStatItem(
                          'الثبات',
                          '${((activeDays / daysInMonth) * 100).toInt()}%',
                          Icons.trending_up,
                          const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Monthly Calendar Card
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkTheme ? null : Colors.white,
                gradient: isDarkTheme
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkSurface,
                          AppColors.darkSurface.withOpacity(0.8),
                        ],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.08)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isDarkTheme ? 24 : 12,
                    offset: Offset(0, isDarkTheme ? 8 : 4),
                    spreadRadius: 0,
                  ),
                  if (isDarkTheme)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: Border.all(
                  color: isDarkTheme
                      ? Color.lerp(
                          _getGradientColor(0),
                          Colors.black,
                          0.2,
                        )!.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
                    children: [
                      // Title and icon (right side in RTL)
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'التقويم الشهري',
                            style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.white
                                  : Color(0xFF1A1A2E),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.calendar_view_month,
                            color: Color.lerp(
                              _getGradientColor(0),
                              Colors.black,
                              0.2,
                            ),
                            size: 20,
                          ),
                        ],
                      ),
                      // Legend (left side in RTL)
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            'مكتمل',
                            style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[500],
                              fontSize: 12,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green.shade500,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'غير مكتمل',
                            style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[500],
                              fontSize: 12,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MonthlyCalendar(monthlyProgress: state.monthlyProgress),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkTheme ? color.withOpacity(0.15) : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(isDarkTheme ? 0.3 : 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Color(0xFF1A1A2E),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isDarkTheme ? Colors.grey[400] : Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
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
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF10B981).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: const Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Today\'s Reflection',
                  style: const TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                reflection,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, progress, AppLocalizations l10n) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFF59E0B).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.mood,
                    color: const Color(0xFFF59E0B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Mood Journey',
                  style: const TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  if (progress.moodBefore != null) ...[
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Before',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            progress.moodBefore!,
                            style: const TextStyle(
                              color: Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (progress.moodAfter != null) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'After',
                                style: TextStyle(
                                  color: const Color(0xFFF59E0B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              progress.moodAfter!,
                              style: const TextStyle(
                                color: Color(0xFF1A1A2E),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                  if (progress.moodBefore == null && progress.moodAfter != null)
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Current',
                              style: TextStyle(
                                color: const Color(0xFFF59E0B),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            progress.moodAfter!,
                            style: const TextStyle(
                              color: Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
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

  // Get gradient colors that match the home page design
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

  /// Get tab indicator color based on current tab
  Color _getTabIndicatorColor() {
    switch (_tabController.index) {
      case 0: // Year tab
        return const Color(0xFFE91E63); // Pink/Magenta
      case 1: // Month tab
        return const Color(0xFF9C27B0); // Purple
      case 2: // Day tab
        return const Color(0xFF2196F3); // Blue
      default:
        return const Color(0xFF6366F1); // Default indigo
    }
  }

  /// Build yearly bar chart showing monthly progress across the year
  Widget _buildYearlyBarChart(bool isDarkTheme, List<dynamic> yearData) {
    // Generate sample yearly data with Arabic month names
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

    // Create data based on selected year
    final List<int> monthlyValues = List.generate(12, (index) {
      final currentYear = DateTime.now().year;
      final currentMonth = DateTime.now().month - 1;

      if (selectedYear == currentYear) {
        // Current year - only show data up to current month
        if (index <= currentMonth) {
          return (index + 1) * 15 + (index % 3) * 10; // Sample values
        } else {
          return 0; // Future months
        }
      } else if (selectedYear < currentYear) {
        // Past years - show full year data
        return (index + 1) * 12 + (selectedYear % 3) * 8 + (index % 4) * 6;
      } else {
        // Future years - no data
        return 0;
      }
    });

    final maxValue = monthlyValues.isNotEmpty && monthlyValues.any((v) => v > 0)
        ? monthlyValues.reduce((a, b) => a > b ? a : b)
        : 100;

    return Container(
      height: 250, // Increased height to accommodate year indicator
      child: Column(
        children: [
          // Chart area - full width
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                0,
                12,
                20,
              ), // Added bottom padding for month labels
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: monthNames.asMap().entries.map((entry) {
                  final index = entry.key;
                  final month = entry.value;
                  final value = monthlyValues[index];
                  final height = maxValue > 0 ? (value / maxValue) * 140 : 0.0;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1,
                      ), // Reduced padding between bars
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Value label
                          if (value > 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkTheme
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          // Bar with key for animation reset when year changes
                          AnimatedContainer(
                            key: ValueKey('$selectedYear-$index'),
                            duration: Duration(
                              milliseconds: 800 + (index * 100),
                            ),
                            height: height,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  _getGradientColor(index),
                                  _getGradientColor(index).withOpacity(0.7),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getGradientColor(
                                    index,
                                  ).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Month label
                          Text(
                            month,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
