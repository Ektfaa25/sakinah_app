import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Test the progress system
  print('🧪 Testing Progress System');
  print('📅 Today\'s date: ${DateTime.now()}');
  print(
    '📅 Today normalized: ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)}',
  );

  // Test the UUID format
  const defaultUserId = '00000000-0000-0000-0000-000000000001';
  print('🆔 Default User ID: $defaultUserId');

  // Test azkar ID format
  print('🕌 Sample azkar ID format: String UUID');

  // Test date string format
  final today = DateTime.now();
  final dateString = today.toIso8601String().split('T')[0];
  print('📅 Date string format: $dateString');

  print('✅ Test completed');
}
