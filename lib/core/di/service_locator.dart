import 'package:get_it/get_it.dart';
import 'package:sakinah_app/core/database/drift_service.dart';
import 'package:sakinah_app/core/network/supabase_service.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_supabase_service.dart';

// Repository imports
import 'package:sakinah_app/features/mood/domain/repositories/mood_repository.dart';
import 'package:sakinah_app/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sakinah_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:sakinah_app/features/mood/data/repositories/mood_repository_impl.dart';
import 'package:sakinah_app/features/azkar/data/repositories/local_azkar_repository_impl.dart';
import 'package:sakinah_app/features/azkar/data/datasources/local_azkar_data_source.dart';
import 'package:sakinah_app/features/progress/data/repositories/progress_repository_impl.dart';

// BLoC imports
import 'package:sakinah_app/features/mood/presentation/bloc/mood_bloc.dart';
import 'package:sakinah_app/features/azkar/presentation/bloc/azkar_bloc.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';

/// Service locator for dependency injection
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // Core services
  await _initCoreServices();

  // Repositories
  await _initRepositories();

  // BLoCs
  await _initBlocs();

  // Use cases (will be added when needed)
  // await _initUseCases();
}

/// Initialize core services
Future<void> _initCoreServices() async {
  // Database service (singleton)
  sl.registerLazySingleton<DriftService>(() => DriftService.instance);

  // Supabase service (singleton)
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);

  // Azkar Supabase service (singleton)
  sl.registerLazySingleton<AzkarSupabaseService>(() => AzkarSupabaseService());

  // Initialize services
  await sl<DriftService>().initializeDatabase();
  await SupabaseService.initialize();
}

/// Initialize repositories
Future<void> _initRepositories() async {
  // Mood repository
  sl.registerLazySingleton<MoodRepository>(() => MoodRepositoryImpl());

  // Local azkar data source
  sl.registerLazySingleton<LocalAzkarDataSource>(() => LocalAzkarDataSource());

  // Azkar repository (using local data source)
  sl.registerLazySingleton<AzkarRepository>(
    () => LocalAzkarRepositoryImpl(sl<LocalAzkarDataSource>()),
  );

  // Progress repository
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(sl<SupabaseService>()),
  );

  // Initialize repositories
  await sl<MoodRepository>().initialize();
  await sl<AzkarRepository>().initialize();
  await sl<ProgressRepository>().initialize();
}

/// Initialize use cases (to be added when needed)
/*
Future<void> _initUseCases() async {
  // Mood use cases
  sl.registerLazySingleton(() => GetAllMoodsUseCase(sl<MoodRepository>()));
  sl.registerLazySingleton(() => TrackMoodSelectionUseCase(sl<MoodRepository>()));
  
  // Azkar use cases
  sl.registerLazySingleton(() => GetAzkarByMoodUseCase(sl<AzkarRepository>()));
  sl.registerLazySingleton(() => GetAzkarRecommendationsUseCase(sl<AzkarRepository>()));
  
  // Progress use cases
  sl.registerLazySingleton(() => UpdateDailyProgressUseCase(sl<ProgressRepository>()));
  sl.registerLazySingleton(() => GetCurrentStreakUseCase(sl<ProgressRepository>()));
}
*/

/// Initialize BLoCs
Future<void> _initBlocs() async {
  // Mood BLoC
  sl.registerFactory(() => MoodBloc(moodRepository: sl<MoodRepository>()));

  // Azkar BLoC
  sl.registerFactory(() => AzkarBloc());

  // Progress BLoC
  sl.registerFactory(
    () => ProgressBloc(progressRepository: sl<ProgressRepository>()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}

/// Convenience getters for frequently used services
DriftService get driftService => sl<DriftService>();
SupabaseService get supabaseService => sl<SupabaseService>();

// Repository getters
MoodRepository get moodRepository => sl<MoodRepository>();
AzkarRepository get azkarRepository => sl<AzkarRepository>();
ProgressRepository get progressRepository => sl<ProgressRepository>();
