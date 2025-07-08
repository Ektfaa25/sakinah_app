import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/core/theme/app_typography.dart';
import 'package:sakinah_app/features/mood/domain/entities/mood.dart';
import 'package:sakinah_app/features/mood/presentation/bloc/mood_bloc.dart';
import 'package:sakinah_app/features/mood/presentation/widgets/mood_card.dart';
import 'package:sakinah_app/l10n/app_localizations.dart';

class MoodSelectionPage extends StatefulWidget {
  const MoodSelectionPage({super.key});

  @override
  State<MoodSelectionPage> createState() => _MoodSelectionPageState();
}

class _MoodSelectionPageState extends State<MoodSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();

    // Load moods when page initializes
    context.read<MoodBloc>().add(const LoadMoods());
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isArabic = AppTypography.isArabicLocale(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocConsumer<MoodBloc, MoodState>(
          listener: (context, state) {
            if (state is MoodSelected) {
              // Show success feedback
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );

              // Navigate to azkar display after a short delay
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (mounted) {
                  context.push(
                    '${AppRoutes.azkarDisplay}?mood=${state.mood.name}',
                  );
                }
              });
            } else if (state is MoodError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MoodLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Title section with animations
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInDown(
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              localizations?.howAreYouFeeling ??
                                  'How are you feeling today?',
                              style: isArabic
                                  ? ArabicTextStyles.headline.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    )
                                  : EnglishTextStyles.headline.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 200),
                            child: Text(
                              localizations?.selectMood ?? 'Select your mood',
                              style:
                                  (isArabic
                                          ? ArabicTextStyles.body
                                          : EnglishTextStyles.body)
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Mood grid
                    Expanded(child: _buildMoodGrid(state)),

                    const SizedBox(height: 24),

                    // Skip button
                    FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 800),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go(AppRoutes.home),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          child: Text(
                            isArabic ? 'تخطي' : 'Skip',
                            style: (isArabic
                                ? ArabicTextStyles.body
                                : EnglishTextStyles.button),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMoodGrid(MoodState state) {
    final moods = state is MoodLoaded ? state.moods : Mood.predefinedMoods;
    final selectedMood = state is MoodLoaded ? state.selectedMood : null;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: moods.length.clamp(0, 6), // Show max 6 moods for better UX
      itemBuilder: (context, index) {
        final mood = moods[index];
        final isSelected = selectedMood?.name == mood.name;

        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          delay: Duration(milliseconds: 300 + (index * 100)),
          child: MoodCard(
            mood: mood,
            isSelected: isSelected,
            onTap: () => _onMoodSelected(mood),
          ),
        );
      },
    );
  }

  void _onMoodSelected(Mood mood) {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Select mood via Bloc
    context.read<MoodBloc>().add(SelectMood(mood: mood));
  }
}
