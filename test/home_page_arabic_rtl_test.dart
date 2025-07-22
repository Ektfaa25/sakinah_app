import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  group('Home Page Arabic RTL Tests', () {
    testWidgets('Weekly progress tracker displays Arabic day names', (
      WidgetTester tester,
    ) async {
      print('Testing Arabic day names in weekly progress tracker...');

      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Find the weekly progress tracker section
      final weeklyProgressTitle = find.text('التقدم الأسبوعي');
      expect(weeklyProgressTitle, findsOneWidget);
      print('✓ Found weekly progress title in Arabic');

      // Check for Arabic day names
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
        final dayText = find.text(dayName);
        expect(dayText, findsOneWidget);
        print('✓ Found Arabic day name: $dayName');
      }

      // Check that English day names are not present
      final englishDayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (final dayName in englishDayNames) {
        final dayText = find.text(dayName);
        expect(dayText, findsNothing);
        print('✓ Confirmed English day name not found: $dayName');
      }

      // Check for Arabic legend labels
      final arabicLegendLabels = [
        'لم يبدأ',
        'ذكر واحد',
        'ذكران',
        '٣ أذكار',
        'الهدف ✓',
      ];

      for (final label in arabicLegendLabels) {
        final legendText = find.text(label);
        expect(legendText, findsOneWidget);
        print('✓ Found Arabic legend label: $label');
      }

      print('✓ All Arabic RTL tests passed!');
    });

    testWidgets('Weekly progress tracker has RTL layout', (
      WidgetTester tester,
    ) async {
      print('Testing RTL layout in weekly progress tracker...');

      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Find Row widgets with RTL text direction
      final rtlRows = find.byWidgetPredicate((widget) {
        return widget is Row && widget.textDirection == TextDirection.rtl;
      });

      // We should have at least 3 RTL rows (one for title, one for days, one for legend)
      expect(rtlRows, findsAtLeast(3));
      print('✓ Found RTL Row widgets for title, days and legend');

      // Check that the title row has right alignment for RTL
      final titleRows = find.byWidgetPredicate((widget) {
        return widget is Row &&
            widget.textDirection == TextDirection.rtl &&
            widget.mainAxisAlignment == MainAxisAlignment.end;
      });

      expect(titleRows, findsAtLeast(1));
      print('✓ Found title Row with RTL and right alignment');

      // Find Text widgets with RTL text direction
      final rtlTexts = find.byWidgetPredicate((widget) {
        return widget is Text && widget.textDirection == TextDirection.rtl;
      });

      // Should have RTL text widgets for title, day names and legend labels
      expect(rtlTexts, findsAtLeast(8));
      print('✓ Found RTL Text widgets for title, day names and legend');

      print('✓ RTL layout tests passed!');
    });
  });
}
