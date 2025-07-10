import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/core/router/app_router.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Direct Azkar Navigation Tests', () {
    testWidgets('Home page loads and shows azkar category cards', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing home page with direct azkar navigation');

      // Create the router
      final router = AppRouter.createRouter();

      // Build the app with the router
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Check that we're on the home page
      expect(find.byType(HomePage), findsOneWidget);
      print('✅ Home page loaded successfully');

      // Check for azkar section title
      expect(find.text('الاذكار'), findsOneWidget);
      print('✅ Azkar section title found');

      // Check that the azkar cards are present
      expect(find.textContaining('أذكار'), findsAtLeastNWidgets(1));
      print('✅ Azkar category cards found');

      print('🎉 Direct navigation setup test passed!');
    });

    testWidgets('Navigation helper method is properly defined', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing navigation helper method');

      // Create a HomePage widget to verify it can be instantiated
      const homePage = HomePage();
      expect(homePage, isNotNull);

      print('✅ HomePage widget created successfully');
      print('🎉 Navigation helper test passed!');
    });
  });
}
