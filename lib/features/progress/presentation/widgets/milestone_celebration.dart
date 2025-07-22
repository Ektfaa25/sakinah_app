import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';

class MilestoneCelebration extends StatelessWidget {
  final int streakCount;
  final int totalAzkar;
  final VoidCallback? onCelebrate;

  const MilestoneCelebration({
    super.key,
    required this.streakCount,
    required this.totalAzkar,
    this.onCelebrate,
  });

  @override
  Widget build(BuildContext context) {
    final milestone = _getCurrentMilestone();
    if (milestone == null) return const SizedBox();

    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: GlassyContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Celebration animation
            ZoomIn(
              duration: const Duration(milliseconds: 1000),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: milestone.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(milestone.icon, size: 48, color: milestone.color),
              ),
            ),
            const SizedBox(height: 16),

            // Milestone title
            Text(
              milestone.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: milestone.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Milestone description
            Text(
              milestone.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Celebrate button
            ElevatedButton.icon(
              onPressed: onCelebrate,
              icon: const Icon(Icons.celebration),
              label: const Text('Celebrate!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: milestone.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MilestoneData? _getCurrentMilestone() {
    // Streak milestones
    if (streakCount == 3) {
      return MilestoneData(
        title: '3-Day Streak!',
        description: 'You\'re building a beautiful habit of remembrance.',
        icon: Icons.local_fire_department,
        color: Colors.orange,
      );
    } else if (streakCount == 7) {
      return MilestoneData(
        title: 'Week Warrior!',
        description: 'A full week of consistent spiritual practice.',
        icon: Icons.star,
        color: Colors.blue,
      );
    } else if (streakCount == 30) {
      return MilestoneData(
        title: 'Month Master!',
        description:
            'Incredible! You\'ve maintained your practice for a full month.',
        icon: Icons.emoji_events,
        color: Colors.amber,
      );
    } else if (streakCount == 100) {
      return MilestoneData(
        title: 'Century Champion!',
        description: 'Amazing dedication! 100 days of consistent remembrance.',
        icon: Icons.diamond,
        color: Colors.purple,
      );
    }

    // Total azkar milestones
    if (totalAzkar == 50) {
      return MilestoneData(
        title: 'First 50 Azkar!',
        description: 'Your journey of remembrance is flourishing.',
        icon: Icons.auto_awesome,
        color: Colors.amber,
      );
    } else if (totalAzkar == 100) {
      return MilestoneData(
        title: 'Century of Remembrance!',
        description:
            'You\'ve completed 100 azkar. What a beautiful achievement!',
        icon: Icons.auto_awesome,
        color: Colors.green,
      );
    } else if (totalAzkar == 500) {
      return MilestoneData(
        title: 'Remembrance Master!',
        description: '500 azkar completed! Your dedication is truly inspiring.',
        icon: Icons.workspace_premium,
        color: Colors.indigo,
      );
    } else if (totalAzkar == 1000) {
      return MilestoneData(
        title: 'Thousand Stars!',
        description: '1000 azkar! You\'ve created a galaxy of remembrance.',
        icon: Icons.stars,
        color: Colors.deepPurple,
      );
    }

    return null;
  }
}

class MilestoneData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  MilestoneData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
