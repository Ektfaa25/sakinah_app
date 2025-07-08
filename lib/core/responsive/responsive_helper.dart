import 'package:flutter/material.dart';

/// Responsive design helper for building layouts that adapt to different screen sizes
class ResponsiveHelper {
  /// Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Get screen type based on width
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getScreenType(context) == ScreenType.mobile;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getScreenType(context) == ScreenType.tablet;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenType(context) == ScreenType.desktop;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.all(16);
      case ScreenType.tablet:
        return const EdgeInsets.all(24);
      case ScreenType.desktop:
        return const EdgeInsets.all(32);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.all(8);
      case ScreenType.tablet:
        return const EdgeInsets.all(16);
      case ScreenType.desktop:
        return const EdgeInsets.all(24);
    }
  }

  /// Get responsive spacing based on screen size
  static double getResponsiveSpacing(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return 16;
      case ScreenType.tablet:
        return 20;
      case ScreenType.desktop:
        return 24;
    }
  }

  /// Get responsive grid column count
  static int getGridColumns(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return 2;
      case ScreenType.tablet:
        return 3;
      case ScreenType.desktop:
        return 4;
    }
  }

  /// Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return 1.0;
      case ScreenType.tablet:
        return 1.1;
      case ScreenType.desktop:
        return 1.2;
    }
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    final multiplier = getFontSizeMultiplier(context);
    return baseSize * multiplier;
  }

  /// Get responsive container constraints
  static BoxConstraints getContainerConstraints(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return const BoxConstraints(maxWidth: 600);
      case ScreenType.tablet:
        return const BoxConstraints(maxWidth: 800);
      case ScreenType.desktop:
        return const BoxConstraints(maxWidth: 1200);
    }
  }

  /// Get responsive card elevation
  static double getCardElevation(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return 2;
      case ScreenType.tablet:
        return 4;
      case ScreenType.desktop:
        return 6;
    }
  }

  /// Get responsive border radius
  static BorderRadius getBorderRadius(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return BorderRadius.circular(12);
      case ScreenType.tablet:
        return BorderRadius.circular(16);
      case ScreenType.desktop:
        return BorderRadius.circular(20);
    }
  }
}

/// Screen type enumeration
enum ScreenType { mobile, tablet, desktop }

/// Responsive widget builder
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final screenType = ResponsiveHelper.getScreenType(context);
    return builder(context, screenType);
  }
}

/// Responsive widget that shows different widgets based on screen size
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        switch (screenType) {
          case ScreenType.mobile:
            return mobile;
          case ScreenType.tablet:
            return tablet ?? mobile;
          case ScreenType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}

/// Responsive layout that adapts content based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final bool centerContent;
  final bool addHorizontalPadding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.centerContent = true,
    this.addHorizontalPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        Widget content = child;

        // Add responsive padding
        if (addHorizontalPadding) {
          content = Padding(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: content,
          );
        }

        // Center content for larger screens
        if (centerContent && screenType != ScreenType.mobile) {
          content = Center(
            child: ConstrainedBox(
              constraints: ResponsiveHelper.getContainerConstraints(context),
              child: content,
            ),
          );
        }

        return content;
      },
    );
  }
}

/// Extension for responsive values
extension ResponsiveValues on BuildContext {
  /// Get responsive padding
  EdgeInsets get responsivePadding =>
      ResponsiveHelper.getResponsivePadding(this);

  /// Get responsive margin
  EdgeInsets get responsiveMargin => ResponsiveHelper.getResponsiveMargin(this);

  /// Get responsive spacing
  double get responsiveSpacing => ResponsiveHelper.getResponsiveSpacing(this);

  /// Get responsive grid columns
  int get gridColumns => ResponsiveHelper.getGridColumns(this);

  /// Get responsive font size multiplier
  double get fontSizeMultiplier => ResponsiveHelper.getFontSizeMultiplier(this);

  /// Get responsive icon size
  double responsiveIconSize([double baseSize = 24]) =>
      ResponsiveHelper.getIconSize(this, baseSize: baseSize);

  /// Get responsive container constraints
  BoxConstraints get containerConstraints =>
      ResponsiveHelper.getContainerConstraints(this);

  /// Get responsive card elevation
  double get cardElevation => ResponsiveHelper.getCardElevation(this);

  /// Get responsive border radius
  BorderRadius get borderRadius => ResponsiveHelper.getBorderRadius(this);

  /// Check if mobile
  bool get isMobile => ResponsiveHelper.isMobile(this);

  /// Check if tablet
  bool get isTablet => ResponsiveHelper.isTablet(this);

  /// Check if desktop
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
}
