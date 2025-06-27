import 'package:equatable/equatable.dart';

/// Represents an Azkar (Islamic remembrance/prayer) in the app
class Azkar extends Equatable {
  final int? id;
  final String arabicText;
  final String? transliteration;
  final String? translation;
  final String category;
  final List<String> associatedMoods;
  final int repetitions;
  final DateTime? createdAt;
  final bool isCustom;

  const Azkar({
    this.id,
    required this.arabicText,
    this.transliteration,
    this.translation,
    required this.category,
    required this.associatedMoods,
    this.repetitions = 1,
    this.createdAt,
    this.isCustom = false,
  });

  /// Create a copy of this azkar with updated fields
  Azkar copyWith({
    int? id,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? category,
    List<String>? associatedMoods,
    int? repetitions,
    DateTime? createdAt,
    bool? isCustom,
  }) {
    return Azkar(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      category: category ?? this.category,
      associatedMoods: associatedMoods ?? this.associatedMoods,
      repetitions: repetitions ?? this.repetitions,
      createdAt: createdAt ?? this.createdAt,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  /// Check if this azkar is suitable for a specific mood
  bool isSuitableForMood(String mood) {
    return associatedMoods.contains(mood.toLowerCase());
  }

  /// Get the display text (Arabic with fallback to transliteration)
  String get displayText =>
      arabicText.isNotEmpty ? arabicText : (transliteration ?? '');

  @override
  List<Object?> get props => [
    id,
    arabicText,
    transliteration,
    translation,
    category,
    associatedMoods,
    repetitions,
    createdAt,
    isCustom,
  ];

  @override
  String toString() =>
      'Azkar(id: $id, category: $category, moods: $associatedMoods)';

  /// Common azkar categories
  static const String categoryMorning = 'morning';
  static const String categoryEvening = 'evening';
  static const String categoryGeneral = 'general';
  static const String categoryStress = 'stress';
  static const String categoryGratitude = 'gratitude';
  static const String categorySleep = 'sleep';
  static const String categoryCustom = 'custom';

  /// Get all available categories
  static List<String> get allCategories => [
    categoryMorning,
    categoryEvening,
    categoryGeneral,
    categoryStress,
    categoryGratitude,
    categorySleep,
    categoryCustom,
  ];
}
