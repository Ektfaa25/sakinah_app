part of 'azkar_bloc.dart';

abstract class AzkarEvent extends Equatable {
  const AzkarEvent();

  @override
  List<Object?> get props => [];
}

class LoadAzkar extends AzkarEvent {
  const LoadAzkar();
}

class LoadAzkarByMood extends AzkarEvent {
  final String mood;

  const LoadAzkarByMood(this.mood);

  @override
  List<Object?> get props => [mood];
}

class LoadAzkarByCategory extends AzkarEvent {
  final String category;

  const LoadAzkarByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchAzkar extends AzkarEvent {
  final String query;

  const SearchAzkar(this.query);

  @override
  List<Object?> get props => [query];
}

class MarkAzkarAsCompleted extends AzkarEvent {
  final int azkarId;

  const MarkAzkarAsCompleted(this.azkarId);

  @override
  List<Object?> get props => [azkarId];
}

class MarkAzkarAsIncomplete extends AzkarEvent {
  final int azkarId;

  const MarkAzkarAsIncomplete(this.azkarId);

  @override
  List<Object?> get props => [azkarId];
}

class RefreshAzkar extends AzkarEvent {
  const RefreshAzkar();
}
