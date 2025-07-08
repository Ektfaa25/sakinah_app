import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sakinah_app/features/mood/domain/entities/mood.dart';
import 'package:sakinah_app/features/mood/domain/repositories/mood_repository.dart';

part 'mood_event.dart';
part 'mood_state.dart';

/// Bloc for managing mood selection and mood-related state
class MoodBloc extends Bloc<MoodEvent, MoodState> {
  final MoodRepository _moodRepository;

  MoodBloc({required MoodRepository moodRepository})
    : _moodRepository = moodRepository,
      super(const MoodInitial()) {
    on<LoadMoods>(_onLoadMoods);
    on<SelectMood>(_onSelectMood);
    on<LoadMoodHistory>(_onLoadMoodHistory);
    on<LoadMoodPatterns>(_onLoadMoodPatterns);
    on<ClearMoodHistory>(_onClearMoodHistory);
  }

  Future<void> _onLoadMoods(LoadMoods event, Emitter<MoodState> emit) async {
    try {
      emit(const MoodLoading());

      final moods = await _moodRepository.getAllMoods();
      emit(
        MoodLoaded(
          moods: moods,
          selectedMood: null,
          moodHistory: const [],
          moodPatterns: const [],
        ),
      );
    } catch (e) {
      emit(MoodError(message: 'Failed to load moods: ${e.toString()}'));
    }
  }

  Future<void> _onSelectMood(SelectMood event, Emitter<MoodState> emit) async {
    try {
      // Track the mood selection
      await _moodRepository.trackMoodSelection(event.mood);

      // Update state with selected mood
      final currentState = state;
      if (currentState is MoodLoaded) {
        emit(currentState.copyWith(selectedMood: event.mood.withCurrentTime()));

        // Load updated history and patterns
        add(const LoadMoodHistory());
        add(const LoadMoodPatterns());
      } else {
        // If not in loaded state, emit mood selected state
        emit(
          MoodSelected(
            mood: event.mood.withCurrentTime(),
            message: 'Mood "${event.mood.name}" selected successfully',
          ),
        );
      }
    } catch (e) {
      emit(MoodError(message: 'Failed to select mood: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoodHistory(
    LoadMoodHistory event,
    Emitter<MoodState> emit,
  ) async {
    try {
      final history = await _moodRepository.getMoodHistory(limit: event.limit);

      final currentState = state;
      if (currentState is MoodLoaded) {
        emit(currentState.copyWith(moodHistory: history));
      }
    } catch (e) {
      // Don't emit error for history loading failure, just log it
      print('Failed to load mood history: ${e.toString()}');
    }
  }

  Future<void> _onLoadMoodPatterns(
    LoadMoodPatterns event,
    Emitter<MoodState> emit,
  ) async {
    try {
      final patterns = await _moodRepository.getMoodPatterns(
        limit: event.limit,
      );

      final currentState = state;
      if (currentState is MoodLoaded) {
        emit(currentState.copyWith(moodPatterns: patterns));
      }
    } catch (e) {
      // Don't emit error for patterns loading failure, just log it
      print('Failed to load mood patterns: ${e.toString()}');
    }
  }

  Future<void> _onClearMoodHistory(
    ClearMoodHistory event,
    Emitter<MoodState> emit,
  ) async {
    try {
      await _moodRepository.clearMoodHistory();

      final currentState = state;
      if (currentState is MoodLoaded) {
        emit(
          currentState.copyWith(moodHistory: const [], moodPatterns: const []),
        );
      }
    } catch (e) {
      emit(MoodError(message: 'Failed to clear mood history: ${e.toString()}'));
    }
  }
}
