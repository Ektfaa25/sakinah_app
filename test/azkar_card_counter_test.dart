import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/features/azkar/presentation/widgets/azkar_card.dart';

void main() {
  group('AzkarCard Counter Tests', () {
    late Azkar testAzkar;

    setUp(() {
      testAzkar = const Azkar(
        id: 1,
        arabicText: 'سبحان الله',
        category: 'general',
        associatedMoods: ['peaceful'],
        repetitions: 3,
      );
    });

    testWidgets(
      'should display circular counter for azkar with repetitions > 1',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AzkarCard(azkar: testAzkar, isCompleted: false),
            ),
          ),
        );

        // Verify counter circle icon of size 32 is displayed (not completed)
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Icon &&
                widget.icon == Icons.circle_outlined &&
                widget.size == 32.0,
          ),
          findsOneWidget,
        );

        // Verify there's no completed check circle icon of size 32
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Icon &&
                widget.icon == Icons.check_circle &&
                widget.size == 32.0,
          ),
          findsNothing,
        );
      },
    );

    testWidgets('should increment counter when tapped', (
      WidgetTester tester,
    ) async {
      bool completedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AzkarCard(
              azkar: testAzkar,
              isCompleted: false,
              onCompleted: () {
                completedCalled = true;
              },
            ),
          ),
        ),
      );

      // Find the GestureDetector that wraps the counter
      final gestureDetectors = find.byType(GestureDetector);
      expect(gestureDetectors, findsWidgets);

      // Get the counter GestureDetector (should be the last one)
      final counterFinder = gestureDetectors.last;

      // Tap three times to complete
      await tester.tap(counterFinder);
      await tester.pump();
      await tester.tap(counterFinder);
      await tester.pump();
      await tester.tap(counterFinder);
      await tester.pump();

      // Verify completion callback was called
      expect(completedCalled, true);
    });

    testWidgets('should turn green when completed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AzkarCard(azkar: testAzkar, isCompleted: false)),
        ),
      );

      // Find the counter GestureDetector and tap 3 times to complete
      final gestureDetectors = find.byType(GestureDetector);
      final counterFinder = gestureDetectors.last;

      await tester.tap(counterFinder);
      await tester.pump();
      await tester.tap(counterFinder);
      await tester.pump();
      await tester.tap(counterFinder);
      await tester.pump();

      // Verify the counter changed to completed state (should have a check circle)
      expect(find.byIcon(Icons.check_circle), findsWidgets);
    });
  });
}
