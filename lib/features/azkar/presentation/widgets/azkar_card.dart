import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';

class AzkarCard extends StatefulWidget {
  final Azkar azkar;
  final bool isCompleted;
  final VoidCallback? onCompleted;
  final VoidCallback? onIncomplete;

  const AzkarCard({
    super.key,
    required this.azkar,
    this.isCompleted = false,
    this.onCompleted,
    this.onIncomplete,
  });

  @override
  State<AzkarCard> createState() => _AzkarCardState();
}

class _AzkarCardState extends State<AzkarCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _showTranslation = false;
  int _currentCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void _handleCounterTap() {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_currentCount < widget.azkar.repetitions) {
        _currentCount++;
        if (_currentCount == widget.azkar.repetitions) {
          widget.onCompleted?.call();
        }
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _currentCount = 0;
    });
    widget.onIncomplete?.call();
  }

  bool get _isCompleted => _currentCount >= widget.azkar.repetitions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _opacityAnimation.value, child: child),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) => _animationController.reverse(),
        onTapCancel: () => _animationController.reverse(),
        onTap: _handleTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withOpacity(0.30),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic Text
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      widget.azkar.arabicText,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 24,
                        height: 1.8,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1A1A2E),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Counter Circle
                  if (widget.azkar.repetitions > 1)
                    Center(
                      child: GestureDetector(
                        onTap: _handleCounterTap,
                        onLongPress: _resetCounter,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isCompleted
                                ? Colors.green.withOpacity(0.2)
                                : colorScheme.primary.withOpacity(0.1),
                            border: Border.all(
                              color: _isCompleted
                                  ? Colors.green
                                  : colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Removed count display as requested
                                Icon(
                                  _isCompleted
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: _isCompleted
                                      ? Colors.green
                                      : colorScheme.primary,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Translation and Transliteration (Expandable)
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _showTranslation
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.translate,
                            size: 16,
                            color: colorScheme.primary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tap to see translation',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary.withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Transliteration
                        if (widget.azkar.transliteration != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.azkar.transliteration!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        if (widget.azkar.transliteration != null &&
                            widget.azkar.translation != null)
                          const SizedBox(height: 12),

                        // Translation
                        if (widget.azkar.translation != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.azkar.translation!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Completion Status (Optional - for visual feedback)
                  if (_isCompleted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Completed',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
