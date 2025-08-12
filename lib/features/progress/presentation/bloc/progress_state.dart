part of 'progress_bloc.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

abstract class ProgressLoaded extends ProgressState {
  final int currentStreak;

  const ProgressLoaded({required this.currentStreak});

  @override
  List<Object?> get props => [currentStreak];

  ProgressLoaded copyWith({int? currentStreak});
}

class TodayProgressLoaded extends ProgressLoaded {
  final UserProgress progress;

  const TodayProgressLoaded({
    required this.progress,
    required super.currentStreak,
  });

  @override
  List<Object?> get props => [progress, currentStreak];

  @override
  TodayProgressLoaded copyWith({UserProgress? progress, int? currentStreak}) {
    return TodayProgressLoaded(
      progress: progress ?? this.progress,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

class WeeklyProgressLoaded extends ProgressLoaded {
  final List<UserProgress> weeklyProgress;

  const WeeklyProgressLoaded({
    required this.weeklyProgress,
    required super.currentStreak,
  });

  @override
  List<Object?> get props => [weeklyProgress, currentStreak];

  @override
  WeeklyProgressLoaded copyWith({
    List<UserProgress>? weeklyProgress,
    int? currentStreak,
  }) {
    return WeeklyProgressLoaded(
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

class MonthlyProgressLoaded extends ProgressLoaded {
  final List<UserProgress> monthlyProgress;

  const MonthlyProgressLoaded({
    required this.monthlyProgress,
    required super.currentStreak,
  });

  @override
  List<Object?> get props => [monthlyProgress, currentStreak];

  @override
  MonthlyProgressLoaded copyWith({
    List<UserProgress>? monthlyProgress,
    int? currentStreak,
  }) {
    return MonthlyProgressLoaded(
      monthlyProgress: monthlyProgress ?? this.monthlyProgress,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

class StreakLoaded extends ProgressLoaded {
  const StreakLoaded({required super.currentStreak});

  @override
  StreakLoaded copyWith({int? currentStreak}) {
    return StreakLoaded(currentStreak: currentStreak ?? this.currentStreak);
  }
}

class AchievementStatsLoaded extends ProgressLoaded {
  final Map<String, dynamic> stats;

  const AchievementStatsLoaded({
    required this.stats,
    required super.currentStreak,
  });

  @override
  List<Object?> get props => [stats, currentStreak];

  @override
  AchievementStatsLoaded copyWith({
    Map<String, dynamic>? stats,
    int? currentStreak,
  }) {
    return AchievementStatsLoaded(
      stats: stats ?? this.stats,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}

class MoodPatternsLoaded extends ProgressState {
  final Map<String, int> moodPatterns;
  final int days;

  const MoodPatternsLoaded({required this.moodPatterns, required this.days});

  @override
  List<Object?> get props => [moodPatterns, days];
}

class FullProgressLoaded extends ProgressLoaded {
  final UserProgress todayProgress;
  final List<UserProgress> weeklyProgress;
  final Map<String, dynamic> achievementStats;

  const FullProgressLoaded({
    required this.todayProgress,
    required this.weeklyProgress,
    required super.currentStreak,
    required this.achievementStats,
  });

  @override
  List<Object?> get props => [
    todayProgress,
    weeklyProgress,
    currentStreak,
    achievementStats,
  ];

  @override
  FullProgressLoaded copyWith({
    UserProgress? todayProgress,
    List<UserProgress>? weeklyProgress,
    int? currentStreak,
    Map<String, dynamic>? achievementStats,
  }) {
    return FullProgressLoaded(
      todayProgress: todayProgress ?? this.todayProgress,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      currentStreak: currentStreak ?? this.currentStreak,
      achievementStats: achievementStats ?? this.achievementStats,
    );
  }
}

class ProgressInRangeLoaded extends ProgressState {
  final List<UserProgress> progressList;
  final DateTime startDate;
  final DateTime endDate;

  const ProgressInRangeLoaded({
    required this.progressList,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [progressList, startDate, endDate];
}

class ProgressError extends ProgressState {
  final String message;

  const ProgressError(this.message);

  @override
  List<Object?> get props => [message];
}

class DailyGoalUpdated extends ProgressState {
  final int goal;

  const DailyGoalUpdated(this.goal);

  @override
  List<Object?> get props => [goal];
}

class DailyGoalLoaded extends ProgressState {
  final int goal;

  const DailyGoalLoaded(this.goal);

  @override
  List<Object?> get props => [goal];
}
