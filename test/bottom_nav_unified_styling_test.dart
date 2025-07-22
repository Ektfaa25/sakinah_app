import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bottom Navigation Bar Unified Styling Tests', () {
    testWidgets('should have gradient background with rounded corners', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: _TestBottomNavBar(),
          ),
        ),
      );

      // Verify that gradient container exists
      expect(find.byType(Container), findsWidgets);

      // Verify that BottomNavigationBar exists
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify that ClipRRect is used for rounded corners
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should have correct navy blue text color', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: _TestBottomNavBar(),
          ),
        ),
      );

      // Find the BottomNavigationBar widget
      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Verify navy blue color is used
      expect(bottomNavBar.selectedItemColor, const Color(0xFF1A1A2E));
      expect(
        bottomNavBar.unselectedItemColor,
        const Color(0xFF1A1A2E).withOpacity(0.6),
      );
    });

    testWidgets('should have transparent background', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: _TestBottomNavBar(),
          ),
        ),
      );

      // Find the BottomNavigationBar widget
      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Verify transparent background
      expect(bottomNavBar.backgroundColor, Colors.transparent);
    });

    testWidgets('should have correct font weights and sizes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: _TestBottomNavBar(),
          ),
        ),
      );

      // Find the BottomNavigationBar widget
      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      // Verify font styling
      expect(bottomNavBar.selectedLabelStyle?.fontWeight, FontWeight.w600);
      expect(bottomNavBar.selectedLabelStyle?.fontSize, 12);
      expect(bottomNavBar.unselectedLabelStyle?.fontWeight, FontWeight.w400);
      expect(bottomNavBar.unselectedLabelStyle?.fontSize, 11);
    });
  });
}

class _TestBottomNavBar extends StatefulWidget {
  @override
  _TestBottomNavBarState createState() => _TestBottomNavBarState();
}

class _TestBottomNavBarState extends State<_TestBottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getGradientColor(0).withOpacity(0.3),
            _getGradientColor(1).withOpacity(0.3),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color(0xFF1A1A2E),
          unselectedItemColor: const Color(0xFF1A1A2E).withOpacity(0.6),
          currentIndex: _currentIndex,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
          items: [
            _buildStyledNavItem(Icons.home, 'الرئيسية', 0),
            _buildStyledNavItem(Icons.grid_view, 'الفئات', 1),
            _buildStyledNavItem(Icons.favorite, 'المفضلة', 2),
            _buildStyledNavItem(Icons.show_chart, 'التقدم', 3),
            _buildStyledNavItem(Icons.settings, 'الإعدادات', 4),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildStyledNavItem(
    IconData iconData,
    String label,
    int index,
  ) {
    final isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          iconData,
          color: isSelected
              ? _getGradientColor(index)
              : const Color(0xFF1A1A2E).withOpacity(0.6),
          size: 22,
        ),
      ),
      label: label,
    );
  }

  Color _getGradientColor(int index) {
    final colors = [
      _getColorFromHex('#FBF8CC'), // Light yellow
      _getColorFromHex('#A3C4F3'), // Light blue
      _getColorFromHex('#FDE4CF'), // Light peach
      _getColorFromHex('#90DBF4'), // Light cyan
      _getColorFromHex('#98F5E1'), // Light mint
      _getColorFromHex('#B9FBC0'), // Light green
      _getColorFromHex('#FFCFD2'), // Light pink
      _getColorFromHex('#F1C0E8'), // Light purple
      _getColorFromHex('#CFBAF0'), // Light lavender
      _getColorFromHex('#8EECF5'), // Light turquoise
    ];
    return colors[index % colors.length];
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
