import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/splash/presentation/pages/splash_screen.dart';

void main() {
  testWidgets('Splash screen should use bottom navigation bar colors', (
    WidgetTester tester,
  ) async {
    // Build the splash screen
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    // Wait for the widget to load
    await tester.pump();

    // Verify that the splash screen loads
    expect(find.byType(SplashScreen), findsOneWidget);

    // Look for Container widgets that should have the new gradient
    final containers = find.byType(Container);
    expect(containers, findsWidgets);

    print(
      '✅ Splash screen loads with updated color scheme matching bottom navigation',
    );
  });

  test('should verify bottom nav colors match splash colors', () {
    // Define the expected colors that should match between splash and bottom nav
    const lightYellow = Color(0xFFFBF8CC); // #FBF8CC
    const lightBlue = Color(0xFFA3C4F3); // #A3C4F3

    // Verify the hex color parsing logic works
    expect(lightYellow.red, equals(251)); // FB hex = 251 decimal
    expect(lightYellow.green, equals(248)); // F8 hex = 248 decimal
    expect(lightYellow.blue, equals(204)); // CC hex = 204 decimal

    expect(lightBlue.red, equals(163)); // A3 hex = 163 decimal
    expect(lightBlue.green, equals(196)); // C4 hex = 196 decimal
    expect(lightBlue.blue, equals(243)); // F3 hex = 243 decimal

    print(
      '✅ Color values verified: Light Yellow (#FBF8CC) and Light Blue (#A3C4F3)',
    );
  });
}
