import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Start the animation
    _animationController.forward();

    // Wait for 3 seconds total, then navigate
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getColorFromHex('#FBF8CC'), // Light yellow (same as bottom nav)
              _getColorFromHex('#A3C4F3'), // Light blue (same as bottom nav)
              Colors.white, // Fade to white for elegance
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Abstract background shapes
            Positioned(
              top: 100,
              right: 50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.02),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              right: 20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.04),
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 300,
              left: 40,
              child: Container(
                width: 150,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: 80,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.03),
                    width: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 450,
              left: 20,
              child: Transform.rotate(
                angle: 0.785398, // 45 degrees
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: 100,
              child: Container(
                width: 3,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5),
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),

            // Abstract lines across the screen
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Transform.rotate(
                angle: 0.1, // Slight diagonal
                child: Container(
                  width: double.infinity,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.03),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 350,
              left: 0,
              right: 0,
              child: Transform.rotate(
                angle: -0.08, // Opposite diagonal
                child: Container(
                  width: double.infinity,
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.04),
                        Colors.white.withOpacity(0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 250,
              left: 0,
              right: 0,
              child: Transform.rotate(
                angle: 0.12, // Another diagonal
                child: Container(
                  width: double.infinity,
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.06),
                        Colors.white.withOpacity(0.04),
                        Colors.white.withOpacity(0.02),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 500,
              left: 0,
              right: 0,
              child: Transform.rotate(
                angle: -0.05, // Gentle slope
                child: Container(
                  width: double.infinity,
                  height: 2.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.03),
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.03),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 400,
              left: 0,
              right: 0,
              child: Transform.rotate(
                angle: 0.15, // Steeper diagonal
                child: Container(
                  width: double.infinity,
                  height: 1.2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.04),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 80), // Move content down
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main logo with animations
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Column(
                                children: [
                                  // App name in Arabic
                                  Text(
                                    'سكينة',
                                    style: const TextStyle(
                                      fontFamily: 'PlaypenSansArabic',
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                      color: Color(
                                        0xFF1B2951,
                                      ), // Navy dark color
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const SizedBox(height: 8),
                                  // Subtitle
                                  Text(
                                    'لحظات من السكون، في عالم لا يهدأ',
                                    style: TextStyle(
                                      fontFamily: 'PlaypenSansArabic',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF1B2951)
                                          .withOpacity(
                                            0.8,
                                          ), // Navy dark color with opacity
                                      letterSpacing: 1.2,
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 60),

                      // Loading indicator with fade in animation
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.6,
                                      1.0,
                                      curve: Curves.easeIn,
                                    ),
                                  ),
                                ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Loading text
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: const Interval(
                                      0.7,
                                      1.0,
                                      curve: Curves.easeIn,
                                    ),
                                  ),
                                ),
                            child: Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                fontFamily: 'PlaypenSansArabic',
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to convert hex color string to Color object
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add alpha channel
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
