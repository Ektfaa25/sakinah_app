import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              // English greeting
              Text(
                'Peace be upon you',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),

              // Quick actions section
              Text(
                'اليوم', // Today
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 24),

              // Action cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _ActionCard(
                      title: 'أذكار',
                      subtitle: 'Azkar',
                      icon: Icons.favorite,
                      color: Colors.teal,
                      onTap: () => context.push(AppRoutes.moodSelection),
                    ),
                    _ActionCard(
                      title: 'التقدم',
                      subtitle: 'Progress',
                      icon: Icons.trending_up,
                      color: Colors.blue,
                      onTap: () => context.push(AppRoutes.progress),
                    ),
                    _ActionCard(
                      title: 'الإعدادات',
                      subtitle: 'Settings',
                      icon: Icons.settings,
                      color: Colors.orange,
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                    _ActionCard(
                      title: 'اختبار',
                      subtitle: 'Test DB',
                      icon: Icons.developer_mode,
                      color: Colors.green,
                      onTap: () => context.push(AppRoutes.test),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick start button
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
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
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
          padding: const EdgeInsets.all(16),
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
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
