import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/core/config/app_config.dart';
import 'package:sakinah_app/features/progress/presentation/bloc/progress_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  await AppConfig.loadEnv();

  // Initialize dependencies
  await initializeDependencies();

  runApp(const ProgressTestApp());
}

class ProgressTestApp extends StatelessWidget {
  const ProgressTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProgressBloc>(),
      child: MaterialApp(
        title: 'Progress Test',
        home: const ProgressTestPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ProgressTestPage extends StatefulWidget {
  const ProgressTestPage({super.key});

  @override
  State<ProgressTestPage> createState() => _ProgressTestPageState();
}

class _ProgressTestPageState extends State<ProgressTestPage> {
  @override
  void initState() {
    super.initState();
    // Load today's progress when the test starts
    context.read<ProgressBloc>().add(const LoadTodayProgress());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress System Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ProgressBloc, ProgressState>(
        listener: (context, state) {
          if (state is TodayProgressLoaded) {
            print(
              '✅ Progress updated: ${state.progress.azkarCompleted} azkar completed',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Progress updated: ${state.progress.azkarCompleted} azkar completed',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProgressError) {
            print('❌ Progress error: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProgressBloc, ProgressState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Progress System Test',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Display current state
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current State: ${state.runtimeType}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (state is TodayProgressLoaded) ...[
                          Text(
                            'Azkar Completed: ${state.progress.azkarCompleted}',
                          ),
                          Text('Current Streak: ${state.currentStreak}'),
                          Text(
                            'Completed Azkar IDs: ${state.progress.completedAzkarIds}',
                          ),
                          Text('Date: ${state.progress.date}'),
                        ] else if (state is ProgressLoading) ...[
                          const Text('Loading progress...'),
                        ] else if (state is ProgressError) ...[
                          Text('Error: ${state.message}'),
                        ] else ...[
                          const Text('Initial state'),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Test buttons
                  ElevatedButton(
                    onPressed: () {
                      print('🔄 Loading today\'s progress...');
                      context.read<ProgressBloc>().add(
                        const LoadTodayProgress(),
                      );
                    },
                    child: const Text('Load Today\'s Progress'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      print('🎯 Adding test azkar completion...');
                      final testAzkarId =
                          'test-azkar-${DateTime.now().millisecondsSinceEpoch}';
                      context.read<ProgressBloc>().add(
                        AddAzkarCompletion(azkarId: testAzkarId),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Test Azkar Completion'),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      print('🔄 Refreshing progress...');
                      context.read<ProgressBloc>().add(const RefreshProgress());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Refresh All Progress'),
                  ),

                  const SizedBox(height: 20),

                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Instructions:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1. Press "Load Today\'s Progress" to fetch current data',
                        ),
                        Text(
                          '2. Press "Add Test Azkar Completion" to simulate completing an azkar',
                        ),
                        Text(
                          '3. Watch the progress numbers update in real-time',
                        ),
                        Text(
                          '4. Check if the home page progress circle also updates',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
