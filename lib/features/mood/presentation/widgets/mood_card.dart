import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakinah_app/features/mood/domain/entities/mood.dart';

/// A beautiful animated mood selection card with gradient backgrounds
class MoodCard extends StatefulWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodCard({
    super.key,
    required this.mood,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<MoodCard> createState() => _MoodCardState();
}

class _MoodCardState extends State<MoodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getMoodColor() {
    switch (widget.mood.name.toLowerCase()) {
      case 'happy':
        return const Color(0xFFFFD54F); // Warm yellow
      case 'sad':
        return const Color(0xFF64B5F6); // Soft blue
      case 'anxious':
        return const Color(0xFFFFB74D); // Orange
      case 'grateful':
        return const Color(0xFF81C784); // Green
      case 'stressed':
        return const Color(0xFFE57373); // Red
      case 'peaceful':
        return const Color(0xFF90CAF9); // Light blue
      case 'excited':
        return const Color(0xFFFF8A65); // Coral
      case 'confused':
        return const Color(0xFFBDBDBD); // Grey
      case 'hopeful':
        return const Color(0xFFFFF176); // Light yellow
      case 'tired':
        return const Color(0xFFB39DDB); // Light purple
      default:
        return const Color(0xFF90CAF9);
    }
  }

  String _getMoodNameArabic() {
    switch (widget.mood.name.toLowerCase()) {
      case 'happy':
        return 'سعيد';
      case 'sad':
        return 'حزين';
      case 'anxious':
        return 'قلق';
      case 'grateful':
        return 'شاكر';
      case 'stressed':
        return 'متوتر';
      case 'peaceful':
        return 'مطمئن';
      case 'excited':
        return 'متحمس';
      case 'confused':
        return 'متحير';
      case 'hopeful':
        return 'متفائل';
      case 'tired':
        return 'متعب';
      default:
        return widget.mood.name;
    }
  }

  String _getMoodNameEnglish() {
    return widget.mood.name[0].toUpperCase() + widget.mood.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final moodColor = _getMoodColor();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: GestureDetector(
              onTapDown: (_) {
                _controller.forward();
                HapticFeedback.selectionClick();
              },
              onTapUp: (_) {
                _controller.reverse();
                widget.onTap();
              },
              onTapCancel: () {
                _controller.reverse();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isSelected
                        ? [
                            moodColor.withOpacity(0.6),
                            moodColor.withOpacity(0.4),
                          ]
                        : [
                            moodColor.withOpacity(0.4),
                            moodColor.withOpacity(0.25),
                          ],
                  ),
                  border: widget.isSelected
                      ? Border.all(color: moodColor, width: 2)
                      : Border.all(color: moodColor.withOpacity(0.6), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: moodColor.withOpacity(
                        widget.isSelected ? 0.3 : 0.1,
                      ),
                      blurRadius: widget.isSelected ? 12 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emoji with pulse animation
                      ElasticIn(
                        duration: const Duration(milliseconds: 800),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: widget.isSelected ? 36 : 32,
                          ),
                          child: Text(widget.mood.emoji),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Mood name in Arabic
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          _getMoodNameArabic(),
                          style: GoogleFonts.playpenSans(
                            color: moodColor.withOpacity(0.9),
                            fontWeight: widget.isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 14,
                          ),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Mood name in English
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          _getMoodNameEnglish(),
                          style: GoogleFonts.playpenSans(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Selection indicator
                      if (widget.isSelected) ...[
                        const SizedBox(height: 6),
                        FadeIn(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: moodColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
