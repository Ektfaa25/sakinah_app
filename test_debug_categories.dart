import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://xtwygrdvgfmpjvswklse.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh0d3lncmR2Z2ZtcGp2c3drbHNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzNTU0MTksImV4cCI6MjA0OTkzMTQxOX0.Dp4rCJAOJTNhtqLqJDmgQ8dZfQF5QgCEV9OINtWJIUE',
  );

  final supabase = Supabase.instance.client;

  print('🔍 Debug: Checking categories in azkar table...');

  try {
    // Get all unique categories from azkar table
    final response = await supabase
        .from('azkar')
        .select('category')
        .not('category', 'is', null);

    // Extract unique categories
    final categories = <String>{};
    for (final row in response) {
      final category = row['category'] as String?;
      if (category != null && category.isNotEmpty) {
        categories.add(category);
      }
    }

    print('📊 Found ${categories.length} unique categories:');
    for (final category in categories) {
      print('  - "$category"');
    }

    // Check if any azkar has null or empty category
    final nullCategoryResponse = await supabase
        .from('azkar')
        .select('id, category')
        .or('category.is.null,category.eq.');

    print('⚠️ Azkar with null/empty category: ${nullCategoryResponse.length}');
  } catch (e) {
    print('❌ Error: $e');
  }
}
