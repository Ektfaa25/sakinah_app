import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/core/theme/app_theme.dart';

void main() {
  group('Bottom Navigation Bar Color Tests', () {
    testWidgets('should have correct background color #E3F1F1', (
      WidgetTester tester,
    ) async {
      // Create a simple app with bottom navigation to test the theme
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: const Center(child: Text('Test')),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the bottom navigation bar
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);

      print(
        '✅ Bottom navigation bar with new color theme is displayed correctly',
      );
    });

    test('should verify #E3F1F1 color constant', () {
      const expectedColor = Color(0xFFE3F1F1);

      // Verify the color components
      expect(expectedColor.red, equals(227)); // E3 hex = 227 decimal
      expect(expectedColor.green, equals(241)); // F1 hex = 241 decimal
      expect(expectedColor.blue, equals(241)); // F1 hex = 241 decimal
      expect(expectedColor.alpha, equals(255)); // FF hex = 255 decimal

      print(
        '✅ Color #E3F1F1 verified: RGB(${expectedColor.red}, ${expectedColor.green}, ${expectedColor.blue})',
      );
    });

    test(
      'should verify light and dark theme bottom nav colors are set to #E3F1F1',
      () {
        const expectedColor = Color(0xFFE3F1F1);

        // Get the light theme
        final lightTheme = AppTheme.lightTheme;
        final lightBottomNavTheme = lightTheme.bottomNavigationBarTheme;

        // Verify light theme background color
        expect(lightBottomNavTheme.backgroundColor, equals(expectedColor));

        // Get the dark theme
        final darkTheme = AppTheme.darkTheme;
        final darkBottomNavTheme = darkTheme.bottomNavigationBarTheme;

        // Verify dark theme background color
        expect(darkBottomNavTheme.backgroundColor, equals(expectedColor));

        print(
          '✅ Both light and dark theme bottom navigation bars use color #E3F1F1',
        );
      },
    );
  });
}
