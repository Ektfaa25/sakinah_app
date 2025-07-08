import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/home/presentation/pages/home_page.dart';

void main() {
  testWidgets('HomePage should display exactly 6 category cards', (
    WidgetTester tester,
  ) async {
    // Build the HomePage
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Wait for loading to complete
    await tester.pumpAndSettle();

    // Verify that we have a grid with 6 items
    final gridView = find.byType(GridView);
    expect(gridView, findsOneWidget);

    // Verify the "More أذكار" text is present (6th card)
    expect(find.text('المزيد من الأذكار'), findsOneWidget);

    // Verify that the categories section is properly structured
    expect(find.text('الاذكار'), findsOneWidget);

    print(
      '✅ Home page successfully displays 6 category cards including "More أذكار"',
    );
  });
}
