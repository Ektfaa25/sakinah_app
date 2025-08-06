import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/features/azkar/presentation/bloc/azkar_bloc.dart';

class AzkarDisplayPage extends StatefulWidget {
  final String? mood;
  final String? category;

  const AzkarDisplayPage({super.key, this.mood, this.category});

  @override
  State<AzkarDisplayPage> createState() => _AzkarDisplayPageState();
}

class _AzkarDisplayPageState extends State<AzkarDisplayPage>
    with TickerProviderStateMixin {
  late PageController _pageController;

  // Counter state management
  Map<int, int> _azkarCounts = {};
  Map<int, bool> _azkarCompleted = {};
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Initialize pulse animation for counter
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<AzkarBloc>();
        if (widget.mood != null) {
          bloc.add(LoadAzkarByMood(widget.mood!));
        } else if (widget.category != null) {
          bloc.add(LoadAzkarByCategory(widget.category!));
        } else {
          bloc.add(const LoadAzkar());
        }
        return bloc;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.background.withOpacity(0.26),
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.background.withOpacity(0.9),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: BlocBuilder<AzkarBloc, AzkarState>(
                    builder: (context, state) {
                      if (state is AzkarLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AzkarError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load azkar',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AzkarBloc>().add(
                                    const RefreshAzkar(),
                                  );
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (state is AzkarLoaded) {
                        return _buildAzkarContent(
                          context,
                          state.azkarList,
                          state.completedAzkarIds,
                        );
                      } else {
                        return const Center(child: Text('No azkar available'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    String title = 'أذكار';
    if (widget.mood != null) {
      title = 'الاذكار التي تقال عند ${_getMoodDisplayName(widget.mood!)}';
    } else if (widget.category != null) {
      title = _getCategoryDisplayName(widget.category!);
    }

    return Container(
      height: 120,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(
            color: _getMoodColor(context).withOpacity(0.3),
            width: 4.0,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          // Clean back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
            tooltip: 'رجوع',
          ),
          // Centered title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodDisplayName(String mood) {
    switch (mood) {
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
        return 'هادئ';
      default:
        return mood;
    }
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'morning':
        return 'أذكار الصباح';
      case 'evening':
        return 'أذكار المساء';
      case 'gratitude':
        return 'أذكار الشكر';
      case 'peace':
        return 'السكينة والهدوء';
      case 'stress_relief':
        return 'تفريج الكرب';
      case 'protection':
        return 'أذكار الحماية';
      default:
        return 'أذكار';
    }
  }

  Color _getMoodColor(BuildContext context) {
    if (widget.mood != null) {
      switch (widget.mood!) {
        case 'happy':
          return Colors.orange;
        case 'sad':
          return Colors.blue;
        case 'anxious':
          return Colors.purple;
        case 'grateful':
          return Colors.green;
        case 'stressed':
          return Colors.red;
        case 'peaceful':
          return Colors.teal;
        default:
          return Theme.of(context).colorScheme.primary;
      }
    }
    return Theme.of(context).colorScheme.primary;
  }

  Widget _buildAzkarContent(
    BuildContext context,
    List<Azkar> azkarList,
    Set<int> completedIds,
  ) {
    if (azkarList.isEmpty) {
      return const Center(child: Text('No azkar found'));
    }

    return Column(
      children: [
        // Azkar display
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            reverse: true,
            itemCount: azkarList.length,
            itemBuilder: (context, index) {
              final azkar = azkarList[index];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Azkar text
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),

                      child: Text(
                        azkar.arabicText,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 2.2,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: 'Amiri',
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ), // Space between text and counter
                    // Circular counter
                    _buildCounterCircle(azkar, index),
                    const SizedBox(
                      height: 20,
                    ), // Space between counter and repetition text
                    _buildRepetitionText(azkar, index),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCounterCircle(Azkar azkar, int azkarIndex) {
    final currentCount = _azkarCounts[azkarIndex] ?? 0;
    final isCompleted = _azkarCompleted[azkarIndex] ?? false;
    final progress = currentCount / azkar.repetitions;
    final categoryColor = Theme.of(context).colorScheme.primary;

    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress indicator
            SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 4,
                backgroundColor: categoryColor.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted ? Colors.green : categoryColor,
                ),
                strokeCap: StrokeCap.round,
              ),
            ),
            // Counter button
            ScaleTransition(
              scale: _pulseAnimation,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isCompleted
                      ? null
                      : () => _incrementCounter(azkar, azkarIndex),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: isCompleted
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'تم',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$currentCount',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 1.5,
                                  color: Colors.white.withOpacity(0.6),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                ),
                                Text(
                                  '${azkar.repetitions}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepetitionText(Azkar azkar, int azkarIndex) {
    final isCompleted = _azkarCompleted[azkarIndex] ?? false;
    final categoryColor = _getMoodColor(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: (isCompleted ? Colors.green : categoryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (isCompleted ? Colors.green : categoryColor).withOpacity(
              0.3,
            ),
            width: 1,
          ),
        ),
        child: Text(
          'يُكرر ${azkar.repetitions} ${_getRepetitionWord(azkar.repetitions)}',
          style: TextStyle(
            color: isCompleted ? Colors.green.shade700 : categoryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  String _getRepetitionWord(int count) {
    if (count == 1) {
      return 'مرة';
    } else if (count == 2) {
      return 'مرتين';
    } else {
      return 'مرات';
    }
  }

  void _incrementCounter(Azkar azkar, int azkarIndex) {
    final currentCount = _azkarCounts[azkarIndex] ?? 0;
    final isCompleted = _azkarCompleted[azkarIndex] ?? false;

    if (currentCount < azkar.repetitions && !isCompleted) {
      setState(() {
        _azkarCounts[azkarIndex] = currentCount + 1;
        _azkarCompleted[azkarIndex] =
            _azkarCounts[azkarIndex]! >= azkar.repetitions;
      });

      // Pulse animation
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });

      // Show completion message
      if (_azkarCompleted[azkarIndex]!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'بارك الله فيك! تم الانتهاء من الذكر',
              textDirection: TextDirection.rtl,
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}
