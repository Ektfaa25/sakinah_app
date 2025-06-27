import 'package:sakinah_app/core/usecases/usecase.dart';
import 'package:sakinah_app/features/mood/domain/entities/mood.dart';
import 'package:sakinah_app/features/mood/domain/repositories/mood_repository.dart';

class GetAllMoodsUseCase implements UseCase<List<Mood>, NoParams> {
  final MoodRepository _repository;

  GetAllMoodsUseCase(this._repository);

  @override
  Future<List<Mood>> call(NoParams params) async {
    return await _repository.getAllMoods();
  }
}

class TrackMoodSelectionUseCase implements UseCase<void, Mood> {
  final MoodRepository _repository;

  TrackMoodSelectionUseCase(this._repository);

  @override
  Future<void> call(Mood mood) async {
    return await _repository.trackMoodSelection(mood);
  }
}

class GetMoodHistoryUseCase implements UseCase<List<Mood>, int?> {
  final MoodRepository _repository;

  GetMoodHistoryUseCase(this._repository);

  @override
  Future<List<Mood>> call(int? limit) async {
    return await _repository.getMoodHistory(limit: limit ?? 30);
  }
}

class GetMoodPatternsUseCase implements UseCase<List<Mood>, int?> {
  final MoodRepository _repository;

  GetMoodPatternsUseCase(this._repository);

  @override
  Future<List<Mood>> call(int? limit) async {
    return await _repository.getMoodPatterns(limit: limit ?? 5);
  }
}
