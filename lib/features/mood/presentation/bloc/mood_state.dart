part of 'mood_bloc.dart';

/// Base class for all mood states
abstract class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any mood operations
class MoodInitial extends MoodState {
  const MoodInitial();
}

/// State when moods are being loaded
class MoodLoading extends MoodState {
  const MoodLoading();
}

/// State when moods are successfully loaded
class MoodLoaded extends MoodState {
  final List<Mood> moods;
  final Mood? selectedMood;
  final List<Mood> moodHistory;
  final List<Mood> moodPatterns;

  const MoodLoaded({
    required this.moods,
    this.selectedMood,
    this.moodHistory = const [],
    this.moodPatterns = const [],
  });

  MoodLoaded copyWith({
    List<Mood>? moods,
    Mood? selectedMood,
    List<Mood>? moodHistory,
    List<Mood>? moodPatterns,
  }) {
    return MoodLoaded(
      moods: moods ?? this.moods,
      selectedMood: selectedMood ?? this.selectedMood,
      moodHistory: moodHistory ?? this.moodHistory,
      moodPatterns: moodPatterns ?? this.moodPatterns,
    );
  }

  @override
  List<Object?> get props => [moods, selectedMood, moodHistory, moodPatterns];
}

/// State when a mood has been selected
class MoodSelected extends MoodState {
  final Mood mood;
  final String message;

  const MoodSelected({required this.mood, required this.message});

  @override
  List<Object?> get props => [mood, message];
}

/// State when an error occurs
class MoodError extends MoodState {
  final String message;

  const MoodError({required this.message});

  @override
  List<Object?> get props => [message];
}
