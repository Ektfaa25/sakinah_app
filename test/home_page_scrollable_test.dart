import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage should be scrollable', (WidgetTester tester) async {
    // Build the HomePage
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify that the page has a SingleChildScrollView
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Verify that the mood selection section is present
    expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);
    expect(find.text('How are you feeling today?'), findsOneWidget);

    // Verify that the categories section title is present
    expect(find.text('الاذكار'), findsOneWidget);

    // Verify that the bottom action buttons are present
    expect(find.text('التقدم'), findsOneWidget);
    expect(find.text('الإعدادات'), findsOneWidget);
  });
}
