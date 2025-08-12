import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/azkar_new.dart';

/// Reusable azkar category card widget used across home page and categories screen
class AzkarCategoryCard extends StatelessWidget {
  final AzkarCategory category;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  final String? subtitle;

  const AzkarCategoryCard({
    super.key,
    required this.category,
    required this.color,
    required this.icon,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Remove shadow for clean design
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20), // Reduced from 24 to 20
          decoration: BoxDecoration(
            gradient: _createBrightGradient(color),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white, // White background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withOpacity(0.3), // Border using card color
                    width: 4,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 22, // Slightly smaller icon
                  color: Color.lerp(
                    color,
                    Colors.black,
                    0.4,
                  ), // Darker shade of the same color
                ),
              ),
              const SizedBox(height: 6), // Reduced spacing from 8 to 6
              Flexible(
                // Wrap title text in Flexible to prevent overflow
                child: Text(
                  category.nameAr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(
                            0xFF1A1A2E,
                          ), // White text for dark theme, dark text for light theme
                    fontSize: 11, // Slightly smaller font size
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 2), // Keep reduced spacing
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.8)
                        : const Color(
                            0xFF1A1A2E,
                          ), // White text with opacity for dark theme, dark text for light theme
                    fontSize: 9, // Smaller font size for subtitles
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Create a bright gradient using the same color family
  LinearGradient _createBrightGradient(Color baseColor) {
    // Create monochromatic gradient using the same color family but with different brightness levels
    final lightColor = Color.lerp(
      baseColor,
      Colors.white,
      0.5,
    )!; // Very light version
    final mediumColor = Color.lerp(
      baseColor,
      Colors.white,
      0.2,
    )!; // Medium light version
    final originalColor = baseColor; // Original pastel color
    final slightlyDarker = Color.lerp(
      baseColor,
      Colors.black,
      0.1,
    )!; // Slightly deeper
    final deeperColor = Color.lerp(
      baseColor,
      Colors.black,
      0.2,
    )!; // Deeper for shadow

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        lightColor, // Brightest at top-left
        mediumColor, // Medium brightness
        originalColor, // Original pastel color in center
        slightlyDarker, // Slightly deeper
        deeperColor, // Deepest at bottom-right
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );
  }
}
