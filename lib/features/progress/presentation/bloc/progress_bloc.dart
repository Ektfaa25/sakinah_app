import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/features/progress/domain/repositories/progress_repository.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressRepository _progressRepository;

  ProgressBloc({required ProgressRepository progressRepository})
    : _progressRepository = progressRepository,
      super(const ProgressInitial()) {
    on<LoadTodayProgress>(_onLoadTodayProgress);
    on<LoadWeeklyProgress>(_onLoadWeeklyProgress);
    on<LoadMonthlyProgress>(_onLoadMonthlyProgress);
    on<LoadCurrentStreak>(_onLoadCurrentStreak);
    on<LoadAchievementStats>(_onLoadAchievementStats);
    on<AddAzkarCompletion>(_onAddAzkarCompletion);
    on<UpdateDailyProgress>(_onUpdateDailyProgress);
    on<LoadMoodPatterns>(_onLoadMoodPatterns);
    on<RefreshProgress>(_onRefreshProgress);
    on<SetDailyGoal>(_onSetDailyGoal);
    on<LoadProgressInRange>(_onLoadProgressInRange);
  }

  Future<void> _onLoadTodayProgress(
    LoadTodayProgress event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final todayProgress = await _progressRepository.getProgressByDate(
        todayDate,
      );
      final currentStreak = await _progressRepository.getCurrentStreak();

      emit(
        TodayProgressLoaded(
          progress: todayProgress ?? UserProgress.empty(todayDate),
          currentStreak: currentStreak,
        ),
      );
    } catch (e) {
      emit(ProgressError('Failed to load today\'s progress: ${e.toString()}'));
    }
  }

  Future<void> _onLoadWeeklyProgress(
    LoadWeeklyProgress event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      final weeklyProgress = await _progressRepository.getWeeklyProgress(
        event.weekStart,
      );
      final currentStreak = await _progressRepository.getCurrentStreak();

      emit(
        WeeklyProgressLoaded(
          weeklyProgress: weeklyProgress,
          currentStreak: currentStreak,
        ),
      );
    } catch (e) {
      emit(ProgressError('Failed to load weekly progress: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMonthlyProgress(
    LoadMonthlyProgress event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      final monthlyProgress = await _progressRepository.getMonthlyProgress(
        event.monthStart,
      );
      final currentStreak = await _progressRepository.getCurrentStreak();

      emit(
        MonthlyProgressLoaded(
          monthlyProgress: monthlyProgress,
          currentStreak: currentStreak,
        ),
      );
    } catch (e) {
      emit(ProgressError('Failed to load monthly progress: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCurrentStreak(
    LoadCurrentStreak event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      final currentStreak = await _progressRepository.getCurrentStreak();

      if (state is ProgressLoaded) {
        final currentState = state as ProgressLoaded;
        emit(currentState.copyWith(currentStreak: currentStreak));
      } else {
        emit(StreakLoaded(currentStreak: currentStreak));
      }
    } catch (e) {
      emit(ProgressError('Failed to load current streak: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAchievementStats(
    LoadAchievementStats event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      final stats = await _progressRepository.getAchievementStats();
      final currentStreak = await _progressRepository.getCurrentStreak();

      emit(AchievementStatsLoaded(stats: stats, currentStreak: currentStreak));
    } catch (e) {
      emit(ProgressError('Failed to load achievement stats: ${e.toString()}'));
    }
  }

  Future<void> _onAddAzkarCompletion(
    AddAzkarCompletion event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      await _progressRepository.addAzkarCompletion(
        azkarId: event.azkarId,
        moodBefore: event.moodBefore,
        moodAfter: event.moodAfter,
        reflection: event.reflection,
      );

      // Reload today's progress after adding completion
      add(const LoadTodayProgress());
    } catch (e) {
      emit(ProgressError('Failed to add azkar completion: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateDailyProgress(
    UpdateDailyProgress event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      await _progressRepository.updateDailyProgress(event.progress);

      // Reload progress after update
      if (event.progress.date.day == DateTime.now().day) {
        add(const LoadTodayProgress());
      }
    } catch (e) {
      emit(ProgressError('Failed to update daily progress: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoodPatterns(
    LoadMoodPatterns event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      final moodPatterns = await _progressRepository.getMoodPatterns(
        days: event.days,
      );

      emit(MoodPatternsLoaded(moodPatterns: moodPatterns, days: event.days));
    } catch (e) {
      emit(ProgressError('Failed to load mood patterns: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshProgress(
    RefreshProgress event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      // Load all data fresh
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final todayProgress = await _progressRepository.getProgressByDate(
        todayDate,
      );
      final currentStreak = await _progressRepository.getCurrentStreak();
      final weeklyProgress = await _progressRepository.getWeeklyProgress();
      final stats = await _progressRepository.getAchievementStats();

      emit(
        FullProgressLoaded(
          todayProgress: todayProgress ?? UserProgress.empty(todayDate),
          weeklyProgress: weeklyProgress,
          currentStreak: currentStreak,
          achievementStats: stats,
        ),
      );
    } catch (e) {
      emit(ProgressError('Failed to refresh progress: ${e.toString()}'));
    }
  }

  Future<void> _onSetDailyGoal(
    SetDailyGoal event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      // Store the daily goal in settings or database
      // For now, we'll just emit the updated goal
      emit(DailyGoalUpdated(event.goal));
    } catch (e) {
      emit(ProgressError('Failed to set daily goal: ${e.toString()}'));
    }
  }

  Future<void> _onLoadProgressInRange(
    LoadProgressInRange event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      final progressList = await _progressRepository.getProgressInRange(
        event.startDate,
        event.endDate,
      );

      emit(
        ProgressInRangeLoaded(
          progressList: progressList,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    } catch (e) {
      emit(ProgressError('Failed to load progress in range: ${e.toString()}'));
    }
  }
}
