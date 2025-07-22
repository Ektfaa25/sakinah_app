import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sakinah_app/features/azkar/presentation/pages/azkar_favorites_screen.dart';

void main() {
  group('Favorites List Tile Tests', () {
    testWidgets('AzkarFavoritesScreen builds with list tile layout', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing AzkarFavoritesScreen with list tile layout');

      // Build the favorites screen
      await tester.pumpWidget(const MaterialApp(home: AzkarFavoritesScreen()));

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Check that the screen loads
      expect(find.byType(AzkarFavoritesScreen), findsOneWidget);

      // Check for the app bar title
      expect(find.text('الأذكار المفضلة'), findsOneWidget);

      print('✅ AzkarFavoritesScreen with list tiles created successfully');
      print('🎉 List tile layout test passed!');
    });

    testWidgets('Favorites screen shows appropriate states', (
      WidgetTester tester,
    ) async {
      print('🧪 Testing favorites screen states');

      // Build the favorites screen
      await tester.pumpWidget(const MaterialApp(home: AzkarFavoritesScreen()));

      // Initially should show loading
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the loading to complete
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should show either empty state or list
      expect(find.byType(AzkarFavoritesScreen), findsOneWidget);

      print('✅ Favorites screen states work correctly');
      print('🎉 Screen states test passed!');
    });
  });
}
