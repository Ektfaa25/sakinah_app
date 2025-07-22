import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Home Page with Date Tracker', () {
    testWidgets('should show date tracker widget without ProgressBloc', (
      WidgetTester tester,
    ) async {
      // Build the home page without any BlocProvider
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Wait for the widget to build
      await tester.pump();

      // Check that the date tracker is present (with mock data)
      expect(find.text('Weekly Progress'), findsOneWidget);
      expect(find.text('Goal ✓'), findsOneWidget);

      // Check that azkar categories are also present
      expect(find.text('الاذكار'), findsOneWidget);
      expect(find.text('أذكار الصباح'), findsOneWidget);
      expect(find.text('أذكار المساء'), findsOneWidget);
    });
  });
}
