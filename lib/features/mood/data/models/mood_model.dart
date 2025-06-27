import 'package:sakinah_app/features/mood/domain/entities/mood.dart';

class MoodModel extends Mood {
  const MoodModel({
    required super.name,
    required super.emoji,
    super.description,
    super.selectedAt,
  });

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String?,
      selectedAt: json['selected_at'] != null
          ? DateTime.parse(json['selected_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
      'description': description,
      'selected_at': selectedAt?.toIso8601String(),
    };
  }

  @override
  Mood copyWith({
    String? name,
    String? emoji,
    String? description,
    DateTime? selectedAt,
  }) {
    return MoodModel(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      selectedAt: selectedAt ?? this.selectedAt,
    );
  }
}
