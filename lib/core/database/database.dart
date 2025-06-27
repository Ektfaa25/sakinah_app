import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Tables
@DataClassName('MoodEntry')
class MoodEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mood => text().withLength(min: 1, max: 50)();
  TextColumn get emoji => text().withLength(min: 1, max: 10)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('AzkarEntry')
class AzkarEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get arabicText => text()();
  TextColumn get transliteration => text().nullable()();
  TextColumn get translation => text().nullable()();
  TextColumn get category => text().withLength(min: 1, max: 100)();
  TextColumn get associatedMoods => text()(); // JSON array of mood strings
  IntColumn get repetitions => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('ProgressEntry')
class ProgressEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get azkarCompleted => integer().withDefault(const Constant(0))();
  IntColumn get streakCount => integer().withDefault(const Constant(0))();
  TextColumn get completedAzkarIds => text()(); // JSON array of azkar IDs
  TextColumn get reflection => text().nullable()();
  TextColumn get moodBefore => text().nullable()();
  TextColumn get moodAfter => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('UserSettingsEntry')
class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// Database class
@DriftDatabase(
  tables: [MoodEntries, AzkarEntries, ProgressEntries, UserSettings],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // DAOs

  // Mood DAOs
  Future<List<MoodEntry>> getAllMoods() => select(moodEntries).get();

  Future<MoodEntry?> getMoodByName(String moodName) => (select(
    moodEntries,
  )..where((tbl) => tbl.mood.equals(moodName))).getSingleOrNull();

  Future<int> insertMood(MoodEntriesCompanion mood) =>
      into(moodEntries).insert(mood);

  Future<List<MoodEntry>> getMoodHistory({int limit = 30}) =>
      (select(moodEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit))
          .get();

  // Azkar DAOs
  Future<List<AzkarEntry>> getAllAzkar() => select(azkarEntries).get();

  Future<List<AzkarEntry>> getAzkarByMood(String mood) => (select(
    azkarEntries,
  )..where((tbl) => tbl.associatedMoods.contains(mood))).get();

  Future<List<AzkarEntry>> getAzkarByCategory(String category) => (select(
    azkarEntries,
  )..where((tbl) => tbl.category.equals(category))).get();

  Future<AzkarEntry?> getAzkarById(int id) => (select(
    azkarEntries,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<int> insertAzkar(AzkarEntriesCompanion azkar) =>
      into(azkarEntries).insert(azkar);

  Future<bool> updateAzkar(AzkarEntriesCompanion azkar) =>
      update(azkarEntries).replace(azkar);

  // Progress DAOs
  Future<List<ProgressEntry>> getAllProgress() => select(progressEntries).get();

  Future<ProgressEntry?> getProgressByDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return (select(
      progressEntries,
    )..where((tbl) => tbl.date.equals(dateOnly))).getSingleOrNull();
  }

  Future<List<ProgressEntry>> getProgressInRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(progressEntries)
            ..where((tbl) => tbl.date.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<int> getCurrentStreak() async {
    final today = DateTime.now();
    final todayEntry = await getProgressByDate(today);
    return todayEntry?.streakCount ?? 0;
  }

  Future<int> insertProgress(ProgressEntriesCompanion progress) =>
      into(progressEntries).insert(progress);

  Future<bool> updateProgress(ProgressEntriesCompanion progress) =>
      update(progressEntries).replace(progress);

  // Settings DAOs
  Future<String?> getSetting(String key) async {
    final setting = await (select(
      userSettings,
    )..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
    return setting?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(userSettings).insertOnConflictUpdate(
      UserSettingsCompanion(
        key: Value(key),
        value: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<Map<String, String>> getAllSettings() async {
    final settings = await select(userSettings).get();
    return {for (var setting in settings) setting.key: setting.value};
  }

  // Utility methods
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(moodEntries).go();
      await delete(azkarEntries).go();
      await delete(progressEntries).go();
      await delete(userSettings).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sakinah_db.sqlite'));
    return NativeDatabase(file);
  });
}
