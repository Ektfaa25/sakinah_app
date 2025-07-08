import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';

/// Service for mapping moods to appropriate azkar recommendations
class MoodToAzkarMapper {
  /// Map of mood names to recommended azkar categories/types
  static const Map<String, List<String>> _moodToAzkarCategories = {
    'happy': ['gratitude', 'praise', 'celebration', 'thankfulness'],
    'sad': ['comfort', 'hope', 'patience', 'healing', 'strength'],
    'anxious': ['peace', 'trust', 'protection', 'calm', 'reassurance'],
    'grateful': ['gratitude', 'praise', 'thankfulness', 'celebration'],
    'stressed': ['peace', 'calm', 'relief', 'patience', 'strength'],
    'peaceful': ['meditation', 'reflection', 'gratitude', 'praise'],
    'excited': ['gratitude', 'celebration', 'praise', 'thankfulness'],
    'confused': ['guidance', 'clarity', 'wisdom', 'patience'],
    'hopeful': ['gratitude', 'trust', 'optimism', 'faith'],
    'tired': ['rest', 'renewal', 'strength', 'comfort'],
  };

  /// Predefined azkar mapped to moods and categories
  static const Map<String, List<Map<String, dynamic>>> _azkarDatabase = {
    'gratitude': [
      {
        'arabic': 'الحمد لله رب العالمين',
        'transliteration': 'Alhamdulillahi rabbil alameen',
        'translation': 'All praise is due to Allah, Lord of the worlds',
        'category': 'gratitude',
        'moods': ['happy', 'grateful', 'peaceful', 'excited', 'hopeful'],
      },
      {
        'arabic': 'اللهم لك الحمد كما ينبغي لجلال وجهك وعظيم سلطانك',
        'transliteration':
            'Allahumma lakal hamdu kama yanbaghee li jalaali wajhika wa azheemi sultanik',
        'translation':
            'O Allah, to You belongs all praise as befits the majesty of Your Face and the greatness of Your sovereignty',
        'category': 'gratitude',
        'moods': ['grateful', 'happy', 'peaceful'],
      },
    ],
    'peace': [
      {
        'arabic': 'اللهم أنت السلام ومنك السلام تباركت يا ذا الجلال والإكرام',
        'transliteration':
            'Allahumma antas-salamu wa minkas-salam, tabarakta ya dhal-jalali wal-ikram',
        'translation':
            'O Allah, You are Peace and from You comes peace. Blessed are You, O Possessor of majesty and honor',
        'category': 'peace',
        'moods': ['anxious', 'stressed', 'peaceful'],
      },
      {
        'arabic': 'رب اشرح لي صدري ويسر لي أمري',
        'transliteration': 'Rabbi ushurni sahdri wa yassir li amri',
        'translation': 'My Lord, expand my chest and ease my task for me',
        'category': 'peace',
        'moods': ['anxious', 'stressed', 'confused'],
      },
    ],
    'comfort': [
      {
        'arabic': 'حسبنا الله ونعم الوكيل',
        'transliteration': 'Hasbunallahu wa ni\'mal wakeel',
        'translation':
            'Allah is sufficient for us and He is the best disposer of affairs',
        'category': 'comfort',
        'moods': ['sad', 'anxious', 'tired'],
      },
      {
        'arabic': 'إنا لله وإنا إليه راجعون',
        'transliteration': 'Inna lillahi wa inna ilayhi raji\'oon',
        'translation':
            'Indeed we belong to Allah, and indeed to Him we will return',
        'category': 'comfort',
        'moods': ['sad', 'tired'],
      },
    ],
    'strength': [
      {
        'arabic': 'لا حول ولا قوة إلا بالله',
        'transliteration': 'La hawla wa la quwwata illa billah',
        'translation': 'There is no power and no strength except with Allah',
        'category': 'strength',
        'moods': ['sad', 'stressed', 'tired'],
      },
    ],
    'trust': [
      {
        'arabic': 'وعلى الله فليتوكل المؤمنون',
        'transliteration': 'Wa \'alallahi falyatawakkalil mu\'minoon',
        'translation': 'And upon Allah let the believers rely',
        'category': 'trust',
        'moods': ['anxious', 'hopeful'],
      },
    ],
    'guidance': [
      {
        'arabic': 'اهدنا الصراط المستقيم',
        'transliteration': 'Ihdinassiratal mustaqeem',
        'translation': 'Guide us to the straight path',
        'category': 'guidance',
        'moods': ['confused'],
      },
    ],
    'praise': [
      {
        'arabic': 'سبحان الله وبحمده سبحان الله العظيم',
        'transliteration': 'Subhanallahi wa bihamdihi subhanallahil azeem',
        'translation':
            'Glory be to Allah and praise Him, glory be to Allah the Magnificent',
        'category': 'praise',
        'moods': ['happy', 'grateful', 'peaceful', 'excited'],
      },
    ],
  };

  /// Get recommended azkar for a specific mood
  static List<Azkar> getAzkarForMood(String moodName) {
    final categories = _moodToAzkarCategories[moodName.toLowerCase()] ?? [];
    final List<Azkar> recommendedAzkar = [];
    int idCounter = 1;

    for (final category in categories) {
      final azkarList = _azkarDatabase[category] ?? [];
      for (final azkarData in azkarList) {
        final moods = List<String>.from(azkarData['moods'] ?? []);
        if (moods.contains(moodName.toLowerCase())) {
          recommendedAzkar.add(
            Azkar(
              id: idCounter++,
              arabicText: azkarData['arabic'] ?? '',
              transliteration: azkarData['transliteration'],
              translation: azkarData['translation'],
              category: azkarData['category'] ?? category,
              associatedMoods: moods,
              repetitions: 1,
            ),
          );
        }
      }
    }

    return recommendedAzkar;
  }

  /// Get recommended azkar for multiple moods (useful for mixed emotions)
  static List<Azkar> getAzkarForMoods(List<String> moodNames) {
    final Set<Azkar> uniqueAzkar = {};

    for (final moodName in moodNames) {
      final azkar = getAzkarForMood(moodName);
      uniqueAzkar.addAll(azkar);
    }

    return uniqueAzkar.toList();
  }

  /// Get azkar categories that are suitable for a mood
  static List<String> getCategoriesForMood(String moodName) {
    return _moodToAzkarCategories[moodName.toLowerCase()] ?? [];
  }

  /// Get all available azkar categories
  static List<String> getAllCategories() {
    return _azkarDatabase.keys.toList();
  }

  /// Get azkar by category
  static List<Azkar> getAzkarByCategory(String category) {
    final azkarList = _azkarDatabase[category] ?? [];
    return azkarList.asMap().entries.map((entry) {
      final index = entry.key;
      final azkarData = entry.value;
      return Azkar(
        id: index + 1,
        arabicText: azkarData['arabic'] ?? '',
        transliteration: azkarData['transliteration'],
        translation: azkarData['translation'],
        category: azkarData['category'] ?? category,
        associatedMoods: List<String>.from(azkarData['moods'] ?? []),
        repetitions: 1,
      );
    }).toList();
  }

  /// Check if a mood has recommended azkar
  static bool hasMoodRecommendations(String moodName) {
    return _moodToAzkarCategories.containsKey(moodName.toLowerCase());
  }

  /// Get mood-specific message for azkar recommendations
  static String getRecommendationMessage(String moodName) {
    switch (moodName.toLowerCase()) {
      case 'happy':
        return 'Express your joy and gratitude with these beautiful azkar';
      case 'sad':
        return 'Find comfort and healing in these soothing remembrances';
      case 'anxious':
        return 'Calm your heart with these peaceful azkar';
      case 'grateful':
        return 'Deepen your gratitude with these praise-filled azkar';
      case 'stressed':
        return 'Find relief and peace through these calming remembrances';
      case 'peaceful':
        return 'Enhance your tranquility with these serene azkar';
      case 'excited':
        return 'Channel your excitement into joyful praise and gratitude';
      case 'confused':
        return 'Seek clarity and guidance through these wisdom-filled azkar';
      case 'hopeful':
        return 'Strengthen your faith with these uplifting remembrances';
      case 'tired':
        return 'Renew your spirit with these comforting azkar';
      default:
        return 'Discover beautiful azkar for your current state of mind';
    }
  }
}
