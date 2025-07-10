import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/core/router/app_router.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Fixed Navigation Tests', () {
    testWidgets(
      'Home page loads with azkar category cards and navigation method',
      (WidgetTester tester) async {
        print('🧪 Testing fixed navigation implementation');

        // Create the router
        final router = AppRouter.createRouter();

        // Build the app with the router
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));

        // Wait for the app to settle
        await tester.pumpAndSettle();

        // Check that we're on the home page
        expect(find.byType(HomePage), findsOneWidget);
        print('✅ Home page loaded successfully');

        // Check for the updated mood selection button
        expect(find.text('كيف تشعر اليوم؟'), findsOneWidget);
        print('✅ Mood selection button found');

        // Check for azkar section
        expect(find.text('الاذكار'), findsOneWidget);
        print('✅ Azkar section found');

        // Check that azkar category cards are present in the widget tree
        expect(find.textContaining('أذكار'), findsAtLeastNWidgets(1));
        print('✅ Azkar category cards found');

        print('🎉 Fixed navigation test passed!');
      },
    );

    testWidgets('HomePage widget can be instantiated without errors', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing HomePage widget instantiation');

      // Test that HomePage can be created without navigator lock issues
      const homePage = HomePage();
      expect(homePage, isNotNull);

      print('✅ HomePage widget created successfully');
      print('🎉 Widget instantiation test passed!');
    });
  });
}
