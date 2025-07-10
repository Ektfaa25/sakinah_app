import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar_new.dart';
import 'package:sakinah_app/features/azkar/data/services/azkar_database_adapter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Navigate directly to the first azkar of a category
  void _navigateToAzkarDetail(BuildContext context, String categoryId) async {
    try {
      // Fetch azkar for the category
      final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
        categoryId,
      );

      if (azkarList.isNotEmpty && context.mounted) {
        // Create category object
        final category = _createCategoryFromId(categoryId);
        if (category != null) {
          // Navigate to the first azkar in the category
          context.push(
            '${AppRoutes.azkarDetailNew}/${azkarList.first.id}',
            extra: {
              'azkar': azkarList.first,
              'category': category,
              'azkarIndex': 0,
              'totalAzkar': azkarList.length,
              'azkarList': azkarList,
            },
          );
        }
      } else if (context.mounted) {
        // Show error if no azkar found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No azkar found for this category')),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading azkar: $e')));
      }
    }
  }

  /// Create a temporary AzkarCategory object from category ID
  AzkarCategory? _createCategoryFromId(String categoryId) {
    final now = DateTime.now();

    switch (categoryId) {
      case 'morning':
        return AzkarCategory(
          id: 'morning',
          nameAr: 'أذكار الصباح',
          nameEn: 'Morning Azkar',
          description: 'Morning remembrance of Allah',
          icon: 'morning',
          color: '#FF9800',
          orderIndex: 1,
          isActive: true,
          createdAt: now,
        );
      case 'evening':
        return AzkarCategory(
          id: 'evening',
          nameAr: 'أذكار المساء',
          nameEn: 'Evening Azkar',
          description: 'Evening remembrance of Allah',
          icon: 'evening',
          color: '#3F51B5',
          orderIndex: 2,
          isActive: true,
          createdAt: now,
        );
      case 'sleep':
        return AzkarCategory(
          id: 'sleep',
          nameAr: 'أذكار النوم',
          nameEn: 'Sleep Azkar',
          description: 'Bedtime remembrance of Allah',
          icon: 'sleep',
          color: '#9C27B0',
          orderIndex: 3,
          isActive: true,
          createdAt: now,
        );
      case 'after_prayer':
        return AzkarCategory(
          id: 'after_prayer',
          nameAr: 'الأذكار بعد الصلاة',
          nameEn: 'After Prayer Azkar',
          description: 'Remembrance after prayer',
          icon: 'after_prayer',
          color: '#009688',
          orderIndex: 4,
          isActive: true,
          createdAt: now,
        );
      case 'istighfar_tawbah':
        return AzkarCategory(
          id: 'istighfar_tawbah',
          nameAr: 'الاستغفار والتوبة',
          nameEn: 'Istighfar & Tawbah',
          description: 'Seeking forgiveness and repentance',
          icon: 'istighfar',
          color: '#F44336',
          orderIndex: 5,
          isActive: true,
          createdAt: now,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Arabic greeting
              Text(
                'السلام عليكم',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .black87, // Changed to black87 for better visibility
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              // English greeting
              Text(
                'Peace be upon you',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors
                      .black87, // Changed to black87 for better visibility
                ),
              ),
              const SizedBox(height: 48),

              // Mood selection button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppRoutes.moodSelection),
                  icon: const Icon(Icons.psychology),
                  label: const Text('كيف تشعر اليوم؟'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Azkar categories section
              Text(
                'الاذكار', // Azkar
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .black87, // Changed to black87 for better visibility
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 16),

              // Azkar category cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _AzkarCategoryCard(
                      title: 'أذكار الصباح',
                      subtitle: 'Morning',
                      icon: Icons.wb_sunny,
                      color: Colors.orange,
                      categoryId: 'morning',
                      onTap: () => _navigateToAzkarDetail(context, 'morning'),
                    ),
                    _AzkarCategoryCard(
                      title: 'أذكار المساء',
                      subtitle: 'Evening',
                      icon: Icons.nights_stay,
                      color: Colors.indigo,
                      categoryId: 'evening',
                      onTap: () => _navigateToAzkarDetail(context, 'evening'),
                    ),
                    _AzkarCategoryCard(
                      title: 'أذكار النوم',
                      subtitle: 'Sleep',
                      icon: Icons.bedtime,
                      color: Colors.purple,
                      categoryId: 'sleep',
                      onTap: () => _navigateToAzkarDetail(context, 'sleep'),
                    ),
                    _AzkarCategoryCard(
                      title: 'الأذكار بعد الصلاة',
                      subtitle: 'After Prayer',
                      icon: Icons.mosque,
                      color: Colors.teal,
                      categoryId: 'after_prayer',
                      onTap: () =>
                          _navigateToAzkarDetail(context, 'after_prayer'),
                    ),
                    _AzkarCategoryCard(
                      title: 'الاستغفار والتوبة',
                      subtitle: 'Istighfar',
                      icon: Icons.favorite,
                      color: Colors.red,
                      categoryId: 'istighfar_tawbah',
                      onTap: () =>
                          _navigateToAzkarDetail(context, 'istighfar_tawbah'),
                    ),
                    _AzkarCategoryCard(
                      title: 'المزيد من الأذكار',
                      subtitle: 'More Azkar',
                      icon: Icons.grid_view,
                      color: Colors.grey,
                      categoryId: null,
                      onTap: () => context.push(AppRoutes.azkarCategories),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AzkarCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? categoryId;
  final VoidCallback onTap;

  const _AzkarCategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.categoryId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: color), // Smaller icon
              const SizedBox(height: 8), // Reduced spacing
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .black87, // Changed to black87 for better visibility
                  fontSize: 12, // Smaller font size for card titles
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2), // Reduced spacing
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors
                      .black87, // Changed to black87 for better visibility
                  fontSize: 10, // Smaller font size for subtitles
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
