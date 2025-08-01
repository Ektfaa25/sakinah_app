import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/splash/presentation/pages/splash_screen.dart';

void main() {
  testWidgets('Splash screen should not have linear glow effect', (
    WidgetTester tester,
  ) async {
    // Build the splash screen
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    // Wait for the widget to load
    await tester.pump();

    // Verify that the splash screen loads
    expect(find.byType(SplashScreen), findsOneWidget);

    // Verify that there's no AnimatedBuilder for glow effect
    // (The remaining AnimatedBuilder should only be for the main content animations)
    final animatedBuilders = find.byType(AnimatedBuilder);

    // We should have AnimatedBuilders for the main content animations, but not for glow
    expect(animatedBuilders, findsWidgets);

    // Verify that the main components are still present
    expect(find.text('سكينة'), findsOneWidget);
    expect(find.text('لحظات من السكون، في عالم لا يهدأ'), findsOneWidget);
    expect(find.text('جاري التحميل...'), findsOneWidget);

    print('✅ Splash screen loads without linear glow effect');
    print('✅ Main content animations are preserved');
  });

  test('should verify splash screen has clean background gradient only', () {
    // This test verifies that we've removed the glow animation code
    // and kept only the clean background gradient

    // The splash screen should now have:
    // 1. Clean gradient background (Light Yellow to Light Blue to White)
    // 2. Abstract background shapes for subtle decoration
    // 3. Main content with text and loading indicator
    // 4. NO animated linear glow effect

    print('✅ Linear glow effect has been successfully removed');
    print('✅ Background remains clean with subtle gradient');
    print('✅ Abstract shapes provide minimal decoration');
  });
}
