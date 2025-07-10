import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/core/router/app_router.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Navigation Tests', () {
    testWidgets('Home page loads and displays azkar section', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing home page loads with azkar section');

      // Create the router
      final router = AppRouter.createRouter();

      // Build the app with the router
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Check that we're on the home page
      expect(find.byType(HomePage), findsOneWidget);
      print('✅ Home page loaded successfully');

      // Check for Arabic greeting
      expect(find.text('السلام عليكم'), findsOneWidget);
      print('✅ Arabic greeting found');

      // Check for mood selection button
      expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);
      print('✅ Mood selection button found');

      // Check for azkar section title
      expect(find.text('الاذكار'), findsOneWidget);
      print('✅ Azkar section title found');

      // Look for at least one azkar card text (Morning)
      expect(find.textContaining('أذكار'), findsAtLeastNWidgets(1));
      print('✅ At least one azkar card found');

      print('🎉 Home page navigation test passed!');
    });

    testWidgets('Router creates successfully', (WidgetTester tester) async {
      print('🧪 Testing router creation');

      // Test that the router can be created without errors
      final router = AppRouter.createRouter();
      expect(router, isNotNull);

      print('✅ Router created successfully');
      print('🎉 Router configuration test passed!');
    });
  });
}
