part of 'mood_bloc.dart';

/// Base class for all mood events
abstract class MoodEvent extends Equatable {
  const MoodEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all available moods
class LoadMoods extends MoodEvent {
  const LoadMoods();
}

/// Event to select a mood
class SelectMood extends MoodEvent {
  final Mood mood;

  const SelectMood({required this.mood});

  @override
  List<Object?> get props => [mood];
}

/// Event to load mood history
class LoadMoodHistory extends MoodEvent {
  final int limit;

  const LoadMoodHistory({this.limit = 30});

  @override
  List<Object?> get props => [limit];
}

/// Event to load mood patterns (most frequent moods)
class LoadMoodPatterns extends MoodEvent {
  final int limit;

  const LoadMoodPatterns({this.limit = 5});

  @override
  List<Object?> get props => [limit];
}

/// Event to clear mood history
class ClearMoodHistory extends MoodEvent {
  const ClearMoodHistory();
}
