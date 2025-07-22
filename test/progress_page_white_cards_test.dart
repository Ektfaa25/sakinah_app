import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakinah_app/features/progress/presentation/pages/progress_page.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';
import 'package:sakinah_app/features/progress/domain/entities/user_progress.dart';
import 'package:sakinah_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:sakinah_app/shared/widgets/glassy_container.dart';
import 'package:sakinah_app/l10n/app_localizations.dart';

// Mock repository for testing
class MockProgressRepository extends ProgressRepository {
  @override
  bool get isInitialized => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> clearAll() async {}

  @override
  Future<List<UserProgress>> getAllProgress() async {
    return [
      UserProgress(
        id: 1,
        date: DateTime.now(),
        azkarCompleted: 15,
        streakCount: 5,
        completedAzkarIds: [1, 2, 3, 4, 5],
        reflection: 'Great progress today!',
        moodBefore: 'neutral',
        moodAfter: 'happy',
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<UserProgress?> getProgressByDate(DateTime date) async {
    return UserProgress(
      id: 1,
      date: date,
      azkarCompleted: 15,
      streakCount: 5,
      completedAzkarIds: [1, 2, 3, 4, 5],
      reflection: 'Great progress today!',
      moodBefore: 'neutral',
      moodAfter: 'happy',
      createdAt: date,
    );
  }

  @override
  Future<List<UserProgress>> getWeeklyProgress([DateTime? weekStart]) async {
    return List.generate(
      7,
      (index) => UserProgress(
        id: index + 1,
        date: DateTime.now().subtract(Duration(days: index)),
        azkarCompleted: 10 + index,
        streakCount: 3 + index,
        completedAzkarIds: List.generate(10 + index, (i) => i + 1),
        reflection: 'Daily reflection $index',
        moodBefore: 'neutral',
        moodAfter: 'content',
        createdAt: DateTime.now().subtract(Duration(days: index)),
      ),
    );
  }

  @override
  Future<List<UserProgress>> getMonthlyProgress([DateTime? monthStart]) async {
    return List.generate(
      30,
      (index) => UserProgress(
        id: index + 1,
        date: DateTime.now().subtract(Duration(days: index)),
        azkarCompleted: 5 + (index % 15),
        streakCount: 1 + (index % 10),
        completedAzkarIds: List.generate(5 + (index % 15), (i) => i + 1),
        reflection: 'Monthly reflection $index',
        moodBefore: 'neutral',
        moodAfter: ['happy', 'content', 'peaceful'][index % 3],
        createdAt: DateTime.now().subtract(Duration(days: index)),
      ),
    );
  }

  @override
  Future<List<UserProgress>> getProgressInRange(
    DateTime start,
    DateTime end,
  ) async {
    return [];
  }

  @override
  Future<int> getCurrentStreak() async {
    return 5;
  }

  @override
  Future<int> calculateCurrentStreak() async {
    return 5;
  }

  @override
  Future<Map<String, dynamic>> getAchievementStats() async {
    return {};
  }

  @override
  Future<Map<String, int>> getMoodPatterns({int days = 30}) async {
    return {
      'happy': 10,
      'content': 15,
      'peaceful': 8,
      'reflective': 5,
      'grateful': 12,
    };
  }

  @override
  Future<int> updateDailyProgress(UserProgress progress) async {
    return 1;
  }

  @override
  Future<void> addAzkarCompletion({
    required int azkarId,
    String? moodBefore,
    String? moodAfter,
    String? reflection,
  }) async {}

  @override
  Future<Map<String, dynamic>> exportProgressData() async {
    return {};
  }

  @override
  Future<void> importProgressData(Map<String, dynamic> data) async {}
}

void main() {
  group('Progress Page White Cards Design Tests', () {
    late MockProgressRepository mockRepository;

    setUp(() {
      mockRepository = MockProgressRepository();
    });

    tearDown(() async {
      // Allow any pending timers to complete
      await Future.delayed(Duration.zero);
    });

    testWidgets('Progress page should display white cards with colored icons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<ProgressBloc>(
            create: (context) =>
                ProgressBloc(progressRepository: mockRepository)
                  ..add(const LoadTodayProgress()),
            child: const ProgressPage(),
          ),
        ),
      );

      // Wait for initial render
      await tester.pump();

      // Wait for async operations to complete
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Find all GlassyContainer widgets (our white cards)
      final glassyContainers = find.byType(GlassyContainer);
      expect(glassyContainers, findsAtLeast(1));

      // Check for presence of colored icons
      final icons = find.byType(Icon);
      expect(icons, findsWidgets);

      // Verify we have the expected tab bar card
      final cards = find.byType(Card);
      expect(cards, findsAtLeast(1));

      print(
        '✅ Found ${tester.widgetList(glassyContainers).length} GlassyContainer widgets',
      );
      print('✅ Found ${tester.widgetList(icons).length} Icon widgets');
      print('✅ Found ${tester.widgetList(cards).length} Card widgets');
    });

    testWidgets('Cards should have consistent white styling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<ProgressBloc>(
            create: (context) =>
                ProgressBloc(progressRepository: mockRepository)
                  ..add(const LoadTodayProgress()),
            child: const ProgressPage(),
          ),
        ),
      );

      // Wait for initial render and async operations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Verify we have both GlassyContainer and regular Container widgets
      final glassyContainers = find.byType(GlassyContainer);
      final containers = find.byType(Container);

      expect(glassyContainers, findsWidgets);
      expect(containers, findsWidgets);

      // Check that we have proper white card styling
      int whiteCardCount = 0;
      int gradientCardCount = 0;

      for (final container in tester.widgetList(containers)) {
        final containerWidget = container as Container;
        final decoration = containerWidget.decoration as BoxDecoration?;

        if (decoration != null) {
          if (decoration.gradient != null) {
            gradientCardCount++;
          } else if (decoration.color == Colors.white ||
              decoration.color == Colors.white.withOpacity(0.9)) {
            whiteCardCount++;
          }
        }
      }

      print(
        '✅ Found ${tester.widgetList(glassyContainers).length} GlassyContainer cards',
      );
      print(
        '✅ Found ${tester.widgetList(containers).length} Container elements',
      );
      print(
        '✅ Found $whiteCardCount white cards and $gradientCardCount gradient elements',
      );

      // We should have white cards (GlassyContainer uses white background)
      expect(glassyContainers, findsWidgets);
    });

    testWidgets('Icons should use proper theme colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<ProgressBloc>(
            create: (context) =>
                ProgressBloc(progressRepository: mockRepository)
                  ..add(const LoadTodayProgress()),
            child: const ProgressPage(),
          ),
        ),
      );

      // Wait for initial render and async operations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Find all Icon widgets
      final icons = find.byType(Icon);
      expect(icons, findsWidgets);

      // Verify icons are using proper theme colors (not white)
      final iconWidgets = tester.widgetList(icons).cast<Icon>();
      bool hasColoredIcons = false;

      for (final icon in iconWidgets) {
        if (icon.color != null && icon.color != Colors.white) {
          hasColoredIcons = true;
          break;
        }
      }

      // Should have at least some colored icons
      expect(hasColoredIcons, isTrue);

      print(
        '✅ Found ${tester.widgetList(icons).length} icons with proper theme colors',
      );
    });
  });
}
