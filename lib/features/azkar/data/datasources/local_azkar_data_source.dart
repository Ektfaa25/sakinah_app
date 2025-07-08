import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';

class LocalAzkarDataSource {
  static const String _csvPath = 'assets/data/azkar.csv';

  List<Azkar>? _cachedAzkar;

  Future<List<Azkar>> getAllAzkar() async {
    if (_cachedAzkar != null) {
      return _cachedAzkar!;
    }

    await _loadAzkarFromCsv();
    return _cachedAzkar ?? [];
  }

  Future<List<Azkar>> getAzkarByCategory(String category) async {
    final allAzkar = await getAllAzkar();

    // Map category names from display names to CSV format
    String csvCategory = _mapCategoryToCsv(category);

    return allAzkar
        .where(
          (azkar) => azkar.category.toLowerCase() == csvCategory.toLowerCase(),
        )
        .toList();
  }

  Future<List<Azkar>> getAzkarByMood(String mood) async {
    final allAzkar = await getAllAzkar();
    return allAzkar
        .where((azkar) => azkar.associatedMoods.contains(mood))
        .toList();
  }

  Future<List<Azkar>> searchAzkar(String query) async {
    final allAzkar = await getAllAzkar();
    final lowerQuery = query.toLowerCase();

    return allAzkar.where((azkar) {
      return azkar.arabicText.toLowerCase().contains(lowerQuery) ||
          (azkar.transliteration?.toLowerCase().contains(lowerQuery) ??
              false) ||
          (azkar.translation?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<void> _loadAzkarFromCsv() async {
    try {
      final csvString = await rootBundle.loadString(_csvPath);
      final rows = const CsvToListConverter().convert(csvString);

      if (rows.isEmpty) {
        _cachedAzkar = [];
        return;
      }

      // Skip the header row
      final dataRows = rows.skip(1);

      final azkarList = <Azkar>[];
      int id = 1;
      final categoryCount = <String, int>{};

      for (final row in dataRows) {
        if (row.length >= 6) {
          final azkar = _parseAzkarFromCsvRow(row, id++);
          if (azkar != null) {
            azkarList.add(azkar);
            categoryCount[azkar.category] =
                (categoryCount[azkar.category] ?? 0) + 1;
          }
        }
      }

      print('Azkar loaded by category: $categoryCount');
      _cachedAzkar = azkarList;
      print('Loaded ${azkarList.length} azkar from CSV');
    } catch (e) {
      print('Error loading azkar from CSV: $e');
      _cachedAzkar = [];
    }
  }

  Azkar? _parseAzkarFromCsvRow(List<dynamic> row, int id) {
    try {
      final category = row[0]?.toString() ?? '';
      final arabicText = row[1]?.toString() ?? '';
      // Skip benefits, reference, and searchTags as they're not in our entity
      final count = int.tryParse(row[3]?.toString() ?? '1') ?? 1;

      if (arabicText.isEmpty) return null;

      // Map CSV category to our app categories
      final mappedCategory = _mapCsvCategoryToApp(category);

      // Generate associated moods based on category
      final associatedMoods = _generateMoodsForCategory(mappedCategory);

      return Azkar(
        id: id,
        category: mappedCategory,
        arabicText: arabicText,
        transliteration: null, // CSV doesn't have transliteration
        translation: null, // CSV doesn't have translation
        repetitions: count,
        associatedMoods: associatedMoods,
        isCustom: false,
      );
    } catch (e) {
      print('Error parsing azkar row: $e');
      return null;
    }
  }

  String _mapCsvCategoryToApp(String csvCategory) {
    switch (csvCategory) {
      case 'أذكار الصباح':
        return 'morning';
      case 'أذكار المساء':
        return 'evening';
      case 'أذكار الشكر':
      case 'أذكار الحمد':
        return 'gratitude';
      case 'أذكار السكينة':
      case 'أذكار الهدوء':
        return 'peace';
      case 'أذكار تفريج الكرب':
      case 'أذكار القلق':
        return 'stress_relief';
      case 'أذكار الحماية':
        return 'protection';
      default:
        return 'general';
    }
  }

  String _mapCategoryToCsv(String appCategory) {
    switch (appCategory) {
      case 'morning':
        return 'أذكار الصباح';
      case 'evening':
        return 'أذكار المساء';
      case 'gratitude':
        return 'أذكار الشكر';
      case 'peace':
        return 'أذكار السكينة';
      case 'stress_relief':
        return 'أذكار تفريج الكرب';
      case 'protection':
        return 'أذكار الحماية';
      default:
        return appCategory;
    }
  }

  List<String> _generateMoodsForCategory(String category) {
    switch (category) {
      case 'morning':
        return ['happy', 'grateful', 'peaceful'];
      case 'evening':
        return ['peaceful', 'grateful', 'reflective'];
      case 'gratitude':
        return ['grateful', 'happy', 'content'];
      case 'peace':
        return ['peaceful', 'calm', 'anxious', 'stressed'];
      case 'stress_relief':
        return ['anxious', 'stressed', 'worried', 'overwhelmed'];
      case 'protection':
        return ['anxious', 'fearful', 'worried'];
      default:
        return ['peaceful'];
    }
  }

  void clearCache() {
    _cachedAzkar = null;
  }
}
