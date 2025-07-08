import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for the app
class AppPageTransitions {
  /// Slide transition from right
  static CustomTransitionPage slideFromRight<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Slide transition from left
  static CustomTransitionPage slideFromLeft<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Slide transition from bottom
  static CustomTransitionPage slideFromBottom<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Fade transition
  static CustomTransitionPage fadeTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  /// Scale transition
  static CustomTransitionPage scaleTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var tween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Smooth transition with glassy effect
  static CustomTransitionPage glassyTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        // Scale animation
        var scaleTween = Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        // Slide animation
        var slideTween = Tween(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

/// Helper extension for easy transition usage
extension TransitionHelper on Widget {
  /// Wrap widget with slide from right transition
  CustomTransitionPage slideFromRight<T extends Object?>(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppPageTransitions.slideFromRight<T>(context, state, this);
  }

  /// Wrap widget with slide from left transition
  CustomTransitionPage slideFromLeft<T extends Object?>(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppPageTransitions.slideFromLeft<T>(context, state, this);
  }

  /// Wrap widget with slide from bottom transition
  CustomTransitionPage slideFromBottom<T extends Object?>(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppPageTransitions.slideFromBottom<T>(context, state, this);
  }

  /// Wrap widget with fade transition
  CustomTransitionPage fadeTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppPageTransitions.fadeTransition<T>(context, state, this);
  }

  /// Wrap widget with scale transition
  CustomTransitionPage scaleTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppPageTransitions.scaleTransition<T>(context, state, this);
  }

  /// Wrap widget with glassy transition
  CustomTransitionPage glassyTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
  ) {
    return AppPageTransitions.glassyTransition<T>(context, state, this);
  }
}
