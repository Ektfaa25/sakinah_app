import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';

part 'azkar_event.dart';
part 'azkar_state.dart';

class AzkarBloc extends Bloc<AzkarEvent, AzkarState> {
  List<Azkar> _allAzkar = [];
  Map<String, dynamic> _azkarDatabase = {};
  Set<int> _completedAzkarIds = {};

  AzkarBloc() : super(const AzkarInitial()) {
    on<LoadAzkar>(_onLoadAzkar);
    on<LoadAzkarByMood>(_onLoadAzkarByMood);
    on<LoadAzkarByCategory>(_onLoadAzkarByCategory);
    on<SearchAzkar>(_onSearchAzkar);
    on<MarkAzkarAsCompleted>(_onMarkAzkarAsCompleted);
    on<MarkAzkarAsIncomplete>(_onMarkAzkarAsIncomplete);
    on<RefreshAzkar>(_onRefreshAzkar);
  }

  Future<void> _onLoadAzkar(LoadAzkar event, Emitter<AzkarState> emit) async {
    try {
      emit(const AzkarLoading());

      // Load azkar database from JSON if not already loaded
      if (_azkarDatabase.isEmpty) {
        await _loadAzkarDatabase();
      }

      // Convert JSON data to Azkar entities
      _allAzkar = _convertJsonToAzkar(
        _azkarDatabase['azkar_database']['azkar'],
      );

      emit(
        AzkarLoaded(
          azkarList: _allAzkar,
          completedAzkarIds: _completedAzkarIds,
        ),
      );
    } catch (e) {
      emit(AzkarError('Failed to load azkar: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAzkarByMood(
    LoadAzkarByMood event,
    Emitter<AzkarState> emit,
  ) async {
    try {
      emit(const AzkarLoading());

      if (_azkarDatabase.isEmpty) {
        await _loadAzkarDatabase();
      }

      if (_allAzkar.isEmpty) {
        _allAzkar = _convertJsonToAzkar(
          _azkarDatabase['azkar_database']['azkar'],
        );
      }

      // Get categories associated with the mood
      final moodMappings = _azkarDatabase['azkar_database']['mood_mappings'];
      final categories = List<String>.from(moodMappings[event.mood] ?? []);

      // Filter azkar by mood or associated categories
      final filteredAzkar = _allAzkar.where((azkar) {
        return azkar.associatedMoods.contains(event.mood) ||
            categories.contains(azkar.category);
      }).toList();

      emit(
        AzkarLoaded(
          azkarList: filteredAzkar,
          completedAzkarIds: _completedAzkarIds,
          currentMood: event.mood,
        ),
      );
    } catch (e) {
      emit(AzkarError('Failed to load azkar for mood: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAzkarByCategory(
    LoadAzkarByCategory event,
    Emitter<AzkarState> emit,
  ) async {
    try {
      emit(const AzkarLoading());

      if (_azkarDatabase.isEmpty) {
        await _loadAzkarDatabase();
      }

      if (_allAzkar.isEmpty) {
        _allAzkar = _convertJsonToAzkar(
          _azkarDatabase['azkar_database']['azkar'],
        );
      }

      // Filter azkar by category
      final filteredAzkar = _allAzkar
          .where((azkar) => azkar.category == event.category)
          .toList();

      emit(
        AzkarLoaded(
          azkarList: filteredAzkar,
          completedAzkarIds: _completedAzkarIds,
          currentCategory: event.category,
        ),
      );
    } catch (e) {
      emit(AzkarError('Failed to load azkar for category: ${e.toString()}'));
    }
  }

  Future<void> _onSearchAzkar(
    SearchAzkar event,
    Emitter<AzkarState> emit,
  ) async {
    try {
      if (_allAzkar.isEmpty) {
        await _loadAzkarDatabase();
        _allAzkar = _convertJsonToAzkar(
          _azkarDatabase['azkar_database']['azkar'],
        );
      }

      final query = event.query.toLowerCase();
      final searchResults = _allAzkar.where((azkar) {
        return azkar.arabicText.toLowerCase().contains(query) ||
            (azkar.translation?.toLowerCase().contains(query) ?? false) ||
            (azkar.transliteration?.toLowerCase().contains(query) ?? false) ||
            azkar.category.toLowerCase().contains(query);
      }).toList();

      emit(
        AzkarSearchResults(searchResults: searchResults, query: event.query),
      );
    } catch (e) {
      emit(AzkarError('Failed to search azkar: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAzkarAsCompleted(
    MarkAzkarAsCompleted event,
    Emitter<AzkarState> emit,
  ) async {
    try {
      _completedAzkarIds.add(event.azkarId);

      // Update the current state with new completion status
      if (state is AzkarLoaded) {
        final currentState = state as AzkarLoaded;
        emit(
          currentState.copyWith(
            completedAzkarIds: Set.from(_completedAzkarIds),
          ),
        );
      }

      // TODO: Persist completion status to local database
      print('Azkar ${event.azkarId} marked as completed');
    } catch (e) {
      emit(AzkarError('Failed to mark azkar as completed: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAzkarAsIncomplete(
    MarkAzkarAsIncomplete event,
    Emitter<AzkarState> emit,
  ) async {
    try {
      _completedAzkarIds.remove(event.azkarId);

      // Update the current state with new completion status
      if (state is AzkarLoaded) {
        final currentState = state as AzkarLoaded;
        emit(
          currentState.copyWith(
            completedAzkarIds: Set.from(_completedAzkarIds),
          ),
        );
      }

      // TODO: Persist completion status to local database
      print('Azkar ${event.azkarId} marked as incomplete');
    } catch (e) {
      emit(AzkarError('Failed to mark azkar as incomplete: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshAzkar(
    RefreshAzkar event,
    Emitter<AzkarState> emit,
  ) async {
    try {
      emit(const AzkarLoading());

      // Reload azkar database
      await _loadAzkarDatabase();
      _allAzkar = _convertJsonToAzkar(
        _azkarDatabase['azkar_database']['azkar'],
      );

      emit(
        AzkarLoaded(
          azkarList: _allAzkar,
          completedAzkarIds: _completedAzkarIds,
        ),
      );
    } catch (e) {
      emit(AzkarError('Failed to refresh azkar: ${e.toString()}'));
    }
  }

  Future<void> _loadAzkarDatabase() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/azkar_database.json',
      );
      _azkarDatabase = json.decode(jsonString);
    } catch (e) {
      throw Exception('Failed to load azkar database: $e');
    }
  }

  List<Azkar> _convertJsonToAzkar(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Azkar(
        id: json['id'],
        arabicText: json['arabic_text'],
        transliteration: json['transliteration'],
        translation: json['translation'],
        category: json['category'],
        associatedMoods: List<String>.from(json['associated_moods'] ?? []),
        repetitions: json['repetitions'] ?? 1,
      );
    }).toList();
  }

  // Getter for categories
  Map<String, dynamic> get categories {
    if (_azkarDatabase.isNotEmpty) {
      return _azkarDatabase['azkar_database']['categories'] ?? {};
    }
    return {};
  }

  // Getter for mood mappings
  Map<String, dynamic> get moodMappings {
    if (_azkarDatabase.isNotEmpty) {
      return _azkarDatabase['azkar_database']['mood_mappings'] ?? {};
    }
    return {};
  }
}
