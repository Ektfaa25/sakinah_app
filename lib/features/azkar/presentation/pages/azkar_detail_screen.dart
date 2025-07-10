import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../domain/entities/azkar_new.dart';

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
  bool _showPageIndicator = false;
  Timer? _hideIndicatorTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initAzkarData();
    _loadUserProgress();
    _pageController = PageController(initialPage: widget.azkarIndex);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                        ? PageView.builder(
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            itemCount: widget.azkarList!.length,
                            itemBuilder: (context, index) {
                              final azkar = widget.azkarList![index];
                              return _buildAzkarPage(azkar, categoryColor);
                            },
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            categoryColor.withValues(alpha: 0.15),
            categoryColor.withValues(alpha: 0.08),
            categoryColor.withValues(alpha: 0.03),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Row(
          children: [
            // Enhanced back button
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: categoryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: categoryColor,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(48, 48),
                ),
              ),
            ),
            // Enhanced centered title
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.category.nameAr,
                        style: GoogleFonts.playpenSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    // Enhanced page info
                    // Page number removed as requested
                  ],
                ),
              ),
            ),
            // Empty space to balance the back button
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(Azkar azkar, Color categoryColor) {
    final progress = _currentCount / azkar.repeatCount;

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 400),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Enhanced progress circle with modern design
            Container(
              padding: const EdgeInsets.all(12), // Reduced from 20 to 12
              decoration: BoxDecoration(
                color: _isCompleted
                    ? Colors.green.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _isCompleted
                        ? Colors.green.withValues(alpha: 0.2)
                        : Theme.of(
                            context,
                          ).colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 15, // Reduced from 20 to 15
                    spreadRadius: 3, // Reduced from 5 to 3
                    offset: const Offset(0, 4), // Reduced from 6 to 4
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70, // Reduced from 90 to 70
                    height: 70, // Reduced from 90 to 70
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 5, // Reduced from 6 to 5
                      backgroundColor: _isCompleted
                          ? Colors.green.withValues(alpha: 0.3)
                          : categoryColor.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isCompleted ? Colors.green : categoryColor,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  // Enhanced circular button
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isCompleted
                            ? null
                            : () => _incrementCounter(azkar),
                        borderRadius: BorderRadius.circular(
                          25,
                        ), // Reduced from 32 to 25
                        child: Container(
                          width: 50, // Reduced from 64 to 50
                          height: 50, // Reduced from 64 to 50
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isCompleted) ...[
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: _isCompleted
                                        ? Colors.green
                                        : categoryColor,
                                    size: 20, // Reduced from 24 to 20
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ), // Reduced from 2 to 1
                                  Text(
                                    'تم',
                                    style: GoogleFonts.playpenSans(
                                      color: _isCompleted
                                          ? Colors.green
                                          : categoryColor,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ] else ...[
                                  Text(
                                    '$_currentCount',
                                    style: GoogleFonts.playpenSans(
                                      color: categoryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: 16, // Reduced from 20 to 16
                                    height: 1,
                                    color: categoryColor.withValues(alpha: 0.6),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 1, // Reduced from 2 to 1
                                    ),
                                  ),
                                  Text(
                                    '${azkar.repeatCount}',
                                    style: GoogleFonts.playpenSans(
                                      color: categoryColor.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
            const SizedBox(height: 16),
            // Enhanced repetition text with container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: (_isCompleted ? Colors.green : categoryColor).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (_isCompleted ? Colors.green : categoryColor)
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                ' ${azkar.repeatCount} ${_getRepetitionWord(azkar.repeatCount)}',
                style: GoogleFonts.playpenSans(
                  color: _isCompleted ? Colors.green.shade700 : categoryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
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
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: categoryColor.withValues(
            alpha: 0.15,
          ), // Light category color background
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(
                alpha: 0.25,
              ), // Enhanced shadow with category color
              blurRadius: 25, // Increased blur radius
              spreadRadius: 4, // Increased spread
              offset: const Offset(0, 8), // Increased offset
            ),
            BoxShadow(
              color: categoryColor.withValues(
                alpha: 0.15,
              ), // Additional glow effect
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(
                alpha: 0.08,
              ), // Subtle depth shadow
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: categoryColor.withValues(
              alpha: 0.4,
            ), // More visible border with category color
            width: 2, // Thicker border
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Arabic text with enhanced styling
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(
                azkar.textAr,
                style: GoogleFonts.playpenSans(
                  fontSize:
                      22, // Increased from 20 to 22 for better readability
                  fontWeight: FontWeight.w700,
                  height: 2.4, // Increased line height for Arabic text
                  letterSpacing: 1.0, // Better spacing for Arabic characters
                  color: const Color(
                    0xFF2C1810,
                  ), // Darker brown color for better contrast against cream background
                  shadows: [
                    Shadow(
                      color: categoryColor.withValues(alpha: 0.15),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),

            // Transliteration section with improved styling
            if (azkar.transliteration != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(
                    alpha: 0.15,
                  ), // Enhanced with category color and higher opacity
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: categoryColor.withValues(
                      alpha: 0.35,
                    ), // Category color border with higher opacity
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: categoryColor.withValues(
                        alpha: 0.2,
                      ), // Enhanced shadow
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hearing,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'النطق',
                          style: GoogleFonts.playpenSans(
                            color: const Color(
                              0xFF2C1810,
                            ), // Dark brown for better contrast
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: 0.2,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      azkar.transliteration!,
                      style: GoogleFonts.playpenSans(
                        color: const Color(
                          0xFF2C1810,
                        ), // Dark brown for better contrast
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        height: 1.9, // Improved line height
                        letterSpacing:
                            0.4, // Better spacing for transliteration
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            // Translation section with improved styling
            if (azkar.translation != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(
                    alpha: 0.18,
                  ), // Enhanced with category color and higher opacity
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: categoryColor.withValues(
                      alpha: 0.4,
                    ), // Category color border with higher opacity
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: categoryColor.withValues(
                        alpha: 0.25,
                      ), // Enhanced shadow
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      azkar.translation!,
                      style: GoogleFonts.playpenSans(
                        color: const Color(
                          0xFF2C1810,
                        ), // Dark brown for better contrast
                        fontSize: 16,
                        height: 1.9, // Improved line height for readability
                        fontWeight: FontWeight.w500,
                        letterSpacing:
                            0.3, // Added letter spacing for better readability
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],

            // Reference section with improved styling
            if (azkar.reference != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.tertiaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.tertiary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        azkar.formattedReference,
                        style: GoogleFonts.playpenSans(
                          color: const Color(
                            0xFF2C1810,
                          ), // Dark brown for better contrast
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Action icons with enhanced styling
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
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
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                  _buildActionButton(
                    icon: Icons.copy_rounded,
                    label: 'نسخ',
                    onPressed: () => _copyToClipboard(_getCurrentAzkar()),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
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
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.playpenSans(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack, // Spring-like curve for smooth appearance
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surface.withOpacity(0.95), // Slightly more opaque
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page number removed as requested
          const SizedBox(height: 12),
          // Fixed dots page indicator with smooth transitions
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            key: const ValueKey('page_indicator'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.azkarList!.length > 10 ? 10 : widget.azkarList!.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  key: ValueKey('dot_$index'),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _currentAzkarIndex
                      ? 16
                      : 12, // Active dot slightly larger
                  height: index == _currentAzkarIndex ? 16 : 12,
                  decoration: BoxDecoration(
                    color: index == _currentAzkarIndex
                        ? categoryColor // Active dot - full color
                        : categoryColor.withOpacity(
                            0.3,
                          ), // Inactive dots - faded
                    shape: BoxShape.circle,
                    boxShadow: index == _currentAzkarIndex
                        ? [
                            BoxShadow(
                              color: categoryColor.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isCompleted
                ? Colors.green.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _isCompleted
                    ? Colors.green.withValues(alpha: 0.2)
                    : Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 15,
                spreadRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 5,
                  backgroundColor: _isCompleted
                      ? Colors.green.withValues(alpha: 0.3)
                      : categoryColor.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isCompleted ? Colors.green : categoryColor,
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Enhanced circular button
              ScaleTransition(
                scale: _pulseAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isCompleted ? null : () => _incrementCounter(azkar),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isCompleted) ...[
                              Icon(
                                Icons.check_circle_outline,
                                color: _isCompleted
                                    ? Colors.green
                                    : categoryColor,
                                size: 20,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'تم',
                                style: GoogleFonts.playpenSans(
                                  color: _isCompleted
                                      ? Colors.green
                                      : categoryColor,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ] else ...[
                              Text(
                                '$_currentCount',
                                style: GoogleFonts.playpenSans(
                                  color: categoryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                width: 16,
                                height: 1,
                                color: categoryColor.withValues(alpha: 0.6),
                                margin: const EdgeInsets.symmetric(vertical: 1),
                              ),
                              Text(
                                '${azkar.repeatCount}',
                                style: GoogleFonts.playpenSans(
                                  color: categoryColor.withValues(alpha: 0.9),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
            color: (_isCompleted ? Colors.green : categoryColor).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (_isCompleted ? Colors.green : categoryColor).withValues(
                alpha: 0.3,
              ),
              width: 1,
            ),
          ),
          child: Text(
            ' ${azkar.repeatCount} ${_getRepetitionWord(azkar.repeatCount)}',
            style: GoogleFonts.playpenSans(
              color: _isCompleted ? Colors.green.shade700 : categoryColor,
              fontWeight: FontWeight.w700,
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
