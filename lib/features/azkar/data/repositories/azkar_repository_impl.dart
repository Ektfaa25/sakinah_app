import 'package:sakinah_app/core/network/supabase_service.dart';
import 'package:sakinah_app/features/azkar/data/models/azkar_model.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/features/azkar/domain/repositories/azkar_repository.dart';

class AzkarRepositoryImpl implements AzkarRepository {
  final SupabaseService _supabaseService;
  bool _isInitialized = false;

  AzkarRepositoryImpl(this._supabaseService);

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<void> clearAll() async {
    // Note: In a real app, you might want to be more careful about this
    await _supabaseService.client
        .from('custom_azkar')
        .delete()
        .neq('id', '00000000-0000-0000-0000-000000000000'); // Delete all
  }

  @override
  Future<List<Azkar>> getAllAzkar() async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => AzkarModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch azkar: $e');
    }
  }

  @override
  Future<List<Azkar>> getAzkarByMood(String mood) async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .select()
          .contains('associated_moods', [mood])
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => AzkarModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch azkar by mood: $e');
    }
  }

  @override
  Future<List<Azkar>> getAzkarByCategory(String category) async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => AzkarModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch azkar by category: $e');
    }
  }

  @override
  Future<Azkar?> getAzkarById(int id) async {
    // Note: For Supabase, we need to handle UUID strings vs int IDs
    // This method will return null for now as we use UUIDs in Supabase
    return null;
  }

  Future<Azkar?> getAzkarBySupabaseId(String supabaseId) async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .select()
          .eq('id', supabaseId)
          .maybeSingle();

      if (response == null) return null;
      return AzkarModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch azkar by ID: $e');
    }
  }

  @override
  Future<int> addAzkar(Azkar azkar) async {
    try {
      final azkarModel = AzkarModel(
        arabicText: azkar.arabicText,
        transliteration: azkar.transliteration,
        translation: azkar.translation,
        category: azkar.category,
        associatedMoods: azkar.associatedMoods,
        repetitions: azkar.repetitions,
        isCustom: true,
      );

      final response = await _supabaseService.client
          .from('custom_azkar')
          .insert(azkarModel.toSupabaseInsert())
          .select()
          .single();

      // Return a hash of the UUID as int for compatibility
      return response['id'].hashCode;
    } catch (e) {
      throw Exception('Failed to add azkar: $e');
    }
  }

  @override
  Future<bool> updateAzkar(Azkar azkar) async {
    try {
      if (azkar is! AzkarModel || azkar.supabaseId == null) {
        throw Exception('Cannot update azkar without Supabase ID');
      }

      final updateData = {
        'arabic_text': azkar.arabicText,
        'transliteration': azkar.transliteration,
        'translation': azkar.translation,
        'category': azkar.category,
        'associated_moods': azkar.associatedMoods,
        'repetitions': azkar.repetitions,
        'is_favorite': azkar.isFavorite,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabaseService.client
          .from('custom_azkar')
          .update(updateData)
          .eq('id', azkar.supabaseId!);

      return true;
    } catch (e) {
      throw Exception('Failed to update azkar: $e');
    }
  }

  @override
  Future<bool> deleteAzkar(int id) async {
    // Note: This method is limited since we use UUIDs in Supabase
    // Consider using deleteAzkarBySupabaseId instead
    return false;
  }

  Future<bool> deleteAzkarBySupabaseId(String supabaseId) async {
    try {
      await _supabaseService.client
          .from('custom_azkar')
          .delete()
          .eq('id', supabaseId);
      return true;
    } catch (e) {
      throw Exception('Failed to delete azkar: $e');
    }
  }

  @override
  Future<List<Azkar>> searchAzkar(String query) async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .select()
          .or(
            'arabic_text.ilike.%$query%,transliteration.ilike.%$query%,translation.ilike.%$query%',
          )
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => AzkarModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search azkar: $e');
    }
  }

  @override
  Future<List<Azkar>> getRecommendations({
    required String mood,
    int limit = 5,
    List<int>? excludeIds,
  }) async {
    try {
      var query = _supabaseService.client
          .from('custom_azkar')
          .select()
          .contains('associated_moods', [mood])
          .order('created_at', ascending: false)
          .limit(limit);

      final response = await query;

      return (response as List)
          .map((json) => AzkarModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }

  @override
  Future<List<Azkar>> getCustomAzkar() async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => AzkarModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch custom azkar: $e');
    }
  }

  @override
  Future<void> importDefaultAzkar() async {
    // This would typically load default azkar from assets
    // For now, we'll add a few sample azkar
    try {
      final defaultAzkar = [
        {
          'arabic_text':
              'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير',
          'transliteration':
              'La ilaha illa Allah wahdahu la sharika lahu, lahu al-mulku wa lahu al-hamdu wa huwa \'ala kulli shay\'in qadir',
          'translation':
              'There is no god but Allah alone, with no partner. To Him belongs the kingdom, to Him belongs all praise, and He has power over everything.',
          'category': 'general',
          'associated_moods': ['stressed', 'anxious', 'grateful'],
          'repetitions': 10,
          'is_favorite': false,
        },
        {
          'arabic_text': 'سبحان الله وبحمده',
          'transliteration': 'Subhan Allah wa bihamdihi',
          'translation': 'Glory be to Allah and praise be to Him.',
          'category': 'general',
          'associated_moods': ['grateful', 'peaceful'],
          'repetitions': 33,
          'is_favorite': false,
        },
      ];

      for (final azkar in defaultAzkar) {
        await _supabaseService.client.from('custom_azkar').insert(azkar);
      }
    } catch (e) {
      throw Exception('Failed to import default azkar: $e');
    }
  }

  // Additional methods specific to Supabase functionality
  Future<List<Azkar>> getFavoriteAzkar() async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .select()
          .eq('is_favorite', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => AzkarModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite azkar: $e');
    }
  }

  Future<Azkar> toggleFavorite(String supabaseId, bool isFavorite) async {
    try {
      final response = await _supabaseService.client
          .from('custom_azkar')
          .update({
            'is_favorite': isFavorite,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', supabaseId)
          .select()
          .single();

      return AzkarModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
}
