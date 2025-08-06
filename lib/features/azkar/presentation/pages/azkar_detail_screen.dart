import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../domain/entities/azkar_new.dart';
import '../../data/services/azkar_database_adapter.dart';
import '../../../../core/router/app_routes.dart';

class AzkarDetailScreen extends StatefulWidget {
  final Azkar azkar;
  final AzkarCategory category;
  final int azkarIndex;
  final int totalAzkar;
  final List<Azkar>? azkarList;

  const AzkarDetailScreen({
    Key? key,
    required this.azkar,
    required this.category,
    required this.azkarIndex,
    required this.totalAzkar,
    this.azkarList,
  }) : super(key: key);

  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen>
    with TickerProviderStateMixin {
  int _currentCount = 0;
  bool _isCompleted = false;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  int _currentAzkarIndex = 0;
  Map<int, int> _azkarCounts = {};
  Map<int, bool> _azkarCompleted = {};
  late PageController _pageController;
  late ScrollController _scrollController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initAzkarData();
    _loadUserProgress();
    _pageController = PageController(initialPage: widget.azkarIndex);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initAzkarData() {
    _currentAzkarIndex = widget.azkarIndex;

    print('🔧 Initializing with azkar index: $_currentAzkarIndex');

    // Initialize counts for all azkar
    if (widget.azkarList != null) {
      print('🔧 Initializing counts for ${widget.azkarList!.length} azkar');
      for (int i = 0; i < widget.azkarList!.length; i++) {
        _azkarCounts[i] = 0;
        _azkarCompleted[i] = false;
      }
    } else {
      print('🔧 No azkar list provided');
      _azkarCounts[0] = 0;
      _azkarCompleted[0] = false;
    }

    // Set current state
    _currentCount = _azkarCounts[_currentAzkarIndex] ?? 0;
    _isCompleted = _azkarCompleted[_currentAzkarIndex] ?? false;

    // Load favorite status
    _loadFavoriteStatus();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Future<void> _loadUserProgress() async {
    try {
      // TODO: Implement progress tracking with existing database
      // For now, just set defaults
      if (mounted) {
        setState(() {
          _currentCount = _azkarCounts[_currentAzkarIndex] ?? 0;
          _isCompleted = _azkarCompleted[_currentAzkarIndex] ?? false;
        });
      }

      /*
      final progress = await AzkarSupabaseService.getUserAzkarProgress(
        azkarId: _getCurrentAzkar().id,
      );
      
      if (mounted && progress != null) {
        setState(() {
          _currentCount = progress.completedCount;
          _isCompleted = progress.isCompleted;
        });
      }
      */
    } catch (e) {
      // Handle error silently for now
      debugPrint('Error loading user progress: $e');
    }
  }

  Azkar _getCurrentAzkar() {
    if (widget.azkarList != null && widget.azkarList!.isNotEmpty) {
      return widget.azkarList![_currentAzkarIndex];
    }
    return widget.azkar;
  }

  void _onPageChanged(int index) {
    print('📄 Page changed to index: $index');
    setState(() {
      _currentAzkarIndex = index;
      _currentCount = _azkarCounts[index] ?? 0;
      _isCompleted = _azkarCompleted[index] ?? false;
    });
    print(
      '📄 Updated state via swipe - count: $_currentCount, completed: $_isCompleted',
    );

    // Load favorite status for the new azkar
    _loadFavoriteStatus();
  }

  // Helper function to get correct word form based on count
  String _getRepetitionWord(int count) {
    if (count == 1) {
      return 'مرة';
    } else if (count == 2) {
      return 'مرتين';
    } else {
      return 'مرات';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _parseColor(widget.category.getColor());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.background.withOpacity(
                0.26,
              ), // Lighter version at top-left
              Theme.of(context).colorScheme.background, // Base background color
              Theme.of(context).colorScheme.background.withOpacity(
                0.9,
              ), // Darker version at bottom-right
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                // Main content
                Column(
                  children: [
                    _buildHeader(context, categoryColor),
                    Expanded(
                      child:
                          widget.azkarList != null &&
                              widget.azkarList!.length > 1
                          ? Directionality(
                              textDirection: TextDirection.rtl,
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: _onPageChanged,
                                itemCount: widget.azkarList!.length,
                                itemBuilder: (context, index) {
                                  final azkar = widget.azkarList![index];
                                  return _buildAzkarPage(azkar, categoryColor);
                                },
                              ),
                            )
                          : _buildAzkarPage(_getCurrentAzkar(), categoryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAzkarPage(Azkar azkar, Color categoryColor) {
    return GestureDetector(
      onTap: _isCompleted ? null : () => _incrementCounter(azkar),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          0,
          24,
          0,
          80,
        ), // Remove horizontal padding, keep vertical padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Azkar text at the top
            _buildAzkarText(azkar),
            const SizedBox(height: 100), // Space between text and counter
            // Counter circle positioned lower for thumb access
            _buildCounterCircle(azkar, categoryColor),
            const SizedBox(
              height: 40,
            ), // Space between counter and repetition text
            _buildRepetitionText(azkar, categoryColor),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color categoryColor) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(color: categoryColor.withOpacity(0.3), width: 4.0),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Row(
          children: [
            // Clean back button
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkTheme ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
              tooltip: 'رجوع',
            ),
            // Centered title
            Expanded(
              child: Text(
                widget.category.nameAr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
            ),
            // Favorite heart icon
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite
                    ? const Color.fromARGB(255, 244, 54, 108)
                    : isDarkTheme
                    ? Colors.grey[200]
                    : Colors.grey[600],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAzkarText(Azkar azkar) {
    final categoryColor = _parseColor(widget.category.getColor());

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          azkar.textAr,
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
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }

  // New method to build just the counter circle for overlapping positioning
  Widget _buildCounterCircle(Azkar azkar, Color categoryColor) {
    final progress = _currentCount / azkar.repeatCount;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isDarkTheme
                ? Theme.of(context).cardColor
                : const Color(0xFFFAF9F7), // Cream off-white color
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.08), // Reduced from 0.2
                blurRadius: 8, // Reduced from 15
                offset: const Offset(0, 2), // Reduced from 4
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
                  backgroundColor: isDarkTheme
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : categoryColor.withOpacity(
                          0.15,
                        ), // Light category color for light theme
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isCompleted
                        ? Colors.green
                        : isDarkTheme
                        ? Theme.of(context).colorScheme.primary
                        : categoryColor, // Use category color for progress in light theme
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Counter button
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: _isCompleted
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
                                '$_currentCount',
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black.withOpacity(0.8),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 1.5,
                                color: isDarkTheme
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.black.withOpacity(0.5),
                                margin: const EdgeInsets.symmetric(vertical: 2),
                              ),
                              Text(
                                '${azkar.repeatCount}',
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.6),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New method to build just the repetition text
  Widget _buildRepetitionText(Azkar azkar, Color categoryColor) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Create a lighter version of the category color for better readability
    final textColor = _isCompleted
        ? Colors.green.shade700
        : isDarkTheme
        ? categoryColor.withOpacity(0.9) // Lighter for dark theme
        : categoryColor; // Original color for light theme

    final backgroundColor = (_isCompleted ? Colors.green : categoryColor)
        .withOpacity(
          isDarkTheme ? 0.15 : 0.1, // Slightly more opacity for dark theme
        );

    final borderColor = (_isCompleted ? Colors.green : categoryColor)
        .withOpacity(
          isDarkTheme ? 0.4 : 0.3, // More visible border for dark theme
        );

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 500),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Text(
            'يُكرر ${azkar.repeatCount} ${_getRepetitionWord(azkar.repeatCount)}',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }

  void _incrementCounter(Azkar azkar) async {
    final currentCount = _azkarCounts[_currentAzkarIndex] ?? 0;
    final isCompleted = _azkarCompleted[_currentAzkarIndex] ?? false;

    if (currentCount < azkar.repeatCount && !isCompleted) {
      setState(() {
        _azkarCounts[_currentAzkarIndex] = currentCount + 1;
        _azkarCompleted[_currentAzkarIndex] =
            _azkarCounts[_currentAzkarIndex]! >= azkar.repeatCount;
        _currentCount = _azkarCounts[_currentAzkarIndex]!;
        _isCompleted = _azkarCompleted[_currentAzkarIndex]!;
      });

      // Haptic feedback
      HapticFeedback.lightImpact();

      // Pulse animation
      _pulseController.forward().then((_) {
        _pulseController.reverse();
      });

      // Update progress in database
      try {
        // TODO: Implement progress tracking with existing database
        /*
        await AzkarSupabaseService.updateUserAzkarProgress(
          azkarId: azkar.id,
          completedCount: _currentCount,
          totalCount: azkar.repeatCount,
        );
        */
      } catch (e) {
        debugPrint('Error updating progress: $e');
      }

      // Show completion message
      if (_isCompleted) {
        HapticFeedback.heavyImpact();
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

  void _resetCounter() async {
    setState(() {
      _azkarCounts[_currentAzkarIndex] = 0;
      _azkarCompleted[_currentAzkarIndex] = false;
      _currentCount = 0;
      _isCompleted = false;
    });

    // Reset progress in database
    try {
      // TODO: Implement progress tracking with existing database
      /*
      await AzkarSupabaseService.resetUserAzkarProgress(
        azkarId: _getCurrentAzkar().id,
      );
      */
    } catch (e) {
      debugPrint('Error resetting progress: $e');
    }

    HapticFeedback.mediumImpact();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      // Load favorite status from database
      final isFavorite = await AzkarDatabaseAdapter.isAzkarFavorite(
        azkarId: _getCurrentAzkar().id,
      );

      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
        });
      }
    } catch (e) {
      debugPrint('Error loading favorite status: $e');
      // Default to false on error
      if (mounted) {
        setState(() {
          _isFavorite = false;
        });
      }
    }
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Add or remove from favorites in database
      if (_isFavorite) {
        await AzkarDatabaseAdapter.addToFavorites(
          azkarId: _getCurrentAzkar().id,
        );
      } else {
        await AzkarDatabaseAdapter.removeFromFavorites(
          azkarId: _getCurrentAzkar().id,
        );
      }

      // Show feedback message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? 'تم إضافة الذكر للمفضلة' : 'تم حذف الذكر من المفضلة',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: _isFavorite ? Colors.green : Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to favorites screen when adding to favorites
      if (_isFavorite) {
        // Small delay to show the snackbar message first
        await Future.delayed(const Duration(milliseconds: 800));

        if (mounted) {
          // Navigate to favorites screen using GoRouter
          context.go(AppRoutes.azkarFavorites);
        }
      }
    } catch (e) {
      // Revert state on error
      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'حدث خطأ، يرجى المحاولة مرة أخرى',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      debugPrint('Error toggling favorite: $e');
    }
  }

  void _copyToClipboard(Azkar azkar) {
    String textToCopy = azkar.textAr;
    if (azkar.transliteration != null) {
      textToCopy += '\n\n${azkar.transliteration!}';
    }
    if (azkar.translation != null) {
      textToCopy += '\n\n${azkar.translation!}';
    }
    if (azkar.reference != null) {
      textToCopy += '\n\n${azkar.formattedReference}';
    }

    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ النص', textDirection: TextDirection.rtl),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareAzkar() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'سيتم إضافة خاصية المشاركة قريباً',
          textDirection: TextDirection.rtl,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(
          int.parse(colorString.substring(1), radix: 16) + 0xFF000000,
        );
      }
      return Theme.of(context).colorScheme.primary;
    } catch (e) {
      return Theme.of(context).colorScheme.primary;
    }
  }
}
