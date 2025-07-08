import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sakinah_app/core/theme/app_colors.dart';

/// Elevation levels for glassy containers
enum GlassyElevation {
  none(0),
  low(1),
  medium(2),
  high(3),
  elevated(4);

  const GlassyElevation(this.level);
  final int level;
}

class GlassyContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? backgroundColor;
  final double opacity;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final GlassyElevation elevation;
  final bool enableGlow;
  final Color? glowColor;

  const GlassyContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10.0,
    this.backgroundColor,
    this.opacity = 0.1,
    this.border,
    this.boxShadow,
    this.elevation = GlassyElevation.medium,
    this.enableGlow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBackgroundColor =
        backgroundColor ??
        (isDark ? AppColors.glassBackgroundDark : AppColors.glassBackground);

    final shadows = boxShadow ?? _getElevationShadows(theme, isDark);
    final borderColor = isDark
        ? AppColors.glassBorderDark
        : AppColors.glassBorder;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: border ?? Border.all(color: borderColor, width: 1),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: defaultBackgroundColor,
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              // Inner glow effect
              boxShadow: enableGlow
                  ? [
                      BoxShadow(
                        color: (glowColor ?? theme.colorScheme.primary)
                            .withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: -5,
                        offset: Offset.zero,
                      ),
                    ]
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _getElevationShadows(ThemeData theme, bool isDark) {
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.5)
        : AppColors.shadowMedium;

    switch (elevation) {
      case GlassyElevation.none:
        return [];

      case GlassyElevation.low:
        return [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
        ];

      case GlassyElevation.medium:
        return [
          BoxShadow(
            color: shadowColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
        ];

      case GlassyElevation.high:
        return [
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, -3),
            ),
        ];

      case GlassyElevation.elevated:
        return [
          BoxShadow(
            color: shadowColor.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            blurRadius: 60,
            offset: const Offset(0, 4),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
        ];
    }
  }
}

/// Specialized glassy containers for specific use cases
class GlassyCard extends GlassyContainer {
  const GlassyCard({
    super.key,
    required super.child,
    super.width,
    super.height,
    super.margin = const EdgeInsets.all(8),
    super.padding = const EdgeInsets.all(16),
    super.elevation = GlassyElevation.medium,
  });
}

class GlassyButton extends GlassyContainer {
  final VoidCallback? onTap;

  const GlassyButton({
    super.key,
    required super.child,
    required this.onTap,
    super.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    super.elevation = GlassyElevation.low,
    super.borderRadius = const BorderRadius.all(Radius.circular(25)),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: super.build(context));
  }
}

class GlassyFloatingCard extends GlassyContainer {
  const GlassyFloatingCard({
    super.key,
    required super.child,
    super.width,
    super.height,
    super.padding = const EdgeInsets.all(20),
    super.elevation = GlassyElevation.elevated,
    super.enableGlow = true,
  });
}
