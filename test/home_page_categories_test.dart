import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage displays categories correctly', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify that we have the mood selection section
    expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);
    expect(find.text('How are you feeling today?'), findsOneWidget);

    // Verify that we have the categories section
    expect(find.text('الاذكار'), findsOneWidget);

    // Initially, the page should be loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
