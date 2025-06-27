import 'package:equatable/equatable.dart';

/// Represents a mood/emotional state in the app
class Mood extends Equatable {
  final String name;
  final String emoji;
  final String? description;
  final DateTime? selectedAt;

  const Mood({
    required this.name,
    required this.emoji,
    this.description,
    this.selectedAt,
  });

  /// Create a copy of this mood with updated fields
  Mood copyWith({
    String? name,
    String? emoji,
    String? description,
    DateTime? selectedAt,
  }) {
    return Mood(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      selectedAt: selectedAt ?? this.selectedAt,
    );
  }

  /// Create a mood with current timestamp
  Mood withCurrentTime() {
    return copyWith(selectedAt: DateTime.now());
  }

  @override
  List<Object?> get props => [name, emoji, description, selectedAt];

  @override
  String toString() => 'Mood(name: $name, emoji: $emoji)';

  /// Predefined moods for the app
  static const List<Mood> predefinedMoods = [
    Mood(name: 'happy', emoji: '😊', description: 'Feeling joyful and content'),
    Mood(name: 'sad', emoji: '😔', description: 'Feeling down or melancholy'),
    Mood(
      name: 'anxious',
      emoji: '😰',
      description: 'Feeling worried or nervous',
    ),
    Mood(
      name: 'grateful',
      emoji: '🙏',
      description: 'Feeling thankful and blessed',
    ),
    Mood(
      name: 'stressed',
      emoji: '😤',
      description: 'Feeling overwhelmed or pressured',
    ),
    Mood(name: 'peaceful', emoji: '😌', description: 'Feeling calm and serene'),
    Mood(
      name: 'excited',
      emoji: '🤗',
      description: 'Feeling energetic and enthusiastic',
    ),
    Mood(
      name: 'confused',
      emoji: '😕',
      description: 'Feeling uncertain or unclear',
    ),
    Mood(
      name: 'hopeful',
      emoji: '🌟',
      description: 'Feeling optimistic about the future',
    ),
    Mood(name: 'tired', emoji: '😴', description: 'Feeling exhausted or weary'),
  ];

  /// Get a predefined mood by name
  static Mood? getPredefinedMood(String name) {
    try {
      return predefinedMoods.firstWhere(
        (mood) => mood.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all mood names
  static List<String> get allMoodNames =>
      predefinedMoods.map((mood) => mood.name).toList();
}
