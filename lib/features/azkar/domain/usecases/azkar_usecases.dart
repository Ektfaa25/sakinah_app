import 'package:sakinah_app/core/usecases/usecase.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/features/azkar/domain/repositories/azkar_repository.dart';

class GetAzkarByMoodUseCase implements UseCase<List<Azkar>, String> {
  final AzkarRepository _repository;

  GetAzkarByMoodUseCase(this._repository);

  @override
  Future<List<Azkar>> call(String mood) async {
    return await _repository.getAzkarByMood(mood);
  }
}

class CreateCustomAzkarUseCase implements UseCase<int, Azkar> {
  final AzkarRepository _repository;

  CreateCustomAzkarUseCase(this._repository);

  @override
  Future<int> call(Azkar azkar) async {
    return await _repository.addAzkar(azkar);
  }
}

class GetAllAzkarUseCase implements UseCase<List<Azkar>, NoParams> {
  final AzkarRepository _repository;

  GetAllAzkarUseCase(this._repository);

  @override
  Future<List<Azkar>> call(NoParams params) async {
    return await _repository.getAllAzkar();
  }
}

class ImportDefaultAzkarUseCase implements UseCase<void, NoParams> {
  final AzkarRepository _repository;

  ImportDefaultAzkarUseCase(this._repository);

  @override
  Future<void> call(NoParams params) async {
    return await _repository.importDefaultAzkar();
  }
}
