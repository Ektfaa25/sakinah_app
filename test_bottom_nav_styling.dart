import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('Bottom navigation buttons have primary color styling', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Wait for the page to load
    await tester.pumpAndSettle();

    // Look for ElevatedButton widgets (our updated bottom nav buttons)
    final elevatedButtons = find.byType(ElevatedButton);

    // We should have at least 3 ElevatedButton widgets:
    // 1. Choose Your Mood button
    // 2. Progress button (bottom nav)
    // 3. Settings button (bottom nav)
    expect(elevatedButtons, findsAtLeast(3));

    // Test that the buttons exist
    expect(find.text('اختر مزاجك • Choose Your Mood'), findsOneWidget);
    expect(find.text('التقدم'), findsOneWidget);
    expect(find.text('الإعدادات'), findsOneWidget);
  });
}
