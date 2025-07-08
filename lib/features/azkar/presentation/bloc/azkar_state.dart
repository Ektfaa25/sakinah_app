part of 'azkar_bloc.dart';

abstract class AzkarState extends Equatable {
  const AzkarState();

  @override
  List<Object?> get props => [];
}

class AzkarInitial extends AzkarState {
  const AzkarInitial();
}

class AzkarLoading extends AzkarState {
  const AzkarLoading();
}

class AzkarLoaded extends AzkarState {
  final List<Azkar> azkarList;
  final Set<int> completedAzkarIds;
  final String? currentCategory;
  final String? currentMood;

  const AzkarLoaded({
    required this.azkarList,
    required this.completedAzkarIds,
    this.currentCategory,
    this.currentMood,
  });

  @override
  List<Object?> get props => [
    azkarList,
    completedAzkarIds,
    currentCategory,
    currentMood,
  ];

  AzkarLoaded copyWith({
    List<Azkar>? azkarList,
    Set<int>? completedAzkarIds,
    String? currentCategory,
    String? currentMood,
  }) {
    return AzkarLoaded(
      azkarList: azkarList ?? this.azkarList,
      completedAzkarIds: completedAzkarIds ?? this.completedAzkarIds,
      currentCategory: currentCategory ?? this.currentCategory,
      currentMood: currentMood ?? this.currentMood,
    );
  }
}

class AzkarError extends AzkarState {
  final String message;

  const AzkarError(this.message);

  @override
  List<Object?> get props => [message];
}

class AzkarSearchResults extends AzkarState {
  final List<Azkar> searchResults;
  final String query;

  const AzkarSearchResults({required this.searchResults, required this.query});

  @override
  List<Object?> get props => [searchResults, query];
}
