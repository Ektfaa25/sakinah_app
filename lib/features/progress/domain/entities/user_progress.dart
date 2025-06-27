import 'package:equatable/equatable.dart';

/// Represents user progress and achievements in the app
class UserProgress extends Equatable {
  final int? id;
  final DateTime date;
  final int azkarCompleted;
  final int streakCount;
  final List<int> completedAzkarIds;
  final String? reflection;
  final String? moodBefore;
  final String? moodAfter;
  final DateTime? createdAt;

  const UserProgress({
    this.id,
    required this.date,
    required this.azkarCompleted,
    required this.streakCount,
    required this.completedAzkarIds,
    this.reflection,
    this.moodBefore,
    this.moodAfter,
    this.createdAt,
  });

  /// Create a copy of this progress with updated fields
  UserProgress copyWith({
    int? id,
    DateTime? date,
    int? azkarCompleted,
    int? streakCount,
    List<int>? completedAzkarIds,
    String? reflection,
    String? moodBefore,
    String? moodAfter,
    DateTime? createdAt,
  }) {
    return UserProgress(
      id: id ?? this.id,
      date: date ?? this.date,
      azkarCompleted: azkarCompleted ?? this.azkarCompleted,
      streakCount: streakCount ?? this.streakCount,
      completedAzkarIds: completedAzkarIds ?? this.completedAzkarIds,
      reflection: reflection ?? this.reflection,
      moodBefore: moodBefore ?? this.moodBefore,
      moodAfter: moodAfter ?? this.moodAfter,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if progress meets daily goal
  bool meetsGoal(int dailyGoal) => azkarCompleted >= dailyGoal;

  /// Get completion percentage for a goal
  double getCompletionPercentage(int dailyGoal) {
    if (dailyGoal <= 0) return 1.0;
    return (azkarCompleted / dailyGoal).clamp(0.0, 1.0);
  }

  /// Check if there was mood improvement
  bool get hasMoodImprovement {
    if (moodBefore == null || moodAfter == null) return false;

    // Simple mood improvement check (this could be more sophisticated)
    const positiveMoods = [
      'happy',
      'grateful',
      'peaceful',
      'hopeful',
      'excited',
    ];
    const negativeMoods = ['sad', 'anxious', 'stressed', 'confused', 'tired'];

    final wasNegative = negativeMoods.contains(moodBefore);
    final isPositive = positiveMoods.contains(moodAfter);

    return wasNegative && isPositive;
  }

  /// Get today's progress (convenience constructor)
  factory UserProgress.today({
    required int azkarCompleted,
    required int streakCount,
    required List<int> completedAzkarIds,
    String? reflection,
    String? moodBefore,
    String? moodAfter,
  }) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return UserProgress(
      date: todayDate,
      azkarCompleted: azkarCompleted,
      streakCount: streakCount,
      completedAzkarIds: completedAzkarIds,
      reflection: reflection,
      moodBefore: moodBefore,
      moodAfter: moodAfter,
      createdAt: DateTime.now(),
    );
  }

  /// Empty progress for a date
  factory UserProgress.empty(DateTime date) {
    return UserProgress(
      date: DateTime(date.year, date.month, date.day),
      azkarCompleted: 0,
      streakCount: 0,
      completedAzkarIds: [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    azkarCompleted,
    streakCount,
    completedAzkarIds,
    reflection,
    moodBefore,
    moodAfter,
    createdAt,
  ];

  @override
  String toString() =>
      'UserProgress(date: $date, completed: $azkarCompleted, streak: $streakCount)';
}
