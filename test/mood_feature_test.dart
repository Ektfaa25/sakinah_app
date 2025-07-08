import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/mood/domain/entities/mood.dart';
import 'package:sakinah_app/features/mood/domain/services/mood_to_azkar_mapper.dart';

void main() {
  group('Mood Feature Integration Tests', () {
    test('Mood entity can be created with required properties', () {
      final mood = Mood(
        name: 'happy',
        emoji: '😊',
        description: 'Feeling joyful and content',
        selectedAt: DateTime.now(),
      );

      expect(mood.name, 'happy');
      expect(mood.emoji, '😊');
      expect(mood.description, 'Feeling joyful and content');
      expect(mood.selectedAt, isA<DateTime>());
    });

    test('Mood copyWith method works correctly', () {
      final originalMood = Mood(
        name: 'happy',
        emoji: '😊',
        selectedAt: DateTime.now(),
      );

      final copiedMood = originalMood.copyWith(
        description: 'Updated description',
      );

      expect(copiedMood.name, originalMood.name);
      expect(copiedMood.emoji, originalMood.emoji);
      expect(copiedMood.description, 'Updated description');
      expect(copiedMood.selectedAt, originalMood.selectedAt);
    });

    test('MoodToAzkarMapper returns azkar for valid mood names', () {
      final validMoods = [
        'happy',
        'sad',
        'anxious',
        'grateful',
        'stressed',
        'peaceful',
      ];

      for (final moodName in validMoods) {
        final azkar = MoodToAzkarMapper.getAzkarForMood(moodName);
        expect(
          azkar.isNotEmpty,
          true,
          reason: 'Should return azkar for $moodName',
        );
        expect(azkar.length, greaterThan(0));

        // Verify first azkar item has required properties
        final firstAzkar = azkar.first;
        expect(firstAzkar.id, isA<int>());
        expect(firstAzkar.arabicText.isNotEmpty, true);
        expect(firstAzkar.transliteration?.isNotEmpty ?? false, true);
        expect(firstAzkar.translation?.isNotEmpty ?? false, true);
      }
    });

    test('MoodToAzkarMapper returns default azkar for invalid mood names', () {
      final azkar = MoodToAzkarMapper.getAzkarForMood('invalid_mood');
      expect(
        azkar.isNotEmpty,
        true,
        reason: 'Should return default azkar for invalid mood',
      );
    });

    test('Mood predefined constants are available', () {
      expect(Mood.predefinedMoods.isNotEmpty, true);
      expect(Mood.predefinedMoods.length, greaterThan(0));

      // Check if common moods exist
      final moodNames = Mood.predefinedMoods.map((m) => m.name).toList();
      expect(moodNames, contains('happy'));
      expect(moodNames, contains('sad'));
      expect(moodNames, contains('peaceful'));
    });
  });
}
