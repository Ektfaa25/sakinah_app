import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/features/azkar/presentation/bloc/azkar_bloc.dart';
import 'package:sakinah_app/features/azkar/presentation/widgets/azkar_card.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';

class AzkarDisplayPage extends StatefulWidget {
  final String? mood;
  final String? category;

  const AzkarDisplayPage({super.key, this.mood, this.category});

  @override
  State<AzkarDisplayPage> createState() => _AzkarDisplayPageState();
}

class _AzkarDisplayPageState extends State<AzkarDisplayPage> {
  int _currentIndex = 0;
  late PageController _pageController;
  bool _isSearchMode = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              if (_isSearchMode) _buildSearchBar(context),
              if (_isSearchMode) _buildFilterChips(context),
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
                              style: Theme.of(context).textTheme.headlineSmall,
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
    );
  }

  Widget _buildAppBar(BuildContext context) {
    String title = 'أذكار';
    if (widget.mood != null) {
      title = 'أذكار • ${_getMoodDisplayName(widget.mood!)}';
    } else if (widget.category != null) {
      title = _getCategoryDisplayName(widget.category!);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
          ),
          IconButton(
            icon: Icon(_isSearchMode ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchMode = !_isSearchMode;
                if (!_isSearchMode) {
                  _searchController.clear();
                  _reloadAzkar();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Implement bookmark functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
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

  void _reloadAzkar() {
    if (widget.mood != null) {
      context.read<AzkarBloc>().add(LoadAzkarByMood(widget.mood!));
    } else if (widget.category != null) {
      context.read<AzkarBloc>().add(LoadAzkarByCategory(widget.category!));
    } else {
      context.read<AzkarBloc>().add(const LoadAzkar());
    }
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
        // Progress indicator
        Container(
          margin: const EdgeInsets.all(16),
          child: GlassyContainer(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: ((_currentIndex + 1) / azkarList.length),
              backgroundColor: Theme.of(context).colorScheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        // Azkar display
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: azkarList.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final azkar = azkarList[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: AzkarCard(
                  azkar: azkar,
                  isCompleted: azkar.id != null
                      ? completedIds.contains(azkar.id!)
                      : false,
                  onCompleted: () {
                    if (azkar.id != null) {
                      context.read<AzkarBloc>().add(
                        MarkAzkarAsCompleted(azkar.id!),
                      );
                    }
                  },
                  onIncomplete: () {
                    if (azkar.id != null) {
                      context.read<AzkarBloc>().add(
                        MarkAzkarAsIncomplete(azkar.id!),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _currentIndex > 0
                    ? () => _navigateToIndex(_currentIndex - 1)
                    : null,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: _currentIndex < azkarList.length - 1
                    ? () => _navigateToIndex(_currentIndex + 1)
                    : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassyContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search azkar...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) {
            if (query.isNotEmpty) {
              context.read<AzkarBloc>().add(SearchAzkar(query));
            } else {
              context.read<AzkarBloc>().add(
                widget.mood != null
                    ? LoadAzkarByMood(widget.mood!)
                    : const LoadAzkar(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final categories = [
      'All',
      'Morning',
      'Evening',
      'Gratitude',
      'Peace',
      'Stress Relief',
      'Protection',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });

                if (category == 'All') {
                  context.read<AzkarBloc>().add(
                    widget.mood != null
                        ? LoadAzkarByMood(widget.mood!)
                        : const LoadAzkar(),
                  );
                } else {
                  // Map display names to database keys
                  String categoryKey = category.toLowerCase();
                  switch (category) {
                    case 'Stress Relief':
                      categoryKey = 'stress_relief';
                      break;
                    case 'Morning':
                      categoryKey = 'morning';
                      break;
                    case 'Evening':
                      categoryKey = 'evening';
                      break;
                    case 'Gratitude':
                      categoryKey = 'gratitude';
                      break;
                    case 'Peace':
                      categoryKey = 'peace';
                      break;
                    case 'Protection':
                      categoryKey = 'protection';
                      break;
                  }
                  context.read<AzkarBloc>().add(
                    LoadAzkarByCategory(categoryKey),
                  );
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    );
  }
}
