import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage should not have duplicate elements', (
    WidgetTester tester,
  ) async {
    // Build the HomePage
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify that the mood selection section is present
    expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);
    expect(find.text('How are you feeling today?'), findsOneWidget);
    expect(find.text('اختر مزاجك • Choose Your Mood'), findsOneWidget);

    // Verify that the categories section title is present
    expect(find.text('الاذكار'), findsOneWidget);

    // Verify that the bottom action buttons are NOT present (removed)
    expect(find.text('التقدم'), findsNothing);
    expect(find.text('الإعدادات'), findsNothing);

    // Verify that the app is more focused on the main content
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
