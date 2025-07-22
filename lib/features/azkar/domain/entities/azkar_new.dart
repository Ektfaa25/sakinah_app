import 'package:equatable/equatable.dart';

/// Represents an Azkar Category in the app
class AzkarCategory extends Equatable {
  final String id;
  final String nameAr;
  final String? nameEn;
  final String? description;
  final String? icon;
  final String? color;
  final int orderIndex;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AzkarCategory({
    required this.id,
    required this.nameAr,
    this.nameEn,
    this.description,
    this.icon,
    this.color,
    required this.orderIndex,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory AzkarCategory.fromJson(Map<String, dynamic> json) {
    return AzkarCategory(
      id: json['id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: null, // No longer reading from database
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      orderIndex: json['order_index'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'description': description,
      'icon': icon,
      'color': color,
      'order_index': orderIndex,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of this category with updated fields
  AzkarCategory copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? description,
    String? icon,
    String? color,
    int? orderIndex,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AzkarCategory(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      orderIndex: orderIndex ?? this.orderIndex,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get the display name in the current locale
  String getDisplayName({bool isArabic = true}) {
    if (isArabic) {
      return nameAr;
    }
    return nameEn ?? nameAr;
  }

  /// Get the icon data for this category
  String getIconName() {
    switch (icon) {
      case 'morning':
        return 'wb_sunny';
      case 'evening':
        return 'nights_stay';
      case 'sleep':
        return 'bedtime';
      case 'prayer':
        return 'mosque';
      case 'travel':
        return 'flight';
      case 'food':
        return 'restaurant';
      case 'gratitude':
        return 'favorite';
      case 'stress_relief':
        return 'spa';
      case 'protection':
        return 'shield';
      case 'general':
      default:
        return 'menu_book';
    }
  }

  /// Get the color for this category
  String getColor() {
    return color ?? '#78909C';
  }

  @override
  List<Object?> get props => [
    id,
    nameAr,
    nameEn,
    description,
    icon,
    color,
    orderIndex,
    isActive,
    createdAt,
    updatedAt,
  ];
}

/// Represents an Azkar in the app
class Azkar extends Equatable {
  final String id;
  final String categoryId;
  final String textAr;
  final String? textEn;
  final String? transliteration;
  final String? translation;
  final String? reference;
  final String? description;
  final int repeatCount;
  final int orderIndex;
  final List<String> associatedMoods;
  final String? searchTags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Azkar({
    required this.id,
    required this.categoryId,
    required this.textAr,
    this.textEn,
    this.transliteration,
    this.translation,
    this.reference,
    this.description,
    this.repeatCount = 1,
    this.orderIndex = 0,
    this.associatedMoods = const [],
    this.searchTags,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory Azkar.fromJson(Map<String, dynamic> json) {
    // Add null checks and better error handling
    final id = json['id']?.toString();
    final categoryId = json['category_id']?.toString();
    final textAr = json['text_ar']?.toString();
    final createdAtStr = json['created_at']?.toString();

    if (id == null || id.isEmpty) {
      throw Exception('Azkar ID is required but was null or empty');
    }
    if (categoryId == null || categoryId.isEmpty) {
      throw Exception('Azkar category_id is required but was null or empty');
    }
    if (textAr == null || textAr.isEmpty) {
      throw Exception('Azkar text_ar is required but was null or empty');
    }
    if (createdAtStr == null || createdAtStr.isEmpty) {
      throw Exception('Azkar created_at is required but was null or empty');
    }

    return Azkar(
      id: id,
      categoryId: categoryId,
      textAr: textAr,
      textEn: json['text_en']?.toString(),
      transliteration: json['transliteration']?.toString(),
      translation: json['translation']?.toString(),
      reference: json['reference']?.toString(),
      description: json['description']?.toString(),
      repeatCount: json['repeat_count'] as int? ?? 1,
      orderIndex: json['order_index'] as int? ?? 0,
      associatedMoods: json['associated_moods'] != null
          ? List<String>.from(json['associated_moods'] as List)
          : <String>[],
      searchTags: json['search_tags']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(createdAtStr),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'text_ar': textAr,
      'text_en': textEn,
      'transliteration': transliteration,
      'translation': translation,
      'reference': reference,
      'description': description,
      'repeat_count': repeatCount,
      'order_index': orderIndex,
      'associated_moods': associatedMoods,
      'search_tags': searchTags,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of this azkar with updated fields
  Azkar copyWith({
    String? id,
    String? categoryId,
    String? textAr,
    String? textEn,
    String? transliteration,
    String? translation,
    String? reference,
    String? description,
    int? repeatCount,
    int? orderIndex,
    List<String>? associatedMoods,
    String? searchTags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Azkar(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      textAr: textAr ?? this.textAr,
      textEn: textEn ?? this.textEn,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      reference: reference ?? this.reference,
      description: description ?? this.description,
      repeatCount: repeatCount ?? this.repeatCount,
      orderIndex: orderIndex ?? this.orderIndex,
      associatedMoods: associatedMoods ?? this.associatedMoods,
      searchTags: searchTags ?? this.searchTags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if this azkar is suitable for a specific mood
  bool isSuitableForMood(String mood) {
    return associatedMoods.contains(mood.toLowerCase());
  }

  /// Get the display text (Arabic with fallback to transliteration)
  String get displayText =>
      textAr.isNotEmpty ? textAr : (transliteration ?? '');

  /// Get the secondary text (translation or transliteration)
  String? get secondaryText => translation ?? transliteration;

  /// Get a short preview of the azkar text
  String get previewText {
    if (textAr.length <= 100) return textAr;
    return '${textAr.substring(0, 100)}...';
  }

  /// Check if azkar has multiple repetitions
  bool get hasMultipleRepetitions => repeatCount > 1;

  /// Get formatted reference text
  String get formattedReference {
    if (reference == null) return '';
    return 'المصدر: $reference';
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    textAr,
    textEn,
    transliteration,
    translation,
    reference,
    description,
    repeatCount,
    orderIndex,
    associatedMoods,
    searchTags,
    isActive,
    createdAt,
    updatedAt,
  ];
}

/// Represents user progress for an azkar
class UserAzkarProgress extends Equatable {
  final String id;
  final String? userId;
  final String azkarId;
  final int completedCount;
  final int totalCount;
  final DateTime? lastCompletedAt;
  final int streakCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserAzkarProgress({
    required this.id,
    this.userId,
    required this.azkarId,
    this.completedCount = 0,
    this.totalCount = 0,
    this.lastCompletedAt,
    this.streakCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserAzkarProgress.fromJson(Map<String, dynamic> json) {
    return UserAzkarProgress(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      azkarId: json['azkar_id'] as String,
      completedCount: json['completed_count'] as int? ?? 0,
      totalCount: json['total_count'] as int? ?? 0,
      lastCompletedAt: json['last_completed_at'] != null
          ? DateTime.parse(json['last_completed_at'] as String)
          : null,
      streakCount: json['streak_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'azkar_id': azkarId,
      'completed_count': completedCount,
      'total_count': totalCount,
      'last_completed_at': lastCompletedAt?.toIso8601String(),
      'streak_count': streakCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy of this progress with updated fields
  UserAzkarProgress copyWith({
    String? id,
    String? userId,
    String? azkarId,
    int? completedCount,
    int? totalCount,
    DateTime? lastCompletedAt,
    int? streakCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAzkarProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      azkarId: azkarId ?? this.azkarId,
      completedCount: completedCount ?? this.completedCount,
      totalCount: totalCount ?? this.totalCount,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      streakCount: streakCount ?? this.streakCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if the azkar is completed
  bool get isCompleted => completedCount >= totalCount && totalCount > 0;

  /// Get completion percentage
  double get completionPercentage {
    if (totalCount == 0) return 0.0;
    return (completedCount / totalCount).clamp(0.0, 1.0);
  }

  /// Check if completed today
  bool get isCompletedToday {
    if (lastCompletedAt == null) return false;
    final today = DateTime.now();
    final completedDate = lastCompletedAt!;
    return today.year == completedDate.year &&
        today.month == completedDate.month &&
        today.day == completedDate.day;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    azkarId,
    completedCount,
    totalCount,
    lastCompletedAt,
    streakCount,
    createdAt,
    updatedAt,
  ];
}
