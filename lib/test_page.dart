import 'package:flutter/material.dart';
import 'package:sakinah_app/core/di/service_locator.dart';
import 'package:sakinah_app/core/usecases/usecase.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';
import 'package:sakinah_app/features/azkar/domain/usecases/azkar_usecases.dart';
import 'package:sakinah_app/features/mood/domain/usecases/mood_usecases.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool _isLoading = false;
  String _result = '';

  Future<void> _testSupabaseConnection() async {
    setState(() {
      _isLoading = true;
      _result = 'Testing connection...';
    });

    try {
      // Test mood functionality
      final getAllMoodsUseCase = GetAllMoodsUseCase(moodRepository);
      final moods = await getAllMoodsUseCase(NoParams());

      // Test azkar functionality
      final getAllAzkarUseCase = GetAllAzkarUseCase(azkarRepository);
      final azkar = await getAllAzkarUseCase(NoParams());

      setState(() {
        _result =
            '''
✅ Connection successful!

📱 Available moods: ${moods.length}
${moods.take(3).map((m) => '${m.emoji} ${m.name}').join(', ')}

📿 Azkar in database: ${azkar.length}
${azkar.isEmpty ? 'No azkar found - try importing default ones!' : azkar.take(2).map((a) => '• ${a.category}').join('\n')}
        ''';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _importDefaultAzkar() async {
    setState(() {
      _isLoading = true;
      _result = 'Importing default azkar...';
    });

    try {
      final importUseCase = ImportDefaultAzkarUseCase(azkarRepository);
      await importUseCase(NoParams());

      setState(() {
        _result = '✅ Default azkar imported successfully!';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Import failed: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createTestAzkar() async {
    setState(() {
      _isLoading = true;
      _result = 'Creating test azkar...';
    });

    try {
      final createUseCase = CreateCustomAzkarUseCase(azkarRepository);
      final testAzkar = Azkar(
        arabicText: 'بسم الله الرحمن الرحيم',
        transliteration: 'Bismillah ir-Rahman ir-Raheem',
        translation:
            'In the name of Allah, the Most Gracious, the Most Merciful',
        category: 'general',
        associatedMoods: ['peaceful', 'grateful'],
        repetitions: 1,
        isCustom: true,
      );

      await createUseCase(testAzkar);

      setState(() {
        _result = '✅ Test azkar created successfully!';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Creation failed: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Test'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test Supabase Integration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _testSupabaseConnection,
              child: const Text('Test Connection'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _isLoading ? null : _importDefaultAzkar,
              child: const Text('Import Default Azkar'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _isLoading ? null : _createTestAzkar,
              child: const Text('Create Test Azkar'),
            ),

            const SizedBox(height: 20),

            if (_isLoading) const Center(child: CircularProgressIndicator()),

            if (_result.isNotEmpty) ...[
              const Text(
                'Result:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  _result,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
