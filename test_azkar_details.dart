import 'package:flutter/material.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';

/// Test script to demonstrate azkar details fetching
void main() async {
  // Initialize Flutter binding for database access
  WidgetsFlutterBinding.ensureInitialized();

  print('🧪 Testing Azkar Details Fetching...\n');

  // Test data - sample azkar IDs (these should exist in your database)
  final List<String> sampleAzkarIds = ['azkar-001', 'azkar-002', 'azkar-003'];

  print('📋 Sample completed azkar IDs: $sampleAzkarIds\n');

  try {
    // Fetch azkar details by IDs
    print('🔍 Fetching azkar details...');
    final azkarDetails = await AzkarDatabaseAdapter.getAzkarByIds(
      sampleAzkarIds,
    );

    print('✅ Successfully fetched ${azkarDetails.length} azkar details:\n');

    // Display the fetched azkar details
    for (int i = 0; i < azkarDetails.length; i++) {
      final azkar = azkarDetails[i];
      print('${i + 1}. 📿 Azkar ID: ${azkar.id}');
      print('   📝 Arabic Text: ${azkar.textAr}');
      if (azkar.translation != null) {
        print('   🌍 Translation: ${azkar.translation}');
      }
      print('   📂 Category: ${azkar.categoryId}');
      print('   🔄 Repeat Count: ${azkar.repeatCount}');
      print('');
    }

    // Demonstrate how they would appear in the progress page
    print('📱 How this will appear in Progress Page:');
    print('═' * 50);

    for (final azkar in azkarDetails.take(5)) {
      final displayText = azkar.textAr.length > 50
          ? '${azkar.textAr.substring(0, 47)}...'
          : azkar.textAr;

      print('✅ $displayText');
    }

    if (azkarDetails.length > 5) {
      print('💙 و ${azkarDetails.length - 5} أذكار أخرى مكتملة');
    }

    print('═' * 50);
    print('🎉 Test completed successfully!');
  } catch (e) {
    print('❌ Error fetching azkar details: $e');
    print('');
    print('💡 Note: Make sure your Supabase database is properly configured');
    print('   and contains azkar data with the expected IDs.');
  }
}
