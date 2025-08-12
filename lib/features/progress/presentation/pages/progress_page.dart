import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/animated_progress_ring.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/monthly_calendar.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/monthly_progress_chart.dart';
import 'package:sakinah_app/l10n/app_localizations.dart';
import 'package:sakinah_app/core/storage/preferences_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_routes.dart';

class ProgressPage extends StatefulWidget {
  final int? initialTabIndex;
  final DateTime? selectedDate;

  const ProgressPage({super.key, this.initialTabIndex, this.selectedDate});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedYear = DateTime.now().year; // Track current selected year
  List<Azkar> _completedAzkarDetails = []; // Store completed azkar details
  bool _isLoadingAzkarDetails = false; // Track loading state for azkar details

  @override
  void initState() {
    super.initState();
    // Use the provided initialTabIndex, defaulting to 2 (Today tab) if not provided
    final initialIndex = widget.initialTabIndex ?? 2;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );

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

    // Load initial progress data based on the initial tab
    _loadDataForTab(initialIndex);

    // Load the daily goal to ensure it's available for UI calculations
    context.read<ProgressBloc>().add(const LoadDailyGoal());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh progress data when returning to this page
    if (mounted) {
      _refreshCurrentTab();
    }
  }

  void _refreshCurrentTab() {
    final currentIndex = _tabController.index;
    _loadDataForTab(currentIndex);
    debugPrint('🔄 Progress Page: Refreshed current tab ($currentIndex) data');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to fetch completed azkar details
  Future<void> _fetchCompletedAzkarDetails(
    List<String> completedAzkarIds,
  ) async {
    if (completedAzkarIds.isEmpty) {
      setState(() {
        _completedAzkarDetails = [];
        _isLoadingAzkarDetails = false;
      });
      return;
    }

    setState(() {
      _isLoadingAzkarDetails = true;
    });

    try {
      final azkarDetails = await AzkarDatabaseAdapter.getAzkarByIds(
        completedAzkarIds,
      );
      debugPrint('✅ Fetched ${azkarDetails.length} completed azkar details');

      if (mounted) {
        setState(() {
          _completedAzkarDetails = azkarDetails;
          _isLoadingAzkarDetails = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error fetching completed azkar details: $e');
      if (mounted) {
        setState(() {
          _completedAzkarDetails = [];
          _isLoadingAzkarDetails = false;
        });
      }
    }
  }

  // Helper method to load data based on tab index
  void _loadDataForTab(int index) {
    // Only load data if the widget is still mounted
    if (!mounted) return;

    switch (index) {
      case 0:
        context.read<ProgressBloc>().add(const LoadWeeklyProgress());
        break;
      case 1:
        context.read<ProgressBloc>().add(const LoadMonthlyProgress());
        break;
      case 2:
        context.read<ProgressBloc>().add(const LoadTodayProgress());
        break;
    }
  }

  // Helper method to get the current daily goal
  int _getDailyGoal() {
    try {
      final today = DateTime.now();
      return sl<PreferencesService>().getDailyGoalForDate(today);
    } catch (e) {
      debugPrint(
        '⚠️ Progress Page: Error getting daily goal, using default: $e',
      );
      return 5; // Default fallback
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
            onPressed: () => context.go(AppRoutes.home),
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () {
                _refreshCurrentTab();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم تحديث البيانات 🔄',
                      textDirection: TextDirection.rtl,
                    ),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              tooltip: 'تحديث البيانات',
            ),
          ],
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
                    Icon(Icons.date_range, size: 18),
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
          child: BlocListener<ProgressBloc, ProgressState>(
            listener: (context, state) {
              // Listen for progress updates and refresh if needed
              if (state is TodayProgressLoaded) {
                debugPrint(
                  '✅ Progress Page: Received updated today progress - azkarCompleted: ${state.progress.azkarCompleted}',
                );

                // Fetch details of completed azkar to display their titles
                _fetchCompletedAzkarDetails(state.progress.completedAzkarIds);

                // Show success message when data is updated
                if (state.progress.azkarCompleted > 0) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم تحديث تقدمك! ${state.progress.azkarCompleted} فئات أذكار مكتملة اليوم 🎉',
                        textDirection: TextDirection.rtl,
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else if (state is ProgressError) {
                debugPrint('❌ Progress Page: Error received: ${state.message}');
                // Optionally show error message to user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'خطأ في تحديث التقدم: ${state.message}',
                      textDirection: TextDirection.rtl,
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is FullProgressLoaded) {
                debugPrint(
                  '✅ Progress Page: Received updated full progress - azkarCompleted: ${state.todayProgress.azkarCompleted}',
                );

                // Fetch details of completed azkar for today's progress
                _fetchCompletedAzkarDetails(
                  state.todayProgress.completedAzkarIds,
                );
              } else if (state is DailyGoalUpdated) {
                debugPrint(
                  '✅ Progress Page: Daily goal updated to ${state.goal}',
                );
                // Trigger a UI rebuild to reflect the new daily goal
                if (mounted) {
                  setState(() {});
                }

                // Show confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم تحديث الهدف اليومي إلى ${state.goal} فئات أذكار ✅',
                      textDirection: TextDirection.rtl,
                    ),
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else if (state is DailyGoalLoaded) {
                debugPrint('✅ Progress Page: Daily goal loaded: ${state.goal}');
                // Trigger a UI rebuild to reflect the loaded daily goal
                if (mounted) {
                  setState(() {});
                }
              }
            },
            child: TabBarView(
              controller: _tabController,
              physics:
                  const BouncingScrollPhysics(), // Enable smooth swiping with bounce effect
              children: [
                _buildWeeklyTab(context, l10n),
                _buildMonthlyTab(context, l10n),
                _buildTodayTab(context, l10n),
              ],
            ),
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
    final dailyGoal = _getDailyGoal();
    final completionRate = progress.azkarCompleted / dailyGoal;

    // Debug output to see what we're displaying
    debugPrint(
      '🏠 Progress Page: azkarCompleted (categories) = ${progress.azkarCompleted}',
    );
    debugPrint('🏠 Progress Page: dailyGoal (categories) = $dailyGoal');
    debugPrint(
      '🏠 Progress Page: completedAzkarIds = ${progress.completedAzkarIds}',
    );
    debugPrint('🏠 Progress Page: progress date = ${progress.date}');
    debugPrint('🏠 Progress Page: progress id = ${progress.id}');
    debugPrint(
      '🏠 Progress Page: is progress empty? = ${progress.azkarCompleted == 0 && progress.completedAzkarIds.isEmpty}',
    );

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
                        : 'كل فئة أذكار تقربك إلى الله. واصل رحلتك الروحية.',
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
                  // Progress Header with Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Goal status indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: completionRate >= 1.0
                              ? Colors.green.withOpacity(0.2)
                              : completionRate >= 0.5
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: completionRate >= 1.0
                                ? Colors.green
                                : completionRate >= 0.5
                                ? Colors.orange
                                : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          completionRate >= 1.0
                              ? 'مكتمل 🎉'
                              : completionRate >= 0.5
                              ? 'في التقدم 💪'
                              : 'ابدأ الآن 🚀',
                          style: TextStyle(
                            color: completionRate >= 1.0
                                ? Colors.green[700]
                                : completionRate >= 0.5
                                ? Colors.orange[700]
                                : Colors.red[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      // Time remaining or completed time
                      if (completionRate < 1.0)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'باقي ${dailyGoal - progress.azkarCompleted} فئات أذكار',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'تم الإنجاز!',
                              style: TextStyle(
                                color: Colors.green[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Enhanced Progress Ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background ring
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _getGradientColor(0).withOpacity(0.1),
                              _getGradientColor(1).withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                      AnimatedProgressRing(
                        progress: completionRate.clamp(0.0, 1.0),
                        size: 100,
                        strokeWidth: 10,
                        centerWidget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Current count
                            Text(
                              '${progress.azkarCompleted}',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.white
                                    : Color(0xFF1A1A2E),
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                              ),
                            ),
                            // Separator line
                            Container(
                              width: 30,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Color.lerp(
                                  _getGradientColor(0),
                                  Colors.black,
                                  0.2,
                                )!.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Daily goal
                            Text(
                              '$dailyGoal',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.grey[400]
                                    : Colors.grey[500],
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Progress percentage overlay
                      if (completionRate > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: completionRate >= 1.0
                                  ? Colors.green.withOpacity(0.9)
                                  : _getGradientColor(0).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${(completionRate * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Progress Label
                  Text(
                    'تقدم فئات الأذكار اليومية',
                    style: TextStyle(
                      color: isDarkTheme ? Colors.white : Color(0xFF1A1A2E),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 8),

                  // Progress details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(completionRate * 100).toInt()}% مكتمل',
                        style: TextStyle(
                          color: isDarkTheme
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? Colors.grey[600]
                              : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${progress.azkarCompleted} فئة مكتملة',
                        style: TextStyle(
                          color: isDarkTheme
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),

                  // Progress bar
                  const SizedBox(height: 16),
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isDarkTheme ? Colors.grey[800] : Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: completionRate.clamp(0.0, 1.0),
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          completionRate >= 1.0
                              ? Colors.green
                              : _getGradientColor(0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Today's Azkar Details Section
          if (progress.completedAzkarIds.isNotEmpty) ...[
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 100),
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkTheme
                          ? Colors.black.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: isDarkTheme
                        ? (Colors.grey[800] ?? Colors.grey.shade800)
                        : (Colors.grey[200] ?? Colors.grey.shade200),
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
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'الأذكار المكتملة من الفئات اليوم',
                            style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.white
                                  : Color(0xFF1A1A2E),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${progress.completedAzkarIds.length}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Show completed azkar details or loading state
                    if (_isLoadingAzkarDetails)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? (Colors.grey[800] ?? Colors.grey.shade800)
                                    .withOpacity(0.3)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.blue[600],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'جاري تحميل تفاصيل الأذكار...',
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_completedAzkarDetails.isNotEmpty)
                      // Show the actual completed azkar titles
                      Column(
                        children: [
                          ...(_completedAzkarDetails.take(5).map((azkar) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? (Colors.grey[800] ?? Colors.grey.shade800)
                                          .withOpacity(0.3)
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green[600],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      azkar.textAr.length > 50
                                          ? '${azkar.textAr.substring(0, 47)}...'
                                          : azkar.textAr,
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? Colors.white
                                            : Colors.grey[800],
                                        fontSize: 13,
                                        height: 1.4,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textDirection: TextDirection.rtl,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })),
                          if (_completedAzkarDetails.length > 5)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'و ${_completedAzkarDetails.length - 5} أذكار أخرى مكتملة',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? (Colors.grey[800] ?? Colors.grey.shade800)
                                    .withOpacity(0.3)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timeline,
                              color: Colors.blue[600],
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'استمر في رحلتك الروحية! كل ذكر يقربك إلى الله أكثر.',
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Best Times Card
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 500),
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
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isDarkTheme ? 32 : 16,
                    offset: Offset(0, isDarkTheme ? 12 : 6),
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: isDarkTheme
                      ? Colors.amber.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    textDirection: TextDirection.rtl,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.amber[400] ?? Colors.amber,
                              Colors.orange[400] ?? Colors.orange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.schedule,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'الأوقات المثلى للأذكار',
                              style: TextStyle(
                                color: isDarkTheme
                                    ? Colors.white
                                    : const Color(0xFF1A1A1A),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'أفضل أوقات اليوم للذكر والدعاء',
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Time periods
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: _buildTimePeriod(
                          'الفجر',
                          '5:00 - 7:00',
                          Icons.wb_sunny,
                          Colors.orange[300] ?? Colors.orange,
                          isDarkTheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimePeriod(
                          'العصر',
                          '3:00 - 5:00',
                          Icons.wb_twilight,
                          Colors.blue[300] ?? Colors.blue,
                          isDarkTheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTimePeriod(
                          'المغرب',
                          '6:00 - 8:00',
                          Icons.nights_stay,
                          Colors.purple[300] ?? Colors.purple,
                          isDarkTheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Advice text
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: isDarkTheme
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber.withOpacity(0.15),
                                Colors.orange.withOpacity(0.15),
                              ],
                            )
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber.withOpacity(0.1),
                                Colors.orange.withOpacity(0.1),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber[600],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'أذكار الصباح والمساء لها أجر عظيم، احرص على قراءتها في هذه الأوقات المباركة',
                            style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Enhanced Streak and Stats Row
          Row(
            children: [
              // Streak Card - Enhanced
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
                              ? Colors.black.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          blurRadius: isDarkTheme ? 24 : 12,
                          offset: Offset(0, isDarkTheme ? 8 : 4),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: isDarkTheme
                            ? Colors.orange.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Enhanced fire icon with glow effect
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange[400] ?? Colors.orange,
                                Colors.red[400] ?? Colors.red,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.local_fire_department,
                            color: Colors.white,
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
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
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
                            fontWeight: FontWeight.w600,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        if (state.currentStreak > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              state.currentStreak >= 7
                                  ? 'ممتاز! 🏆'
                                  : state.currentStreak >= 3
                                  ? 'رائع! 💪'
                                  : 'استمر! 🚀',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Today's Count Card - Enhanced
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
                              ? Colors.black.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          blurRadius: isDarkTheme ? 24 : 12,
                          offset: Offset(0, isDarkTheme ? 8 : 4),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: isDarkTheme
                            ? Colors.green.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Enhanced check icon
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green[400] ?? Colors.green,
                                Colors.green[600] ?? Colors.green.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            completionRate >= 1.0
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: Colors.white,
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
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
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
                            fontWeight: FontWeight.w600,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        if (progress.azkarCompleted > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              completionRate >= 1.0 ? 'مكتمل! 🎉' : 'جيد! 👍',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // DEBUG: Test button to manually add progress (remove in production)
          if (kDebugMode) ...[
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '🧪 DEBUG: Test Progress System',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Add test azkar completion
                        context.read<ProgressBloc>().add(
                          const AddAzkarCompletion(azkarId: 'test-azkar-001'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test azkar completion added!'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Test Azkar'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

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
                  MonthlyCalendar(
                    monthlyProgress: state.monthlyProgress,
                    initialSelectedDate: widget.selectedDate,
                  ),
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

  Widget _buildTimePeriod(
    String title,
    String time,
    IconData icon,
    Color color,
    bool isDarkTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDarkTheme
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.15), color.withOpacity(0.1)],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isDarkTheme ? Colors.white : const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: isDarkTheme ? Colors.grey[300] : Colors.grey[600],
              fontSize: 12,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

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
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.05),
                          Color.lerp(
                            _getGradientColor(1),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.02),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(
                      _getGradientColor(0),
                      Colors.black,
                      0.2,
                    )!.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Color.lerp(
                    _getGradientColor(0),
                    Colors.black,
                    0.2,
                  )!.withOpacity(0.1),
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
                        color: Color.lerp(
                          _getGradientColor(0),
                          Colors.black,
                          0.2,
                        ),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'رحلة هذه السنة',
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white : Colors.white,
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

          const SizedBox(height: 32),

          // Weekly Chart Card
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
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.lerp(
                            _getGradientColor(0),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.05),
                          Color.lerp(
                            _getGradientColor(1),
                            Colors.black,
                            0.2,
                          )!.withOpacity(0.02),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.lerp(
                      _getGradientColor(0),
                      Colors.black,
                      0.2,
                    )!.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Color.lerp(
                    _getGradientColor(0),
                    Colors.black,
                    0.2,
                  )!.withOpacity(0.1),
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
                            'التقويم السنوي',
                            style: TextStyle(
                              color: isDarkTheme ? Colors.white : Colors.white,
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
                  MonthlyProgressChart(monthlyProgress: state.weeklyProgress),
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

  void _navigateToMonthlyCalendar(DateTime selectedDate) {
    // Switch to monthly tab (index 1) and pass the selected date
    _tabController.animateTo(1);

    // Navigate to progress page with monthly tab and selected date
    context.go(
      '${AppRoutes.progress}?tab=1&date=${selectedDate.toIso8601String()}',
    );
  }
}
