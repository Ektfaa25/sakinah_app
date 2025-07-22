import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import '../../domain/entities/azkar_new.dart';
import '../../data/services/azkar_database_adapter.dart';
import 'azkar_detail_screen.dart';

class AzkarCategoryScreen extends StatefulWidget {
  final AzkarCategory category;

  const AzkarCategoryScreen({Key? key, required this.category})
    : super(key: key);

  @override
  State<AzkarCategoryScreen> createState() => _AzkarCategoryScreenState();
}

class _AzkarCategoryScreenState extends State<AzkarCategoryScreen>
    with TickerProviderStateMixin {
  List<Azkar> _azkarList = [];
  bool _isLoading = true;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _pageController = PageController();
    _loadAzkar();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  Future<void> _loadAzkar() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final azkarList = await AzkarDatabaseAdapter.getAzkarByCategory(
        widget.category.id,
      );

      if (mounted) {
        setState(() {
          _azkarList = azkarList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
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
          child: Column(
            children: [
              _buildHeader(context, categoryColor),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color categoryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            categoryColor.withOpacity(0.1),
            categoryColor.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: categoryColor),
                  style: IconButton.styleFrom(
                    backgroundColor: categoryColor.withOpacity(0.1),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getIconData(widget.category.getIconName()),
                    size: 32,
                    color: categoryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category.nameAr,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(
                                0xFF1A1A2E,
                              ), // Navy blue dark almost black
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                      if (widget.category.nameEn != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.category.nameEn!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(
                                  0xFF1A1A2E,
                                ), // Navy blue dark almost black
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.category.description != null) ...[
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.category.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(
                      0xFF1A1A2E,
                    ), // Navy blue dark almost black
                    height: 1.5,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Removed azkar count display as requested
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_azkarList.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(onRefresh: _loadAzkar, child: _buildAzkarList());
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل الأذكار...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final categoryColor = _parseColor(widget.category.getColor());

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'حدث خطأ في تحميل الأذكار',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E), // Navy blue dark almost black
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF1A1A2E), // Navy blue dark almost black
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 400),
              child: ElevatedButton.icon(
                onPressed: _loadAzkar,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: categoryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final categoryColor = _parseColor(widget.category.getColor());

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.book_outlined,
                  size: 64,
                  color: categoryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'لا توجد أذكار في هذه الفئة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E), // Navy blue dark almost black
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Text(
                'جاري إضافة المزيد من الأذكار قريباً',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF1A1A2E), // Navy blue dark almost black
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

  Widget _buildAzkarList() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _azkarList.length,
      itemBuilder: (context, index) {
        final azkar = _azkarList[index];
        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: _buildAzkarPage(azkar, index),
        );
      },
    );
  }

  Widget _buildAzkarPage(Azkar azkar, int index) {
    final categoryColor = _parseColor(widget.category.getColor());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main azkar content
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.2),
                    width: 2,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      categoryColor.withOpacity(0.05),
                      categoryColor.withOpacity(0.02),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic text
                    Text(
                      azkar.textAr,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontSize: 24,
                            height: 2.0,
                            fontWeight: FontWeight.w600,
                            color: const Color(
                              0xFF1A1A2E,
                            ), // Navy blue dark almost black
                          ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),

                    if (azkar.translation != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          azkar.translation!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                height: 1.6,
                                fontStyle: FontStyle.italic,
                                color: const Color(
                                  0xFF1A1A2E,
                                ), // Navy blue dark almost black
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],

                    if (azkar.reference != null) ...[
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.source, size: 18, color: categoryColor),
                          const SizedBox(width: 8),
                          Text(
                            azkar.formattedReference,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: const Color(
                                    0xFF1A1A2E,
                                  ), // Navy blue dark almost black
                                  fontWeight: FontWeight.w500,
                                ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ],

                    // Removed repetition counter as requested
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          // Bottom action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.copy,
                label: 'نسخ',
                onTap: () => _copyAzkar(azkar),
                color: categoryColor,
              ),
              _buildActionButton(
                icon: Icons.share,
                label: 'مشاركة',
                onTap: () => _shareAzkar(azkar),
                color: categoryColor,
              ),
              _buildActionButton(
                icon: Icons.open_in_full,
                label: 'تفاصيل',
                onTap: () => _onAzkarTap(azkar, index),
                color: categoryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF1A1A2E), // Navy blue dark almost black
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAzkarTap(Azkar azkar, int index) {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    print('🔍 Navigating to AzkarDetailScreen with:');
    print('  - Azkar: ${azkar.textAr.substring(0, 50)}...');
    print('  - Category: ${widget.category.nameAr}');
    print('  - Index: $index');
    print('  - Total: ${_azkarList.length}');

    // Check if widget is still mounted before navigation
    if (!mounted) {
      print('⚠️ Widget is not mounted, canceling navigation');
      return;
    }

    // Navigate to detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AzkarDetailScreen(
          azkar: azkar,
          category: widget.category,
          azkarIndex: index,
          totalAzkar: _azkarList.length,
          azkarList: _azkarList, // Make sure to pass the full list
        ),
      ),
    );
  }

  void _shareAzkar(Azkar azkar) {
    // Check if widget is still mounted before showing snackbar
    if (!mounted) return;

    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم إضافة خاصية المشاركة قريباً'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyAzkar(Azkar azkar) {
    String textToCopy = azkar.textAr;
    if (azkar.translation != null) {
      textToCopy += '\n\n${azkar.translation!}';
    }
    if (azkar.reference != null) {
      textToCopy += '\n\n${azkar.formattedReference}';
    }

    Clipboard.setData(ClipboardData(text: textToCopy));

    // Check if widget is still mounted before showing snackbar
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ النص'),
        duration: Duration(seconds: 2),
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

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'nights_stay':
        return Icons.nights_stay;
      case 'bedtime':
        return Icons.bedtime;
      case 'mosque':
        return Icons.mosque;
      case 'flight':
        return Icons.flight;
      case 'restaurant':
        return Icons.restaurant;
      case 'favorite':
        return Icons.auto_awesome; // Changed from heart to star icon
      case 'spa':
        return Icons.spa;
      case 'shield':
        return Icons.shield;
      case 'menu_book':
      default:
        return Icons.menu_book;
    }
  }
}
