// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MoodEntriesTable extends MoodEntries
    with TableInfo<$MoodEntriesTable, MoodEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, mood, emoji, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MoodEntriesTable createAlias(String alias) {
    return $MoodEntriesTable(attachedDatabase, alias);
  }
}

class MoodEntry extends DataClass implements Insertable<MoodEntry> {
  final int id;
  final String mood;
  final String emoji;
  final DateTime createdAt;
  const MoodEntry({
    required this.id,
    required this.mood,
    required this.emoji,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mood'] = Variable<String>(mood);
    map['emoji'] = Variable<String>(emoji);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MoodEntriesCompanion toCompanion(bool nullToAbsent) {
    return MoodEntriesCompanion(
      id: Value(id),
      mood: Value(mood),
      emoji: Value(emoji),
      createdAt: Value(createdAt),
    );
  }

  factory MoodEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodEntry(
      id: serializer.fromJson<int>(json['id']),
      mood: serializer.fromJson<String>(json['mood']),
      emoji: serializer.fromJson<String>(json['emoji']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mood': serializer.toJson<String>(mood),
      'emoji': serializer.toJson<String>(emoji),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MoodEntry copyWith({
    int? id,
    String? mood,
    String? emoji,
    DateTime? createdAt,
  }) => MoodEntry(
    id: id ?? this.id,
    mood: mood ?? this.mood,
    emoji: emoji ?? this.emoji,
    createdAt: createdAt ?? this.createdAt,
  );
  MoodEntry copyWithCompanion(MoodEntriesCompanion data) {
    return MoodEntry(
      id: data.id.present ? data.id.value : this.id,
      mood: data.mood.present ? data.mood.value : this.mood,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntry(')
          ..write('id: $id, ')
          ..write('mood: $mood, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mood, emoji, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodEntry &&
          other.id == this.id &&
          other.mood == this.mood &&
          other.emoji == this.emoji &&
          other.createdAt == this.createdAt);
}

class MoodEntriesCompanion extends UpdateCompanion<MoodEntry> {
  final Value<int> id;
  final Value<String> mood;
  final Value<String> emoji;
  final Value<DateTime> createdAt;
  const MoodEntriesCompanion({
    this.id = const Value.absent(),
    this.mood = const Value.absent(),
    this.emoji = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MoodEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String mood,
    required String emoji,
    this.createdAt = const Value.absent(),
  }) : mood = Value(mood),
       emoji = Value(emoji);
  static Insertable<MoodEntry> custom({
    Expression<int>? id,
    Expression<String>? mood,
    Expression<String>? emoji,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mood != null) 'mood': mood,
      if (emoji != null) 'emoji': emoji,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MoodEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? mood,
    Value<String>? emoji,
    Value<DateTime>? createdAt,
  }) {
    return MoodEntriesCompanion(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      emoji: emoji ?? this.emoji,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodEntriesCompanion(')
          ..write('id: $id, ')
          ..write('mood: $mood, ')
          ..write('emoji: $emoji, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AzkarEntriesTable extends AzkarEntries
    with TableInfo<$AzkarEntriesTable, AzkarEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AzkarEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _arabicTextMeta = const VerificationMeta(
    'arabicText',
  );
  @override
  late final GeneratedColumn<String> arabicText = GeneratedColumn<String>(
    'arabic_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _associatedMoodsMeta = const VerificationMeta(
    'associatedMoods',
  );
  @override
  late final GeneratedColumn<String> associatedMoods = GeneratedColumn<String>(
    'associated_moods',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    arabicText,
    transliteration,
    translation,
    category,
    associatedMoods,
    repetitions,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'azkar_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AzkarEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('associated_moods')) {
      context.handle(
        _associatedMoodsMeta,
        associatedMoods.isAcceptableOrUnknown(
          data['associated_moods']!,
          _associatedMoodsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_associatedMoodsMeta);
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AzkarEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AzkarEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      ),
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      associatedMoods: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}associated_moods'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AzkarEntriesTable createAlias(String alias) {
    return $AzkarEntriesTable(attachedDatabase, alias);
  }
}

class AzkarEntry extends DataClass implements Insertable<AzkarEntry> {
  final int id;
  final String arabicText;
  final String? transliteration;
  final String? translation;
  final String category;
  final String associatedMoods;
  final int repetitions;
  final DateTime createdAt;
  const AzkarEntry({
    required this.id,
    required this.arabicText,
    this.transliteration,
    this.translation,
    required this.category,
    required this.associatedMoods,
    required this.repetitions,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['arabic_text'] = Variable<String>(arabicText);
    if (!nullToAbsent || transliteration != null) {
      map['transliteration'] = Variable<String>(transliteration);
    }
    if (!nullToAbsent || translation != null) {
      map['translation'] = Variable<String>(translation);
    }
    map['category'] = Variable<String>(category);
    map['associated_moods'] = Variable<String>(associatedMoods);
    map['repetitions'] = Variable<int>(repetitions);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AzkarEntriesCompanion toCompanion(bool nullToAbsent) {
    return AzkarEntriesCompanion(
      id: Value(id),
      arabicText: Value(arabicText),
      transliteration: transliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(transliteration),
      translation: translation == null && nullToAbsent
          ? const Value.absent()
          : Value(translation),
      category: Value(category),
      associatedMoods: Value(associatedMoods),
      repetitions: Value(repetitions),
      createdAt: Value(createdAt),
    );
  }

  factory AzkarEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AzkarEntry(
      id: serializer.fromJson<int>(json['id']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      transliteration: serializer.fromJson<String?>(json['transliteration']),
      translation: serializer.fromJson<String?>(json['translation']),
      category: serializer.fromJson<String>(json['category']),
      associatedMoods: serializer.fromJson<String>(json['associatedMoods']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'arabicText': serializer.toJson<String>(arabicText),
      'transliteration': serializer.toJson<String?>(transliteration),
      'translation': serializer.toJson<String?>(translation),
      'category': serializer.toJson<String>(category),
      'associatedMoods': serializer.toJson<String>(associatedMoods),
      'repetitions': serializer.toJson<int>(repetitions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AzkarEntry copyWith({
    int? id,
    String? arabicText,
    Value<String?> transliteration = const Value.absent(),
    Value<String?> translation = const Value.absent(),
    String? category,
    String? associatedMoods,
    int? repetitions,
    DateTime? createdAt,
  }) => AzkarEntry(
    id: id ?? this.id,
    arabicText: arabicText ?? this.arabicText,
    transliteration: transliteration.present
        ? transliteration.value
        : this.transliteration,
    translation: translation.present ? translation.value : this.translation,
    category: category ?? this.category,
    associatedMoods: associatedMoods ?? this.associatedMoods,
    repetitions: repetitions ?? this.repetitions,
    createdAt: createdAt ?? this.createdAt,
  );
  AzkarEntry copyWithCompanion(AzkarEntriesCompanion data) {
    return AzkarEntry(
      id: data.id.present ? data.id.value : this.id,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      category: data.category.present ? data.category.value : this.category,
      associatedMoods: data.associatedMoods.present
          ? data.associatedMoods.value
          : this.associatedMoods,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AzkarEntry(')
          ..write('id: $id, ')
          ..write('arabicText: $arabicText, ')
          ..write('transliteration: $transliteration, ')
          ..write('translation: $translation, ')
          ..write('category: $category, ')
          ..write('associatedMoods: $associatedMoods, ')
          ..write('repetitions: $repetitions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    arabicText,
    transliteration,
    translation,
    category,
    associatedMoods,
    repetitions,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AzkarEntry &&
          other.id == this.id &&
          other.arabicText == this.arabicText &&
          other.transliteration == this.transliteration &&
          other.translation == this.translation &&
          other.category == this.category &&
          other.associatedMoods == this.associatedMoods &&
          other.repetitions == this.repetitions &&
          other.createdAt == this.createdAt);
}

class AzkarEntriesCompanion extends UpdateCompanion<AzkarEntry> {
  final Value<int> id;
  final Value<String> arabicText;
  final Value<String?> transliteration;
  final Value<String?> translation;
  final Value<String> category;
  final Value<String> associatedMoods;
  final Value<int> repetitions;
  final Value<DateTime> createdAt;
  const AzkarEntriesCompanion({
    this.id = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.translation = const Value.absent(),
    this.category = const Value.absent(),
    this.associatedMoods = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AzkarEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String arabicText,
    this.transliteration = const Value.absent(),
    this.translation = const Value.absent(),
    required String category,
    required String associatedMoods,
    this.repetitions = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : arabicText = Value(arabicText),
       category = Value(category),
       associatedMoods = Value(associatedMoods);
  static Insertable<AzkarEntry> custom({
    Expression<int>? id,
    Expression<String>? arabicText,
    Expression<String>? transliteration,
    Expression<String>? translation,
    Expression<String>? category,
    Expression<String>? associatedMoods,
    Expression<int>? repetitions,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arabicText != null) 'arabic_text': arabicText,
      if (transliteration != null) 'transliteration': transliteration,
      if (translation != null) 'translation': translation,
      if (category != null) 'category': category,
      if (associatedMoods != null) 'associated_moods': associatedMoods,
      if (repetitions != null) 'repetitions': repetitions,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AzkarEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? arabicText,
    Value<String?>? transliteration,
    Value<String?>? translation,
    Value<String>? category,
    Value<String>? associatedMoods,
    Value<int>? repetitions,
    Value<DateTime>? createdAt,
  }) {
    return AzkarEntriesCompanion(
      id: id ?? this.id,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      category: category ?? this.category,
      associatedMoods: associatedMoods ?? this.associatedMoods,
      repetitions: repetitions ?? this.repetitions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (associatedMoods.present) {
      map['associated_moods'] = Variable<String>(associatedMoods.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AzkarEntriesCompanion(')
          ..write('id: $id, ')
          ..write('arabicText: $arabicText, ')
          ..write('transliteration: $transliteration, ')
          ..write('translation: $translation, ')
          ..write('category: $category, ')
          ..write('associatedMoods: $associatedMoods, ')
          ..write('repetitions: $repetitions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProgressEntriesTable extends ProgressEntries
    with TableInfo<$ProgressEntriesTable, ProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _azkarCompletedMeta = const VerificationMeta(
    'azkarCompleted',
  );
  @override
  late final GeneratedColumn<int> azkarCompleted = GeneratedColumn<int>(
    'azkar_completed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakCountMeta = const VerificationMeta(
    'streakCount',
  );
  @override
  late final GeneratedColumn<int> streakCount = GeneratedColumn<int>(
    'streak_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedAzkarIdsMeta = const VerificationMeta(
    'completedAzkarIds',
  );
  @override
  late final GeneratedColumn<String> completedAzkarIds =
      GeneratedColumn<String>(
        'completed_azkar_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _reflectionMeta = const VerificationMeta(
    'reflection',
  );
  @override
  late final GeneratedColumn<String> reflection = GeneratedColumn<String>(
    'reflection',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodBeforeMeta = const VerificationMeta(
    'moodBefore',
  );
  @override
  late final GeneratedColumn<String> moodBefore = GeneratedColumn<String>(
    'mood_before',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodAfterMeta = const VerificationMeta(
    'moodAfter',
  );
  @override
  late final GeneratedColumn<String> moodAfter = GeneratedColumn<String>(
    'mood_after',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
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
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('azkar_completed')) {
      context.handle(
        _azkarCompletedMeta,
        azkarCompleted.isAcceptableOrUnknown(
          data['azkar_completed']!,
          _azkarCompletedMeta,
        ),
      );
    }
    if (data.containsKey('streak_count')) {
      context.handle(
        _streakCountMeta,
        streakCount.isAcceptableOrUnknown(
          data['streak_count']!,
          _streakCountMeta,
        ),
      );
    }
    if (data.containsKey('completed_azkar_ids')) {
      context.handle(
        _completedAzkarIdsMeta,
        completedAzkarIds.isAcceptableOrUnknown(
          data['completed_azkar_ids']!,
          _completedAzkarIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAzkarIdsMeta);
    }
    if (data.containsKey('reflection')) {
      context.handle(
        _reflectionMeta,
        reflection.isAcceptableOrUnknown(data['reflection']!, _reflectionMeta),
      );
    }
    if (data.containsKey('mood_before')) {
      context.handle(
        _moodBeforeMeta,
        moodBefore.isAcceptableOrUnknown(data['mood_before']!, _moodBeforeMeta),
      );
    }
    if (data.containsKey('mood_after')) {
      context.handle(
        _moodAfterMeta,
        moodAfter.isAcceptableOrUnknown(data['mood_after']!, _moodAfterMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      azkarCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}azkar_completed'],
      )!,
      streakCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_count'],
      )!,
      completedAzkarIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_azkar_ids'],
      )!,
      reflection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection'],
      ),
      moodBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_before'],
      ),
      moodAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_after'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProgressEntriesTable createAlias(String alias) {
    return $ProgressEntriesTable(attachedDatabase, alias);
  }
}

class ProgressEntry extends DataClass implements Insertable<ProgressEntry> {
  final int id;
  final DateTime date;
  final int azkarCompleted;
  final int streakCount;
  final String completedAzkarIds;
  final String? reflection;
  final String? moodBefore;
  final String? moodAfter;
  final DateTime createdAt;
  const ProgressEntry({
    required this.id,
    required this.date,
    required this.azkarCompleted,
    required this.streakCount,
    required this.completedAzkarIds,
    this.reflection,
    this.moodBefore,
    this.moodAfter,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['azkar_completed'] = Variable<int>(azkarCompleted);
    map['streak_count'] = Variable<int>(streakCount);
    map['completed_azkar_ids'] = Variable<String>(completedAzkarIds);
    if (!nullToAbsent || reflection != null) {
      map['reflection'] = Variable<String>(reflection);
    }
    if (!nullToAbsent || moodBefore != null) {
      map['mood_before'] = Variable<String>(moodBefore);
    }
    if (!nullToAbsent || moodAfter != null) {
      map['mood_after'] = Variable<String>(moodAfter);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProgressEntriesCompanion(
      id: Value(id),
      date: Value(date),
      azkarCompleted: Value(azkarCompleted),
      streakCount: Value(streakCount),
      completedAzkarIds: Value(completedAzkarIds),
      reflection: reflection == null && nullToAbsent
          ? const Value.absent()
          : Value(reflection),
      moodBefore: moodBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(moodBefore),
      moodAfter: moodAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(moodAfter),
      createdAt: Value(createdAt),
    );
  }

  factory ProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      azkarCompleted: serializer.fromJson<int>(json['azkarCompleted']),
      streakCount: serializer.fromJson<int>(json['streakCount']),
      completedAzkarIds: serializer.fromJson<String>(json['completedAzkarIds']),
      reflection: serializer.fromJson<String?>(json['reflection']),
      moodBefore: serializer.fromJson<String?>(json['moodBefore']),
      moodAfter: serializer.fromJson<String?>(json['moodAfter']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'azkarCompleted': serializer.toJson<int>(azkarCompleted),
      'streakCount': serializer.toJson<int>(streakCount),
      'completedAzkarIds': serializer.toJson<String>(completedAzkarIds),
      'reflection': serializer.toJson<String?>(reflection),
      'moodBefore': serializer.toJson<String?>(moodBefore),
      'moodAfter': serializer.toJson<String?>(moodAfter),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProgressEntry copyWith({
    int? id,
    DateTime? date,
    int? azkarCompleted,
    int? streakCount,
    String? completedAzkarIds,
    Value<String?> reflection = const Value.absent(),
    Value<String?> moodBefore = const Value.absent(),
    Value<String?> moodAfter = const Value.absent(),
    DateTime? createdAt,
  }) => ProgressEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    azkarCompleted: azkarCompleted ?? this.azkarCompleted,
    streakCount: streakCount ?? this.streakCount,
    completedAzkarIds: completedAzkarIds ?? this.completedAzkarIds,
    reflection: reflection.present ? reflection.value : this.reflection,
    moodBefore: moodBefore.present ? moodBefore.value : this.moodBefore,
    moodAfter: moodAfter.present ? moodAfter.value : this.moodAfter,
    createdAt: createdAt ?? this.createdAt,
  );
  ProgressEntry copyWithCompanion(ProgressEntriesCompanion data) {
    return ProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      azkarCompleted: data.azkarCompleted.present
          ? data.azkarCompleted.value
          : this.azkarCompleted,
      streakCount: data.streakCount.present
          ? data.streakCount.value
          : this.streakCount,
      completedAzkarIds: data.completedAzkarIds.present
          ? data.completedAzkarIds.value
          : this.completedAzkarIds,
      reflection: data.reflection.present
          ? data.reflection.value
          : this.reflection,
      moodBefore: data.moodBefore.present
          ? data.moodBefore.value
          : this.moodBefore,
      moodAfter: data.moodAfter.present ? data.moodAfter.value : this.moodAfter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('azkarCompleted: $azkarCompleted, ')
          ..write('streakCount: $streakCount, ')
          ..write('completedAzkarIds: $completedAzkarIds, ')
          ..write('reflection: $reflection, ')
          ..write('moodBefore: $moodBefore, ')
          ..write('moodAfter: $moodAfter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    azkarCompleted,
    streakCount,
    completedAzkarIds,
    reflection,
    moodBefore,
    moodAfter,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.azkarCompleted == this.azkarCompleted &&
          other.streakCount == this.streakCount &&
          other.completedAzkarIds == this.completedAzkarIds &&
          other.reflection == this.reflection &&
          other.moodBefore == this.moodBefore &&
          other.moodAfter == this.moodAfter &&
          other.createdAt == this.createdAt);
}

class ProgressEntriesCompanion extends UpdateCompanion<ProgressEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> azkarCompleted;
  final Value<int> streakCount;
  final Value<String> completedAzkarIds;
  final Value<String?> reflection;
  final Value<String?> moodBefore;
  final Value<String?> moodAfter;
  final Value<DateTime> createdAt;
  const ProgressEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.azkarCompleted = const Value.absent(),
    this.streakCount = const Value.absent(),
    this.completedAzkarIds = const Value.absent(),
    this.reflection = const Value.absent(),
    this.moodBefore = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProgressEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.azkarCompleted = const Value.absent(),
    this.streakCount = const Value.absent(),
    required String completedAzkarIds,
    this.reflection = const Value.absent(),
    this.moodBefore = const Value.absent(),
    this.moodAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       completedAzkarIds = Value(completedAzkarIds);
  static Insertable<ProgressEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? azkarCompleted,
    Expression<int>? streakCount,
    Expression<String>? completedAzkarIds,
    Expression<String>? reflection,
    Expression<String>? moodBefore,
    Expression<String>? moodAfter,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (azkarCompleted != null) 'azkar_completed': azkarCompleted,
      if (streakCount != null) 'streak_count': streakCount,
      if (completedAzkarIds != null) 'completed_azkar_ids': completedAzkarIds,
      if (reflection != null) 'reflection': reflection,
      if (moodBefore != null) 'mood_before': moodBefore,
      if (moodAfter != null) 'mood_after': moodAfter,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProgressEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? azkarCompleted,
    Value<int>? streakCount,
    Value<String>? completedAzkarIds,
    Value<String?>? reflection,
    Value<String?>? moodBefore,
    Value<String?>? moodAfter,
    Value<DateTime>? createdAt,
  }) {
    return ProgressEntriesCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (azkarCompleted.present) {
      map['azkar_completed'] = Variable<int>(azkarCompleted.value);
    }
    if (streakCount.present) {
      map['streak_count'] = Variable<int>(streakCount.value);
    }
    if (completedAzkarIds.present) {
      map['completed_azkar_ids'] = Variable<String>(completedAzkarIds.value);
    }
    if (reflection.present) {
      map['reflection'] = Variable<String>(reflection.value);
    }
    if (moodBefore.present) {
      map['mood_before'] = Variable<String>(moodBefore.value);
    }
    if (moodAfter.present) {
      map['mood_after'] = Variable<String>(moodAfter.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('azkarCompleted: $azkarCompleted, ')
          ..write('streakCount: $streakCount, ')
          ..write('completedAzkarIds: $completedAzkarIds, ')
          ..write('reflection: $reflection, ')
          ..write('moodBefore: $moodBefore, ')
          ..write('moodAfter: $moodAfter, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSettingsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSettingsEntry extends DataClass
    implements Insertable<UserSettingsEntry> {
  final int id;
  final String key;
  final String value;
  final DateTime updatedAt;
  const UserSettingsEntry({
    required this.id,
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSettingsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsEntry(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSettingsEntry copyWith({
    int? id,
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => UserSettingsEntry(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserSettingsEntry copyWithCompanion(UserSettingsCompanion data) {
    return UserSettingsEntry(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsEntry(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsEntry &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsCompanion extends UpdateCompanion<UserSettingsEntry> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<UserSettingsEntry> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MoodEntriesTable moodEntries = $MoodEntriesTable(this);
  late final $AzkarEntriesTable azkarEntries = $AzkarEntriesTable(this);
  late final $ProgressEntriesTable progressEntries = $ProgressEntriesTable(
    this,
  );
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    moodEntries,
    azkarEntries,
    progressEntries,
    userSettings,
  ];
}

typedef $$MoodEntriesTableCreateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<int> id,
      required String mood,
      required String emoji,
      Value<DateTime> createdAt,
    });
typedef $$MoodEntriesTableUpdateCompanionBuilder =
    MoodEntriesCompanion Function({
      Value<int> id,
      Value<String> mood,
      Value<String> emoji,
      Value<DateTime> createdAt,
    });

class $$MoodEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodEntriesTable> {
  $$MoodEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MoodEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodEntriesTable,
          MoodEntry,
          $$MoodEntriesTableFilterComposer,
          $$MoodEntriesTableOrderingComposer,
          $$MoodEntriesTableAnnotationComposer,
          $$MoodEntriesTableCreateCompanionBuilder,
          $$MoodEntriesTableUpdateCompanionBuilder,
          (
            MoodEntry,
            BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>,
          ),
          MoodEntry,
          PrefetchHooks Function()
        > {
  $$MoodEntriesTableTableManager(_$AppDatabase db, $MoodEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<String> emoji = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MoodEntriesCompanion(
                id: id,
                mood: mood,
                emoji: emoji,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String mood,
                required String emoji,
                Value<DateTime> createdAt = const Value.absent(),
              }) => MoodEntriesCompanion.insert(
                id: id,
                mood: mood,
                emoji: emoji,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodEntriesTable,
      MoodEntry,
      $$MoodEntriesTableFilterComposer,
      $$MoodEntriesTableOrderingComposer,
      $$MoodEntriesTableAnnotationComposer,
      $$MoodEntriesTableCreateCompanionBuilder,
      $$MoodEntriesTableUpdateCompanionBuilder,
      (MoodEntry, BaseReferences<_$AppDatabase, $MoodEntriesTable, MoodEntry>),
      MoodEntry,
      PrefetchHooks Function()
    >;
typedef $$AzkarEntriesTableCreateCompanionBuilder =
    AzkarEntriesCompanion Function({
      Value<int> id,
      required String arabicText,
      Value<String?> transliteration,
      Value<String?> translation,
      required String category,
      required String associatedMoods,
      Value<int> repetitions,
      Value<DateTime> createdAt,
    });
typedef $$AzkarEntriesTableUpdateCompanionBuilder =
    AzkarEntriesCompanion Function({
      Value<int> id,
      Value<String> arabicText,
      Value<String?> transliteration,
      Value<String?> translation,
      Value<String> category,
      Value<String> associatedMoods,
      Value<int> repetitions,
      Value<DateTime> createdAt,
    });

class $$AzkarEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AzkarEntriesTable> {
  $$AzkarEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get associatedMoods => $composableBuilder(
    column: $table.associatedMoods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AzkarEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AzkarEntriesTable> {
  $$AzkarEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get associatedMoods => $composableBuilder(
    column: $table.associatedMoods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AzkarEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AzkarEntriesTable> {
  $$AzkarEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get associatedMoods => $composableBuilder(
    column: $table.associatedMoods,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AzkarEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AzkarEntriesTable,
          AzkarEntry,
          $$AzkarEntriesTableFilterComposer,
          $$AzkarEntriesTableOrderingComposer,
          $$AzkarEntriesTableAnnotationComposer,
          $$AzkarEntriesTableCreateCompanionBuilder,
          $$AzkarEntriesTableUpdateCompanionBuilder,
          (
            AzkarEntry,
            BaseReferences<_$AppDatabase, $AzkarEntriesTable, AzkarEntry>,
          ),
          AzkarEntry,
          PrefetchHooks Function()
        > {
  $$AzkarEntriesTableTableManager(_$AppDatabase db, $AzkarEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AzkarEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AzkarEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AzkarEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> associatedMoods = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AzkarEntriesCompanion(
                id: id,
                arabicText: arabicText,
                transliteration: transliteration,
                translation: translation,
                category: category,
                associatedMoods: associatedMoods,
                repetitions: repetitions,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String arabicText,
                Value<String?> transliteration = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                required String category,
                required String associatedMoods,
                Value<int> repetitions = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AzkarEntriesCompanion.insert(
                id: id,
                arabicText: arabicText,
                transliteration: transliteration,
                translation: translation,
                category: category,
                associatedMoods: associatedMoods,
                repetitions: repetitions,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AzkarEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AzkarEntriesTable,
      AzkarEntry,
      $$AzkarEntriesTableFilterComposer,
      $$AzkarEntriesTableOrderingComposer,
      $$AzkarEntriesTableAnnotationComposer,
      $$AzkarEntriesTableCreateCompanionBuilder,
      $$AzkarEntriesTableUpdateCompanionBuilder,
      (
        AzkarEntry,
        BaseReferences<_$AppDatabase, $AzkarEntriesTable, AzkarEntry>,
      ),
      AzkarEntry,
      PrefetchHooks Function()
    >;
typedef $$ProgressEntriesTableCreateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<int> azkarCompleted,
      Value<int> streakCount,
      required String completedAzkarIds,
      Value<String?> reflection,
      Value<String?> moodBefore,
      Value<String?> moodAfter,
      Value<DateTime> createdAt,
    });
typedef $$ProgressEntriesTableUpdateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> azkarCompleted,
      Value<int> streakCount,
      Value<String> completedAzkarIds,
      Value<String?> reflection,
      Value<String?> moodBefore,
      Value<String?> moodAfter,
      Value<DateTime> createdAt,
    });

class $$ProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get azkarCompleted => $composableBuilder(
    column: $table.azkarCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedAzkarIds => $composableBuilder(
    column: $table.completedAzkarIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodBefore => $composableBuilder(
    column: $table.moodBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodAfter => $composableBuilder(
    column: $table.moodAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get azkarCompleted => $composableBuilder(
    column: $table.azkarCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedAzkarIds => $composableBuilder(
    column: $table.completedAzkarIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodBefore => $composableBuilder(
    column: $table.moodBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodAfter => $composableBuilder(
    column: $table.moodAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get azkarCompleted => $composableBuilder(
    column: $table.azkarCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakCount => $composableBuilder(
    column: $table.streakCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedAzkarIds => $composableBuilder(
    column: $table.completedAzkarIds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflection => $composableBuilder(
    column: $table.reflection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moodBefore => $composableBuilder(
    column: $table.moodBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moodAfter =>
      $composableBuilder(column: $table.moodAfter, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressEntriesTable,
          ProgressEntry,
          $$ProgressEntriesTableFilterComposer,
          $$ProgressEntriesTableOrderingComposer,
          $$ProgressEntriesTableAnnotationComposer,
          $$ProgressEntriesTableCreateCompanionBuilder,
          $$ProgressEntriesTableUpdateCompanionBuilder,
          (
            ProgressEntry,
            BaseReferences<_$AppDatabase, $ProgressEntriesTable, ProgressEntry>,
          ),
          ProgressEntry,
          PrefetchHooks Function()
        > {
  $$ProgressEntriesTableTableManager(
    _$AppDatabase db,
    $ProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> azkarCompleted = const Value.absent(),
                Value<int> streakCount = const Value.absent(),
                Value<String> completedAzkarIds = const Value.absent(),
                Value<String?> reflection = const Value.absent(),
                Value<String?> moodBefore = const Value.absent(),
                Value<String?> moodAfter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProgressEntriesCompanion(
                id: id,
                date: date,
                azkarCompleted: azkarCompleted,
                streakCount: streakCount,
                completedAzkarIds: completedAzkarIds,
                reflection: reflection,
                moodBefore: moodBefore,
                moodAfter: moodAfter,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<int> azkarCompleted = const Value.absent(),
                Value<int> streakCount = const Value.absent(),
                required String completedAzkarIds,
                Value<String?> reflection = const Value.absent(),
                Value<String?> moodBefore = const Value.absent(),
                Value<String?> moodAfter = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProgressEntriesCompanion.insert(
                id: id,
                date: date,
                azkarCompleted: azkarCompleted,
                streakCount: streakCount,
                completedAzkarIds: completedAzkarIds,
                reflection: reflection,
                moodBefore: moodBefore,
                moodAfter: moodAfter,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressEntriesTable,
      ProgressEntry,
      $$ProgressEntriesTableFilterComposer,
      $$ProgressEntriesTableOrderingComposer,
      $$ProgressEntriesTableAnnotationComposer,
      $$ProgressEntriesTableCreateCompanionBuilder,
      $$ProgressEntriesTableUpdateCompanionBuilder,
      (
        ProgressEntry,
        BaseReferences<_$AppDatabase, $ProgressEntriesTable, ProgressEntry>,
      ),
      ProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      required String key,
      required String value,
      Value<DateTime> updatedAt,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSettingsEntry,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSettingsEntry,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTable,
              UserSettingsEntry
            >,
          ),
          UserSettingsEntry,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserSettingsCompanion(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                key: key,
                value: value,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSettingsEntry,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSettingsEntry,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingsEntry>,
      ),
      UserSettingsEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MoodEntriesTableTableManager get moodEntries =>
      $$MoodEntriesTableTableManager(_db, _db.moodEntries);
  $$AzkarEntriesTableTableManager get azkarEntries =>
      $$AzkarEntriesTableTableManager(_db, _db.azkarEntries);
  $$ProgressEntriesTableTableManager get progressEntries =>
      $$ProgressEntriesTableTableManager(_db, _db.progressEntries);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
