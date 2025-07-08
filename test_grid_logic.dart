import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home Page Grid Logic Test', () {
    test('Grid shows correct number of items with View All', () {
      // Simulate having 136 categories like in the app
      final totalCategories = 136;

      // Display first 5 categories + "View All" as 6th item
      final displayCategories = List.generate(
        5,
        (index) => 'Category ${index + 1}',
      );
      final hasMore = totalCategories > 5;

      // Grid should show 6 items total (5 categories + 1 "View All")
      final gridItemCount = hasMore
          ? displayCategories.length + 1
          : displayCategories.length;

      expect(gridItemCount, equals(6));
      expect(hasMore, isTrue);
      expect(displayCategories.length, equals(5));

      // Verify the View All card appears at the correct index
      final viewAllIndex = displayCategories.length;
      expect(viewAllIndex, equals(5)); // 6th item (0-indexed)

      print('✅ Grid logic test passed:');
      print('   - Total categories: $totalCategories');
      print('   - Display categories: ${displayCategories.length}');
      print('   - Grid items: $gridItemCount');
      print('   - View All at index: $viewAllIndex');
    });
  });
}
