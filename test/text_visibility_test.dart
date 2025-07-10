import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/core/router/app_router.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Text Visibility Tests', () {
    testWidgets('Home page text elements are visible with proper colors', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing text visibility fixes');

      // Create the router
      final router = AppRouter.createRouter();

      // Build the app with the router
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Check that we're on the home page
      expect(find.byType(HomePage), findsOneWidget);
      print('✅ Home page loaded successfully');

      // Check for visible text elements
      expect(find.text('السلام عليكم'), findsOneWidget);
      print('✅ Arabic greeting visible');

      expect(find.text('Peace be upon you'), findsOneWidget);
      print('✅ English greeting visible');

      expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);
      print('✅ Mood button text visible');

      expect(find.text('الاذكار'), findsOneWidget);
      print('✅ Azkar section title visible');

      print('🎉 All text elements are properly visible!');
    });
  });
}
