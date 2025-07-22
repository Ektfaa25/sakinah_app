import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';

/// An animated streak counter widget with beautiful glassmorphism design
class StreakCounter extends StatefulWidget {
  final int streakCount;
  final String label;
  final Color? primaryColor;
  final Color? accentColor;
  final bool showFire;
  final VoidCallback? onTap;

  const StreakCounter({
    super.key,
    required this.streakCount,
    this.label = 'Day Streak',
    this.primaryColor,
    this.accentColor,
    this.showFire = true,
    this.onTap,
  });

  @override
  State<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _countController;
  late Animation<double> _pulseAnimation;
  late Animation<int> _countAnimation;

  int _previousCount = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _countController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _countAnimation = IntTween(begin: 0, end: widget.streakCount).animate(
      CurvedAnimation(parent: _countController, curve: Curves.easeOutBack),
    );

    _previousCount = widget.streakCount;
    _countController.forward();

    // Start pulse animation if streak > 0
    if (widget.streakCount > 0) {
      _startPulseAnimation();
    }
  }

  @override
  void didUpdateWidget(StreakCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.streakCount != widget.streakCount) {
      _animateCountChange();
    }
  }

  void _animateCountChange() {
    _countAnimation = IntTween(begin: _previousCount, end: widget.streakCount)
        .animate(
          CurvedAnimation(parent: _countController, curve: Curves.easeOutBack),
        );

    _countController.reset();
    _countController.forward();
    _previousCount = widget.streakCount;

    // Start/stop pulse based on streak
    if (widget.streakCount > 0) {
      _startPulseAnimation();
    } else {
      _pulseController.stop();
    }
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.colorScheme.primary;
    final accentColor = widget.accentColor ?? theme.colorScheme.secondary;

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: GlassyContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fire icon (if enabled and streak > 0)
                    if (widget.showFire && widget.streakCount > 0) ...[
                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.local_fire_department,
                            size: 24,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Animated streak count
                    AnimatedBuilder(
                      animation: _countAnimation,
                      builder: (context, child) {
                        return Text(
                          '${_countAnimation.value}',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 4),

                    // Label
                    Text(
                      widget.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Progress indicator
                    if (widget.streakCount > 0) ...[
                      const SizedBox(height: 12),
                      _buildProgressRing(primaryColor, accentColor),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressRing(Color primaryColor, Color accentColor) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          // Background ring
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 4,
              backgroundColor: primaryColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          // Progress ring (animate based on streak milestones)
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: _getProgressValue(),
              strokeWidth: 4,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  double _getProgressValue() {
    if (widget.streakCount == 0) return 0.0;

    // Calculate progress based on milestones (7, 30, 100 days)
    if (widget.streakCount < 7) {
      return widget.streakCount / 7.0;
    } else if (widget.streakCount < 30) {
      return 1.0; // Full circle for 7+ days
    } else if (widget.streakCount < 100) {
      return (widget.streakCount - 30) / 70.0; // Progress towards 100
    } else {
      return 1.0; // Full circle for 100+ days
    }
  }
}
