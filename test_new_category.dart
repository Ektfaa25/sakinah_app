import 'package:supabase/supabase.dart';

Future<void> main() async {
  // Initialize Supabase client
  final supabase = SupabaseClient(
    'https://dknkxdlqhozqnvghwdlh.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRrbmt4ZGxxaG96cW52Z2h3ZGxoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU3MjY4MjYsImV4cCI6MjA1MTMwMjgyNn0.8LRPmAMDSfBFUVpgPQKJ7txBH_3jGaZkqtXEVXzfLUk',
  );

  try {
    print('Testing new Travel Dhikr category...');

    // Test fetching all categories
    final categories = await supabase
        .from('azkar_categories')
        .select()
        .order('order_index');

    print('Total categories: ${categories.length}');

    // Find the travel category
    Map<String, dynamic>? travelCategory;
    try {
      travelCategory = categories.firstWhere(
        (cat) => cat['id'] == 'travel_dhikr',
      );
    } catch (e) {
      travelCategory = null;
    }

    if (travelCategory != null) {
      print('Travel category found:');
      print('ID: ${travelCategory['id']}');
      print('Name (AR): ${travelCategory['name_ar']}');
      print('Name (EN): ${travelCategory['name_en']}');
      print('Description: ${travelCategory['description']}');
      print('Icon: ${travelCategory['icon']}');
      print('Color: ${travelCategory['color']}');

      // Test fetching azkar for this category
      final azkarInCategory = await supabase
          .from('azkar')
          .select()
          .eq('category', travelCategory['name_ar']);

      print('Azkar in travel category: ${azkarInCategory.length}');

      for (int i = 0; i < azkarInCategory.length; i++) {
        final azkar = azkarInCategory[i];
        print('${i + 1}. ${azkar['arabic_text'].substring(0, 50)}...');
        print('   Reference: ${azkar['reference']}');
        print('   Repetitions: ${azkar['repetitions']}');
        print('   Description: ${azkar['description']}');
        print('');
      }
    } else {
      print('Travel category not found!');
    }

    print('Test completed successfully!');
  } catch (e) {
    print('Error: $e');
  }
}
