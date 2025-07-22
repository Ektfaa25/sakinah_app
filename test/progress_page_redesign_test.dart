import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakinah_app/features/progress/presentation/pages/progress_page.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';

void main() {
  group('Progress Page Redesign Tests', () {
    testWidgets('should display modern header with app title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ProgressBloc>(
              create: (context) => FakeProgressBloc(),
              child: const ProgressPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for modern header elements
      expect(find.text('My Progress'), findsOneWidget);
      expect(find.text('Track your spiritual journey'), findsOneWidget);
      expect(find.byIcon(Icons.insights), findsOneWidget);
    });

    testWidgets('should display elegant tab bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ProgressBloc>(
              create: (context) => FakeProgressBloc(),
              child: const ProgressPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for tab bar
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
    });

    testWidgets('should display progress hero card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ProgressBloc>(
              create: (context) => FakeProgressBloc(),
              child: const ProgressPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for progress elements
      expect(find.text('Today\'s Progress'), findsOneWidget);
      expect(find.textContaining('Complete'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display elegant stats row', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ProgressBloc>(
              create: (context) => FakeProgressBloc(),
              child: const ProgressPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for stats
      expect(find.text('Streak'), findsOneWidget);
      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('Best Day'), findsOneWidget);
    });

    testWidgets('should display quick actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ProgressBloc>(
              create: (context) => FakeProgressBloc(),
              child: const ProgressPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for quick actions
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Start Azkar'), findsOneWidget);
      expect(find.text('Set Goal'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets('should have modern design elements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<ProgressBloc>(
              create: (context) => FakeProgressBloc(),
              child: const ProgressPage(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for modern design elements
      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
      expect(find.byIcon(Icons.calendar_view_week_rounded), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_filled_rounded), findsOneWidget);
    });
  });
}

// Fake bloc for testing
class FakeProgressBloc extends Fake implements ProgressBloc {
  @override
  Stream<ProgressState> get stream => Stream.value(
    TodayProgressLoaded(
      progress: UserProgress(
        date: DateTime.now(),
        azkarCompleted: 3,
        streakCount: 5,
        completedAzkarIds: [1, 2, 3],
        reflection: "Today I felt more connected to Allah through dhikr.",
        moodBefore: "Anxious",
        moodAfter: "Peaceful",
      ),
      currentStreak: 5,
    ),
  );

  @override
  ProgressState get state => TodayProgressLoaded(
    progress: UserProgress(
      date: DateTime.now(),
      azkarCompleted: 3,
      streakCount: 5,
      completedAzkarIds: [1, 2, 3],
      reflection: "Today I felt more connected to Allah through dhikr.",
      moodBefore: "Anxious",
      moodAfter: "Peaceful",
    ),
    currentStreak: 5,
  );

  @override
  void add(ProgressEvent event) {}

  @override
  Future<void> close() async {}
}
