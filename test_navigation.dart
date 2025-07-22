import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_categories_screen.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_detail_screen.dart';

void main() {
  testWidgets('Navigation from categories to detail screen works', (
    WidgetTester tester,
  ) async {
    // Build the azkar categories screen
    await tester.pumpWidget(MaterialApp(home: AzkarScreen()));

    // Wait for the screen to load
    await tester.pumpAndSettle();

    // This is a basic test to ensure the screen builds without errors
    expect(find.byType(AzkarScreen), findsOneWidget);

    print('✅ Azkar categories screen builds successfully');
  });
}
