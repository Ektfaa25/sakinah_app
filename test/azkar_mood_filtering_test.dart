import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';

void main() {
  group('Azkar Mood Filtering Tests', () {
    late List<Azkar> testAzkar;

    setUp(() {
      testAzkar = [
        const Azkar(
          id: 1,
          arabicText: 'Test Azkar 1',
          category: 'morning',
          associatedMoods: ['peaceful', 'anxious', 'stressed'],
          repetitions: 1,
        ),
        const Azkar(
          id: 2,
          arabicText: 'Test Azkar 2',
          category: 'morning',
          associatedMoods: ['peaceful', 'grateful', 'happy'],
          repetitions: 1,
        ),
        const Azkar(
          id: 3,
          arabicText: 'Test Azkar 3',
          category: 'gratitude',
          associatedMoods: ['grateful', 'happy', 'peaceful'],
          repetitions: 1,
        ),
        const Azkar(
          id: 4,
          arabicText: 'Test Azkar 4',
          category: 'stress_relief',
          associatedMoods: ['stressed', 'anxious', 'sad'],
          repetitions: 1,
        ),
      ];
    });

    test('should filter azkar by mood "happy"', () {
      final mood = 'happy';
      final filteredAzkar = testAzkar.where((azkar) {
        return azkar.associatedMoods.contains(mood);
      }).toList();

      expect(filteredAzkar.length, 2);
      expect(filteredAzkar.map((e) => e.id).toList(), [2, 3]);
    });

    test('should filter azkar by mood "peaceful"', () {
      final mood = 'peaceful';
      final filteredAzkar = testAzkar.where((azkar) {
        return azkar.associatedMoods.contains(mood);
      }).toList();

      expect(filteredAzkar.length, 3);
      expect(filteredAzkar.map((e) => e.id).toList(), [1, 2, 3]);
    });

    test('should filter azkar by mood "stressed"', () {
      final mood = 'stressed';
      final filteredAzkar = testAzkar.where((azkar) {
        return azkar.associatedMoods.contains(mood);
      }).toList();

      expect(filteredAzkar.length, 2);
      expect(filteredAzkar.map((e) => e.id).toList(), [1, 4]);
    });

    test('should filter azkar by mood with category mapping', () {
      final mood = 'happy';
      final moodMappings = {
        'happy': ['gratitude', 'morning', 'protection'],
      };
      final categories = List<String>.from(moodMappings[mood] ?? []);

      final filteredAzkar = testAzkar.where((azkar) {
        return azkar.associatedMoods.contains(mood) ||
            categories.contains(azkar.category);
      }).toList();

      // Should match: id 2 and 3 (by mood) + id 1 (by category 'morning')
      expect(filteredAzkar.length, 3);
      expect(filteredAzkar.map((e) => e.id).toList(), [1, 2, 3]);
    });

    test('should return empty list for non-existent mood', () {
      final mood = 'nonexistent';
      final filteredAzkar = testAzkar.where((azkar) {
        return azkar.associatedMoods.contains(mood);
      }).toList();

      expect(filteredAzkar.length, 0);
    });
  });
}
