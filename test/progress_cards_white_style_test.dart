import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/streak_counter.dart';
import 'package:sakinah_app/features/progress/presentation/widgets/motivational_message.dart';

void main() {
  group('Progress Cards White Style Tests', () {
    testWidgets('StreakCounter uses GlassyContainer white card style', (
      tester,
    ) async {
      print('Testing StreakCounter widget with white card style');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 5,
              label: 'Day Streak',
              primaryColor: Colors.teal,
              showFire: true,
            ),
          ),
        ),
      );

      // Check if the widget renders without errors
      expect(find.byType(StreakCounter), findsOneWidget);

      // Check if the streak number is displayed
      expect(find.text('5'), findsOneWidget);
      expect(find.text('Day Streak'), findsOneWidget);

      // Check if the fire icon is displayed for positive streak
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);

      print('✓ StreakCounter renders correctly with white card style');
    });

    testWidgets('MotivationalMessage uses GlassyContainer white card style', (
      tester,
    ) async {
      print('Testing MotivationalMessage widget with white card style');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotivationalMessage(
              completedCount: 3,
              goalCount: 5,
              currentStreak: 2,
              primaryColor: Colors.blue,
            ),
          ),
        ),
      );

      // Check if the widget renders without errors
      expect(find.byType(MotivationalMessage), findsOneWidget);

      // Check if streak information is displayed
      expect(find.text('2 day streak!'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);

      print('✓ MotivationalMessage renders correctly with white card style');
    });

    testWidgets('StreakCounter with zero streak shows no fire icon', (
      tester,
    ) async {
      print('Testing StreakCounter with zero streak');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakCounter(
              streakCount: 0,
              label: 'Day Streak',
              primaryColor: Colors.teal,
              showFire: true,
            ),
          ),
        ),
      );

      // Check if the widget renders without errors
      expect(find.byType(StreakCounter), findsOneWidget);

      // Check if the streak number is displayed
      expect(find.text('0'), findsOneWidget);
      expect(find.text('Day Streak'), findsOneWidget);

      // Check if the fire icon is NOT displayed for zero streak
      expect(find.byIcon(Icons.local_fire_department), findsNothing);

      print('✓ StreakCounter correctly handles zero streak');
    });

    testWidgets('MotivationalMessage with zero streak shows no streak text', (
      tester,
    ) async {
      print('Testing MotivationalMessage with zero streak');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MotivationalMessage(
              completedCount: 0,
              goalCount: 5,
              currentStreak: 0,
              primaryColor: Colors.blue,
            ),
          ),
        ),
      );

      // Check if the widget renders without errors
      expect(find.byType(MotivationalMessage), findsOneWidget);

      // Check if streak information is NOT displayed for zero streak
      expect(find.text('0 day streak!'), findsNothing);

      print('✓ MotivationalMessage correctly handles zero streak');
    });
  });
}
