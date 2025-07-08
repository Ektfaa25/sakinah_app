import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';

class MotivationalMessage extends StatefulWidget {
  final int completedCount;
  final int goalCount;
  final int currentStreak;

  const MotivationalMessage({
    super.key,
    required this.completedCount,
    required this.goalCount,
    required this.currentStreak,
  });

  @override
  State<MotivationalMessage> createState() => _MotivationalMessageState();
}

class _MotivationalMessageState extends State<MotivationalMessage> {
  String _getMessage() {
    final progress = widget.completedCount / widget.goalCount;

    if (widget.completedCount == 0) {
      return _getStartingMessages()[DateTime.now().millisecond %
          _getStartingMessages().length];
    } else if (progress < 0.25) {
      return _getEarlyProgressMessages()[DateTime.now().millisecond %
          _getEarlyProgressMessages().length];
    } else if (progress < 0.5) {
      return _getMidProgressMessages()[DateTime.now().millisecond %
          _getMidProgressMessages().length];
    } else if (progress < 0.75) {
      return _getGoodProgressMessages()[DateTime.now().millisecond %
          _getGoodProgressMessages().length];
    } else if (progress < 1.0) {
      return _getAlmostDoneMessages()[DateTime.now().millisecond %
          _getAlmostDoneMessages().length];
    } else {
      return _getCompletedMessages()[DateTime.now().millisecond %
          _getCompletedMessages().length];
    }
  }

  IconData _getMessageIcon() {
    final progress = widget.completedCount / widget.goalCount;

    if (widget.completedCount == 0) {
      return Icons.wb_sunny;
    } else if (progress < 0.25) {
      return Icons.eco;
    } else if (progress < 0.5) {
      return Icons.trending_up;
    } else if (progress < 0.75) {
      return Icons.star_half;
    } else if (progress < 1.0) {
      return Icons.flash_on;
    } else {
      return Icons.celebration;
    }
  }

  Color _getMessageColor(BuildContext context) {
    final theme = Theme.of(context);
    final progress = widget.completedCount / widget.goalCount;

    if (widget.completedCount == 0) {
      return theme.colorScheme.primary;
    } else if (progress < 0.5) {
      return Colors.blue;
    } else if (progress < 1.0) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = _getMessage();
    final icon = _getMessageIcon();
    final color = _getMessageColor(context);

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: GlassyContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  if (widget.currentStreak > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.currentStreak} day streak!',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getStartingMessages() {
    return [
      "Every journey begins with a single step. Start with just one azkar today.",
      "The best time to plant a tree was 20 years ago. The second best time is now.",
      "Small steps daily lead to big changes yearly. Begin when you're ready.",
      "Your spiritual journey is unique. Start at your own pace.",
      "Even the smallest act of remembrance can brighten your day.",
      "Today is a new opportunity to connect with peace and gratitude.",
    ];
  }

  List<String> _getEarlyProgressMessages() {
    return [
      "Beautiful start! Every azkar you complete is a seed of tranquility.",
      "You're building something wonderful. Keep going at your own pace.",
      "Each remembrance is a step toward inner peace. Well done!",
      "Starting is often the hardest part, and you've already begun.",
      "Your consistent effort, no matter how small, is creating positive change.",
      "You're cultivating a habit that will bring lasting peace.",
    ];
  }

  List<String> _getMidProgressMessages() {
    return [
      "You're finding your rhythm! This consistency is building strength.",
      "Halfway there! Your dedication is showing beautiful results.",
      "Your persistence is inspiring. Keep nurturing this positive habit.",
      "You're making steady progress. Each azkar adds to your inner peace.",
      "This is how lasting change happens - one mindful moment at a time.",
      "Your commitment to spiritual growth is truly admirable.",
    ];
  }

  List<String> _getGoodProgressMessages() {
    return [
      "Excellent progress! You're creating a beautiful routine of remembrance.",
      "You're so close to your goal! Your dedication is remarkable.",
      "Your spiritual practice is flourishing. Keep up this wonderful momentum.",
      "You're building something truly special with your consistent effort.",
      "Almost there! Your perseverance is creating lasting positive change.",
      "Your commitment to daily remembrance is truly inspiring.",
    ];
  }

  List<String> _getAlmostDoneMessages() {
    return [
      "So close! You're about to achieve something wonderful today.",
      "Just a little more! Your goal is within reach.",
      "You're almost there! Your consistency is about to pay off beautifully.",
      "One more push! You're doing amazingly well.",
      "You're on the verge of completing your daily goal. Keep going!",
      "Almost at the finish line! Your dedication is truly commendable.",
    ];
  }

  List<String> _getCompletedMessages() {
    return [
      "🎉 Goal achieved! You've completed your daily spiritual practice.",
      "✨ Wonderful! You've fulfilled your commitment to remembrance today.",
      "🌟 Excellent work! You've completed your daily azkar goal.",
      "🏆 Success! Your consistency and dedication have paid off beautifully.",
      "💫 Amazing! You've reached your daily goal with grace.",
      "🌸 Beautiful! You've completed another day of mindful remembrance.",
      "🌺 Congratulations! Your spiritual practice is thriving.",
    ];
  }
}
