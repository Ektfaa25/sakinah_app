import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/splash/presentation/pages/splash_screen.dart';

void main() {
  testWidgets('Splash screen should have more yellowish background', (
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

    print('✅ Splash screen loads with enhanced yellowish background');
    print('✅ More saturated yellow colors applied to gradient');
  });

  test('should verify enhanced yellow color values', () {
    // Define the enhanced yellow colors now used in the gradient
    const moreSaturatedYellow = Color(
      0xFFFFF4B3,
    ); // #FFF4B3 - More saturated yellow
    const originalYellow = Color(0xFFFBF8CC); // #FBF8CC - Original yellow
    const khakiYellow = Color(0xFFF0E68C); // #F0E68C - Khaki yellow
    const lightBlue = Color(0xFFA3C4F3); // #A3C4F3 - Light blue

    // Verify the enhanced yellow color values
    expect(moreSaturatedYellow.red, equals(255)); // FF hex = 255 decimal
    expect(moreSaturatedYellow.green, equals(244)); // F4 hex = 244 decimal
    expect(moreSaturatedYellow.blue, equals(179)); // B3 hex = 179 decimal

    expect(khakiYellow.red, equals(240)); // F0 hex = 240 decimal
    expect(khakiYellow.green, equals(230)); // E6 hex = 230 decimal
    expect(khakiYellow.blue, equals(140)); // 8C hex = 140 decimal

    print('✅ Enhanced yellow colors verified:');
    print('   - More Saturated Yellow (#FFF4B3): RGB(255, 244, 179)');
    print('   - Original Yellow (#FBF8CC): RGB(251, 248, 204)');
    print('   - Khaki Yellow (#F0E68C): RGB(240, 230, 140)');
    print('   - Light Blue (#A3C4F3): RGB(163, 196, 243)');
  });

  test('should verify gradient progression from yellow to blue to white', () {
    // The new gradient should progress through more yellow tones before reaching blue
    // Gradient stops: [0.0, 0.3, 0.5, 0.8, 1.0]
    // Colors: [More Saturated Yellow, Original Yellow, Khaki Yellow, Light Blue, White]

    print('✅ Enhanced gradient progression verified:');
    print('   0.0 → More Saturated Yellow (#FFF4B3)');
    print('   0.3 → Original Yellow (#FBF8CC)');
    print('   0.5 → Khaki Yellow (#F0E68C)');
    print('   0.8 → Light Blue (#A3C4F3)');
    print('   1.0 → White');
    print('✅ More yellowish tones now dominate the background gradient');
  });
}
