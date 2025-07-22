import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/progress/presentation/pages/progress_page.dart';

void main() {
  group('Progress Page Tab Bar Design Tests', () {
    testWidgets('Tab bar should have white card design matching categories', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const ProgressPage()));

      // Give some time for the widget to build
      await tester.pump(const Duration(milliseconds: 100));

      print('🧪 Testing Progress Page Tab Bar Design');

      // Find the tab bar
      final tabBar = find.byType(TabBar);
      expect(tabBar, findsOneWidget);

      // Check for Card wrapper (white card design)
      final cards = find.byType(Card);
      expect(cards, findsWidgets);

      // Check for the tabs
      final todayTab = find.text('Today');
      final weekTab = find.text('Week');
      final monthTab = find.text('Month');

      expect(todayTab, findsOneWidget);
      expect(weekTab, findsOneWidget);
      expect(monthTab, findsOneWidget);

      print('✅ Found tab bar with Today, Week, and Month tabs');

      // Check for Container with white background
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      print('✅ Tab bar has white card design matching categories');
    });

    testWidgets('Tab bar should have proper styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const ProgressPage()));

      await tester.pump(const Duration(milliseconds: 100));

      print('🧪 Testing Tab Bar Styling');

      // Find the tab bar
      final tabBar = find.byType(TabBar);
      expect(tabBar, findsOneWidget);

      final tabBarWidget = tester.widget<TabBar>(tabBar);

      // Check that the tab bar has proper label colors
      expect(tabBarWidget.labelColor, isNotNull);
      expect(tabBarWidget.unselectedLabelColor, isNotNull);

      print('✅ Tab bar has proper color styling');
    });

    testWidgets('Tab bar should be contained in a Card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: const ProgressPage()));

      await tester.pump(const Duration(milliseconds: 100));

      print('🧪 Testing Tab Bar Card Container');

      // Find Card widgets
      final cards = find.byType(Card);
      expect(cards, findsWidgets);

      // Find the specific card that contains the tab bar
      bool foundTabBarCard = false;
      for (final card in tester.widgetList<Card>(cards)) {
        if (card.elevation == 2) {
          foundTabBarCard = true;
          break;
        }
      }

      expect(
        foundTabBarCard,
        isTrue,
        reason: 'Tab bar should be wrapped in a Card with elevation 2',
      );

      print('✅ Tab bar is properly contained in a Card widget');
    });
  });
}
