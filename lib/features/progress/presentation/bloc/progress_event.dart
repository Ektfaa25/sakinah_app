part of 'progress_bloc.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodayProgress extends ProgressEvent {
  const LoadTodayProgress();
}

class LoadWeeklyProgress extends ProgressEvent {
  final DateTime? weekStart;

  const LoadWeeklyProgress({this.weekStart});

  @override
  List<Object?> get props => [weekStart];
}

class LoadMonthlyProgress extends ProgressEvent {
  final DateTime? monthStart;

  const LoadMonthlyProgress({this.monthStart});

  @override
  List<Object?> get props => [monthStart];
}

class LoadCurrentStreak extends ProgressEvent {
  const LoadCurrentStreak();
}

class LoadAchievementStats extends ProgressEvent {
  const LoadAchievementStats();
}

class AddAzkarCompletion extends ProgressEvent {
  final int azkarId;
  final String? moodBefore;
  final String? moodAfter;
  final String? reflection;

  const AddAzkarCompletion({
    required this.azkarId,
    this.moodBefore,
    this.moodAfter,
    this.reflection,
  });

  @override
  List<Object?> get props => [azkarId, moodBefore, moodAfter, reflection];
}

class UpdateDailyProgress extends ProgressEvent {
  final UserProgress progress;

  const UpdateDailyProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

class LoadMoodPatterns extends ProgressEvent {
  final int days;

  const LoadMoodPatterns({this.days = 30});

  @override
  List<Object?> get props => [days];
}

class RefreshProgress extends ProgressEvent {
  const RefreshProgress();
}

class SetDailyGoal extends ProgressEvent {
  final int goal;

  const SetDailyGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}

class LoadProgressInRange extends ProgressEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadProgressInRange({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}
