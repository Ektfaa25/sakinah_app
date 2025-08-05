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
  late ScrollController _indicatorScrollController;
  bool _showPageIndicator = false;
  Timer? _hideIndicatorTimer;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initAzkarData();
    _loadUserProgress();
    _pageController = PageController(initialPage: widget.azkarIndex);
    _scrollController = ScrollController();
    _indicatorScrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    _indicatorScrollController.dispose();
    _hideIndicatorTimer?.cancel();
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

  void _onScroll() {
    // Only show indicator when user scrolls near the end of the content
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final threshold = maxScroll * 0.8; // Show when 80% scrolled

    if (!_showPageIndicator && currentScroll > threshold && maxScroll > 0) {
      setState(() {
        _showPageIndicator = true;
      });
    }

    // Reset the hide timer with smoother delay
    _hideIndicatorTimer?.cancel();
    _hideIndicatorTimer = Timer(const Duration(milliseconds: 2500), () {
      // Reduced from 3000 to 2500
      if (mounted) {
        setState(() {
          _showPageIndicator = false;
        });
      }
    });
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
      _showPageIndicator = true; // Show indicator when page changes
    });
    print(
      '📄 Updated state via swipe - count: $_currentCount, completed: $_isCompleted',
    );

    // Auto-scroll the page indicator only if there are more than 10 pages and controller is attached
    if (widget.azkarList != null &&
        widget.azkarList!.length > 10 &&
        _indicatorScrollController.hasClients) {
      _scrollToCurrentIndicator();
    }

    // Load favorite status for the new azkar
    _loadFavoriteStatus();

    // Hide indicator after 2.5 seconds with smooth transition
    _hideIndicatorTimer?.cancel();
    _hideIndicatorTimer = Timer(const Duration(milliseconds: 2500), () {
      // Reduced from 3000 to 2500
      if (mounted) {
        setState(() {
          _showPageIndicator = false;
        });
      }
    });
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
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        widget.azkarList != null && widget.azkarList!.length > 1
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
              // Fixed page indicator at bottom with scroll-based visibility
              if (widget.azkarList != null && widget.azkarList!.length > 1)
                AnimatedPositioned(
                  duration: const Duration(
                    milliseconds: 600,
                  ), // Increased from 300 to 600
                  curve: Curves.easeInOutCubic, // Changed to smoother curve
                  bottom: _showPageIndicator ? 20 : -100,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(
                      milliseconds: 600,
                    ), // Increased from 300 to 600
                    curve: Curves.easeInOutCubic, // Added smooth curve
                    opacity: _showPageIndicator ? 1.0 : 0.0,
                    child: _buildPageIndicator(categoryColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAzkarPage(Azkar azkar, Color categoryColor) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        24,
        24,
        24,
        80,
      ), // Add bottom padding to avoid overlap with fixed indicator
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stack to position counter circle overlapping with card
          Stack(
            clipBehavior: Clip.none,
            children: [
              _buildAzkarText(azkar),
              // Position counter circle at bottom center of card, half overlapping
              Positioned(
                bottom:
                    -50, // Half of counter circle height (94/2 = 47, rounded to 50)
                left: 0,
                right: 0,
                child: _buildCounterCircle(azkar, categoryColor),
              ),
            ],
          ),
          const SizedBox(
            height: 80,
          ), // Increased to accommodate overlapping circle
          _buildRepetitionText(azkar, categoryColor),
          const SizedBox(height: 24),
          // Page indicator removed - now fixed at bottom of screen
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color categoryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Row(
          children: [
            // Clean back button
            IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
              tooltip: 'رجوع',
            ),
            // Centered title
            Expanded(
              child: Text(
                widget.category.nameAr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
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
                color: _isFavorite ? Colors.red : Colors.grey[600],
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
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              categoryColor.withOpacity(0.25),
              categoryColor.withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: categoryColor.withOpacity(0.4), width: 3.0),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Arabic text
            Text(
              azkar.textAr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 2.2,
                color: Color(0xFF1A1A2E), // Dark color for better contrast
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),

            // Transliteration section
            if (azkar.transliteration != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hearing, size: 16, color: categoryColor),
                        const SizedBox(width: 8),
                        Text(
                          'النطق',
                          style: TextStyle(
                            color: const Color(0xFF1A1A2E),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      azkar.transliteration!,
                      style: const TextStyle(
                        color: Color(
                          0xFF4B5563,
                        ), // Darker gray for better readability
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        height: 1.8,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            // Translation section
            if (azkar.translation != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6B7280).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  azkar.translation!,
                  style: const TextStyle(
                    color: Color(
                      0xFF374151,
                    ), // Darker color for better contrast
                    fontSize: 16,
                    height: 1.8,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],

            // Reference section
            if (azkar.reference != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 14,
                      color: const Color(0xFF4B5563),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        azkar.formattedReference,
                        style: const TextStyle(
                          color: Color(
                            0xFF4B5563,
                          ), // Darker for better readability
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action buttons
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: categoryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.share_rounded,
                    label: 'مشاركة',
                    onPressed: _shareAzkar,
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: categoryColor.withOpacity(0.3),
                  ),
                  _buildActionButton(
                    icon: Icons.copy_rounded,
                    label: 'نسخ',
                    onPressed: () => _copyToClipboard(_getCurrentAzkar()),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: categoryColor.withOpacity(0.3),
                  ),
                  _buildActionButton(
                    icon: Icons.refresh_rounded,
                    label: 'إعادة',
                    onPressed: _resetCounter,
                  ),
                ],
              ),
            ),
          ],
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
            Icon(icon, color: const Color(0xFF1A1A2E), size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1A1A2E),
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

  Widget _buildPageIndicator(Color categoryColor) {
    if (widget.azkarList == null || widget.azkarList!.length <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.azkarList!.length > 10 ? 10 : widget.azkarList!.length,
          (index) {
            // Show current position relative to total
            final actualIndex = widget.azkarList!.length > 10
                ? (_currentAzkarIndex - 5 + index).clamp(
                    0,
                    widget.azkarList!.length - 1,
                  )
                : index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: actualIndex == _currentAzkarIndex ? 16 : 8,
              height: actualIndex == _currentAzkarIndex ? 16 : 8,
              decoration: BoxDecoration(
                color: actualIndex == _currentAzkarIndex
                    ? categoryColor
                    : categoryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }

  // New method to build just the counter circle for overlapping positioning
  Widget _buildCounterCircle(Azkar azkar, Color categoryColor) {
    final progress = _currentCount / azkar.repeatCount;

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
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
                    _isCompleted ? Colors.green : categoryColor,
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
                    onTap: _isCompleted ? null : () => _incrementCounter(azkar),
                    borderRadius: BorderRadius.circular(30),
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
                                      color: categoryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 1,
                                    color: categoryColor.withOpacity(0.6),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                  ),
                                  Text(
                                    '${azkar.repeatCount}',
                                    style: TextStyle(
                                      color: categoryColor.withOpacity(0.8),
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
      ),
    );
  }

  // New method to build just the repetition text
  Widget _buildRepetitionText(Azkar azkar, Color categoryColor) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 500),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: (_isCompleted ? Colors.green : categoryColor).withOpacity(
              0.1,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (_isCompleted ? Colors.green : categoryColor).withOpacity(
                0.3,
              ),
              width: 1,
            ),
          ),
          child: Text(
            'يُكرر ${azkar.repeatCount} ${_getRepetitionWord(azkar.repeatCount)}',
            style: TextStyle(
              color: _isCompleted ? Colors.green.shade700 : categoryColor,
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

  void _scrollToCurrentIndicator() {
    // Only scroll if we have more than 10 items and the controller is attached
    if (widget.azkarList == null ||
        widget.azkarList!.length <= 10 ||
        !_indicatorScrollController.hasClients) {
      return;
    }

    // Calculate the position to scroll to
    // Since we're using reversed index for RTL, we need to calculate based on the reversed position
    final reversedIndex = widget.azkarList!.length - 1 - _currentAzkarIndex;

    // Each dot is approximately 16px width + 8px margin = 24px total
    const double dotWidth = 24.0;
    final double scrollPosition = reversedIndex * dotWidth;

    // Get the viewport width to center the current dot
    final double viewportWidth = MediaQuery.of(context).size.width;
    final double centeredPosition =
        scrollPosition - (viewportWidth / 2) + (dotWidth / 2);

    // Ensure we don't scroll beyond the limits
    final double maxScroll =
        (_indicatorScrollController.position.maxScrollExtent);
    final double targetPosition = centeredPosition.clamp(0.0, maxScroll);

    // Animate to the target position
    _indicatorScrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
