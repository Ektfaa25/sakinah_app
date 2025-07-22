import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/main.dart';

void main() {
  group('Navigation Tests', () {
    testWidgets('should show bottom navigation bar on azkar categories screen', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const SakinahApp());

      // Wait for the app to load
      await tester.pumpAndSettle();

      // Find the bottom navigation bar
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Tap on the "الفئات" (Categories) tab
      await tester.tap(find.text('الفئات'));
      await tester.pumpAndSettle();

      // Verify that we're on the azkar categories screen and bottom nav is still there
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify that the current route is the azkar categories route
      // This should be visible as the second tab should be selected
      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 1); // Index 1 is the Categories tab
    });

    testWidgets('should navigate between tabs while maintaining bottom nav', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const SakinahApp());

      // Wait for the app to load
      await tester.pumpAndSettle();

      // Start on home tab (index 0)
      BottomNavigationBar bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);

      // Navigate to Categories tab (index 1)
      await tester.tap(find.text('الفئات'));
      await tester.pumpAndSettle();

      bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 1);
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Navigate to Progress tab (index 3)
      await tester.tap(find.text('التقدم'));
      await tester.pumpAndSettle();

      bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 3);
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Navigate back to Home tab (index 0)
      await tester.tap(find.text('الرئيسية'));
      await tester.pumpAndSettle();

      bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });
  });
}
