import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/azkar_new.dart';
import 'package:sakinah_app/core/network/supabase_service.dart';

class AzkarDatabaseAdapter {
  static SupabaseClient get _supabase => SupabaseService.instance.client;

  // Mapping between category names in Arabic and category IDs for simplified English names
  static const Map<String, String> _categoryMapping = {
    'أذكار الصباح': 'morning',
    'أذكار المساء': 'evening',
    'أذكار النوم': 'sleep',
    'الرقية الشرعية من السنة النبوية': 'ruqyah_sunnah',
    'الرقية الشرعية من القرآن الكريم': 'ruqyah_quran',
    'التسبيح، التحميد، التهليل، التكبير': 'dhikr_general',
    'الدعاء بعد التشهد الأخير قبل السلام': 'prayer_before_salam',
    'الأذكار بعد السلام من الصلاة': 'after_prayer',
    'أماكن وأوقات إجابة الدعاء ': 'dua_times_places',
    'دعاء السجود': 'sujood_dua',
    'الاستغفار و التوبة': 'istighfar_tawbah',
    'دعاء الاستفتاح': 'opening_dua',
    'أذكار الآذان': 'adhan_dhikr',
    'دعاء الركوع': 'ruku_dua',
    'دعاء لقاء العدو و ذي السلطان': 'meeting_enemy_authority',
    'فضل الصلاة على النبي صلى الله عليه و سلم': 'salawat_virtue',
    'أذكار الاستيقاظ من النوم': 'waking_up',
    'الدعاء للميت في الصلاة عليه': 'funeral_prayer',
    'دعاء الكرب': 'distress_dua',
    'إفشاء السلام': 'spreading_salam',
    'الذكر بعد الفراغ من الوضوء': 'after_wudu',
    'دعاء الرفع من الركوع': 'rising_from_ruku',
  };

  /// Fetch all azkar categories from the azkar_categories table
  static Future<List<AzkarCategory>> getAzkarCategories() async {
    try {
      print('🔍 Fetching azkar categories from azkar_categories table...');

      final response = await _supabase
          .from('azkar_categories')
          .select('*')
          .eq('is_active', true)
          .order('order_index', ascending: true);

      print('✅ Successfully fetched ${(response as List).length} categories');

      return (response as List)
          .map((json) => AzkarCategory.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching azkar categories: $e');
      throw Exception('Failed to load azkar categories: $e');
    }
  }

  /// Fetch azkar by category using the azkar_categories table for lookup
  static Future<List<Azkar>> getAzkarByCategory(String categoryId) async {
    try {
      print('🔍 Fetching azkar for category: $categoryId');

      // First get the Arabic category name from azkar_categories table
      final categoryResponse = await _supabase
          .from('azkar_categories')
          .select('name_ar')
          .eq('id', categoryId)
          .maybeSingle();

      if (categoryResponse == null) {
        print('⚠️ Category not found with ID: $categoryId');
        return [];
      }

      final categoryName = categoryResponse['name_ar'] as String;
      print('🔗 Found category name: $categoryName');

      // Now fetch azkar using the Arabic category name
      final response = await _supabase
          .from('azkar')
          .select('*')
          .eq('category', categoryName)
          .order('created_at', ascending: true);

      print(
        '✅ Successfully fetched ${(response as List).length} azkar for $categoryId',
      );

      return (response as List)
          .map((json) => _adaptAzkarFromExistingSchema(json, categoryId))
          .toList();
    } catch (e) {
      print('❌ Error fetching azkar for category $categoryId: $e');
      throw Exception('Failed to load azkar for category: $e');
    }
  }

  /// Convert existing database azkar to the new Azkar model
  static Azkar _adaptAzkarFromExistingSchema(
    Map<String, dynamic> json,
    String categoryId,
  ) {
    return Azkar(
      id: json['id'] as String,
      categoryId: categoryId,
      textAr: json['arabic_text'] as String,
      textEn: null, // Not available in existing schema
      transliteration: null, // Not available in existing schema
      translation:
          json['description'] as String?, // Using description as translation
      reference: json['reference'] as String?,
      description: json['description'] as String?,
      repeatCount: json['repetitions'] as int? ?? 1,
      orderIndex: 0, // Not available in existing schema
      associatedMoods: [], // Not available in existing schema
      searchTags: json['search_tags'] as String?,
      isActive: true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Get a single azkar by ID
  static Future<Azkar?> getAzkarById(String azkarId) async {
    try {
      print('🔍 Fetching azkar with ID: $azkarId');

      final response = await _supabase
          .from('azkar')
          .select('*')
          .eq('id', azkarId)
          .maybeSingle();

      if (response == null) {
        print('⚠️ Azkar not found with ID: $azkarId');
        return null;
      }

      // Determine category ID from the Arabic category name
      final categoryName = response['category'] as String;
      final categoryId = _categoryMapping[categoryName] ?? 'general';

      return _adaptAzkarFromExistingSchema(response, categoryId);
    } catch (e) {
      print('❌ Error fetching azkar with ID $azkarId: $e');
      throw Exception('Failed to load azkar: $e');
    }
  }

  /// Search azkar in the existing table
  static Future<List<Azkar>> searchAzkar(String query) async {
    try {
      print('🔍 Searching azkar with query: $query');

      final response = await _supabase
          .from('azkar')
          .select('*')
          .or(
            'arabic_text.ilike.%$query%,description.ilike.%$query%,search_tags.ilike.%$query%',
          )
          .order('created_at', ascending: true);

      print('✅ Found ${(response as List).length} azkar matching query');

      return (response as List).map((json) {
        final categoryName = json['category'] as String;
        final categoryId = _categoryMapping[categoryName] ?? 'general';
        return _adaptAzkarFromExistingSchema(json, categoryId);
      }).toList();
    } catch (e) {
      print('❌ Error searching azkar: $e');
      throw Exception('Failed to search azkar: $e');
    }
  }

  /// Test database connection
  static Future<bool> testConnection() async {
    try {
      print('🧪 Testing database connection...');

      // Test both azkar and azkar_categories tables
      await _supabase.from('azkar_categories').select('id').limit(1);
      await _supabase.from('azkar').select('id').limit(1);

      print('✅ Database connection test successful');
      return true;
    } catch (e) {
      print('❌ Database connection test failed: $e');
      return false;
    }
  }

  /// Get database health check
  static Future<Map<String, dynamic>> getHealthCheck() async {
    try {
      final categoriesResponse = await _supabase
          .from('azkar_categories')
          .select('id')
          .eq('is_active', true);

      final azkarResponse = await _supabase.from('azkar').select('id');

      return {
        'status': 'healthy',
        'categories_count': (categoriesResponse as List).length,
        'azkar_count': (azkarResponse as List).length,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}
