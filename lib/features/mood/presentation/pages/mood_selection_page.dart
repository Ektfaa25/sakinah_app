import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/features/mood/domain/entities/mood.dart';

/// Helper class to store mood display data
class MoodDisplayData {
  final Mood mood;
  final String nameArabic;
  final String nameEnglish;
  final int color;

  const MoodDisplayData({
    required this.mood,
    required this.nameArabic,
    required this.nameEnglish,
    required this.color,
  });
}

class MoodSelectionPage extends StatelessWidget {
  const MoodSelectionPage({super.key});

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
              Text(
                'كيف تشعر اليوم؟',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              Text(
                'How are you feeling today?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: _getMoodOptions().map((moodData) {
                    return _MoodCard(
                      moodData: moodData,
                      onTap: () => _onMoodSelected(context, moodData),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('تخطي'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<MoodDisplayData> _getMoodOptions() {
    return [
      MoodDisplayData(
        mood: const Mood(
          name: 'grateful',
          emoji: '🤲',
          description: 'Feeling thankful and blessed',
        ),
        nameArabic: 'شاكر',
        nameEnglish: 'Grateful',
        color: 0xFF4CAF50,
      ),
      MoodDisplayData(
        mood: const Mood(
          name: 'anxious',
          emoji: '😰',
          description: 'Feeling worried or stressed',
        ),
        nameArabic: 'قلق',
        nameEnglish: 'Anxious',
        color: 0xFFFF9800,
      ),
      MoodDisplayData(
        mood: const Mood(
          name: 'peaceful',
          emoji: '😌',
          description: 'Feeling calm and at peace',
        ),
        nameArabic: 'مطمئن',
        nameEnglish: 'Peaceful',
        color: 0xFF2196F3,
      ),
      MoodDisplayData(
        mood: const Mood(
          name: 'sad',
          emoji: '😢',
          description: 'Feeling down or melancholy',
        ),
        nameArabic: 'حزين',
        nameEnglish: 'Sad',
        color: 0xFF9C27B0,
      ),
      MoodDisplayData(
        mood: const Mood(
          name: 'hopeful',
          emoji: '🌟',
          description: 'Feeling optimistic about the future',
        ),
        nameArabic: 'متفائل',
        nameEnglish: 'Hopeful',
        color: 0xFFFFEB3B,
      ),
      MoodDisplayData(
        mood: const Mood(
          name: 'confused',
          emoji: '🤔',
          description: 'Feeling uncertain or lost',
        ),
        nameArabic: 'متحير',
        nameEnglish: 'Confused',
        color: 0xFF607D8B,
      ),
    ];
  }

  void _onMoodSelected(BuildContext context, MoodDisplayData moodData) {
    // TODO: Save the selected mood to database
    // TODO: Navigate to azkar recommendations based on mood
    context.push('${AppRoutes.azkarDisplay}?mood=${moodData.mood.name}');
  }
}

class _MoodCard extends StatelessWidget {
  final MoodDisplayData moodData;
  final VoidCallback onTap;

  const _MoodCard({required this.moodData, required this.onTap});

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
              colors: [
                Color(moodData.color).withOpacity(0.1),
                Color(moodData.color).withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(moodData.mood.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                moodData.nameArabic,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(moodData.color),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 4),
              Text(
                moodData.nameEnglish,
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
