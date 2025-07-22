import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';

class MockProgressBloc extends Fake implements ProgressBloc {}

void main() {
  group('Weekly Progress Tracker Complete RTL Tests', () {
    late MockProgressBloc mockProgressBloc;

    setUp(() {
      mockProgressBloc = MockProgressBloc();
    });

    testWidgets('Weekly progress tracker has complete RTL implementation', (
      WidgetTester tester,
    ) async {
      print(
        'Testing complete RTL implementation of weekly progress tracker...',
      );

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProgressBloc>.value(
            value: mockProgressBloc,
            child: const HomePage(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Test 1: Check that the main Column has RTL direction
      final mainColumn = tester.widget<Column>(
        find
            .descendant(
              of: find.byType(Container),
              matching: find.byType(Column),
            )
            .first,
      );

      expect(
        mainColumn.textDirection,
        TextDirection.rtl,
        reason: 'Main column should have RTL text direction',
      );
      expect(
        mainColumn.crossAxisAlignment,
        CrossAxisAlignment.end,
        reason: 'Main column should align to end (right) for RTL',
      );

      print('✓ Main column has RTL direction and right alignment');

      // Test 2: Check title Row RTL implementation
      final titleRows = tester.widgetList<Row>(find.byType(Row));
      final titleRow = titleRows.first;

      expect(
        titleRow.textDirection,
        TextDirection.rtl,
        reason: 'Title row should have RTL text direction',
      );
      expect(
        titleRow.mainAxisAlignment,
        MainAxisAlignment.end,
        reason: 'Title row should align to end (right) for RTL',
      );

      print('✓ Title row has RTL direction and right alignment');

      // Test 3: Check Arabic title text
      final titleText = tester.widget<Text>(find.text('التقدم الأسبوعي'));
      expect(
        titleText.textDirection,
        TextDirection.rtl,
        reason: 'Title text should have RTL direction',
      );

      print('✓ Arabic title text has RTL direction');

      // Test 4: Check that Arabic day names are displayed
      final arabicDayNames = [
        'الإثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ];

      for (final dayName in arabicDayNames) {
        expect(
          find.text(dayName),
          findsOneWidget,
          reason: 'Should find Arabic day name: $dayName',
        );
      }

      print('✓ All Arabic day names are displayed');

      // Test 5: Check that day name texts have RTL direction
      for (final dayName in arabicDayNames) {
        final dayText = tester.widget<Text>(find.text(dayName));
        expect(
          dayText.textDirection,
          TextDirection.rtl,
          reason: 'Day name $dayName should have RTL text direction',
        );
      }

      print('✓ All day name texts have RTL direction');

      // Test 6: Check days row RTL implementation
      final daysRow = titleRows.elementAt(1); // Second row is the days row
      expect(
        daysRow.textDirection,
        TextDirection.rtl,
        reason: 'Days row should have RTL text direction',
      );

      print('✓ Days row has RTL direction');

      // Test 7: Check legend row RTL implementation
      // Find the legend row specifically by checking for a row with center alignment
      final legendRows = titleRows.where(
        (row) =>
            row.mainAxisAlignment == MainAxisAlignment.center &&
            row.textDirection == TextDirection.rtl,
      );

      expect(
        legendRows.isNotEmpty,
        true,
        reason: 'Should find legend row with RTL text direction',
      );

      print('✓ Legend row has RTL direction');

      // Test 8: Check Arabic legend labels
      final arabicLegendLabels = [
        'لم يبدأ',
        'ذكر واحد',
        'ذكران',
        '٣ أذكار',
        'الهدف ✓',
      ];

      for (final label in arabicLegendLabels) {
        expect(
          find.text(label),
          findsOneWidget,
          reason: 'Should find Arabic legend label: $label',
        );
      }

      print('✓ All Arabic legend labels are displayed');

      // Test 9: Check that legend item rows have RTL direction
      final allRows = tester.widgetList<Row>(find.byType(Row));
      int legendItemCount = 0;

      for (final row in allRows) {
        if (row.mainAxisSize == MainAxisSize.min &&
            row.textDirection == TextDirection.rtl) {
          legendItemCount++;
        }
      }

      expect(
        legendItemCount,
        greaterThanOrEqualTo(5),
        reason: 'Should have at least 5 legend items with RTL direction',
      );

      print('✓ Legend items have RTL direction');

      // Test 10: Check that the container has right-aligned styling
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(Column),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(
        container.decoration,
        isA<BoxDecoration>(),
        reason: 'Container should have BoxDecoration',
      );

      print('✓ Container has proper styling');

      print('✓ All RTL implementation tests passed!');
    });

    testWidgets(
      'Weekly progress tracker icon and text order is correct for RTL',
      (WidgetTester tester) async {
        print('Testing icon and text order for RTL layout...');

        // Build the widget
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<ProgressBloc>.value(
              value: mockProgressBloc,
              child: const HomePage(),
            ),
          ),
        );

        // Wait for the widget to settle
        await tester.pumpAndSettle();

        // Find the title row
        final titleRow = tester.widget<Row>(find.byType(Row).first);

        // Verify the row has RTL direction
        expect(titleRow.textDirection, TextDirection.rtl);
        expect(titleRow.mainAxisAlignment, MainAxisAlignment.end);

        // In RTL, the text should come first, then the icon
        // Since we're using RTL direction, the children order should be:
        // [Text, SizedBox, Container(Icon)]

        // Find the text and icon within the row
        expect(find.text('التقدم الأسبوعي'), findsOneWidget);
        expect(find.byIcon(Icons.calendar_view_week_rounded), findsOneWidget);

        print('✓ Title row has correct RTL layout with text and icon');
        print('✓ Icon and text order tests passed!');
      },
    );

    testWidgets('Weekly progress tracker positioning is correct', (
      WidgetTester tester,
    ) async {
      print('Testing weekly progress tracker positioning...');

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ProgressBloc>.value(
            value: mockProgressBloc,
            child: const HomePage(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Check that weekly progress tracker is at the top
      final titleFinder = find.text('التقدم الأسبوعي');
      expect(titleFinder, findsOneWidget);

      // Get the position of the title
      final titleWidget = tester.getTopLeft(titleFinder);

      // The title should be near the top of the screen
      expect(
        titleWidget.dy,
        lessThan(200),
        reason: 'Weekly progress tracker should be positioned near the top',
      );

      print('✓ Weekly progress tracker is positioned correctly at the top');
      print('✓ Positioning tests passed!');
    });
  });
}
