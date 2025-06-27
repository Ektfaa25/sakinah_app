import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakinah_app/core/router/app_routes.dart';
import 'package:sakinah_app/features/azkar/domain/entities/azkar.dart';

class AzkarDisplayPage extends StatefulWidget {
  final String? mood;

  const AzkarDisplayPage({super.key, this.mood});

  @override
  State<AzkarDisplayPage> createState() => _AzkarDisplayPageState();
}

class _AzkarDisplayPageState extends State<AzkarDisplayPage> {
  int _currentIndex = 0;
  late List<Azkar> _azkarList;

  @override
  void initState() {
    super.initState();
    _azkarList = _getAzkarForMood(widget.mood);
  }

  List<Azkar> _getAzkarForMood(String? mood) {
    // Mock data for different moods
    final azkarMap = {
      'grateful': [
        Azkar(
          id: 1,
          arabicText: 'الحمد لله رب العالمين',
          translation: 'All praise is for Allah, Lord of all the worlds',
          transliteration: 'Alhamdulillahi rabbil alameen',
          category: 'gratitude',
          associatedMoods: ['grateful'],
          repetitions: 3,
        ),
        Azkar(
          id: 2,
          arabicText: 'اللهم أعني على ذكرك وشكرك وحسن عبادتك',
          translation:
              'O Allah, help me to remember You, to thank You, and to worship You perfectly',
          transliteration:
              'Allahumma a\'inni ala dhikrika wa shukrika wa husni ibadatik',
          category: 'gratitude',
          associatedMoods: ['grateful'],
          repetitions: 1,
        ),
      ],
      'anxious': [
        Azkar(
          id: 3,
          arabicText: 'حسبنا الله ونعم الوكيل',
          translation:
              'Allah is sufficient for us, and He is the best Disposer of affairs',
          transliteration: 'Hasbunallahu wa ni\'mal wakeel',
          category: 'anxiety',
          associatedMoods: ['anxious'],
          repetitions: 7,
        ),
        Azkar(
          id: 4,
          arabicText:
              'لا إله إلا الله وحده لا شريك له له الملك وله الحمد وهو على كل شيء قدير',
          translation:
              'There is no god but Allah, alone without partner. To Him belongs the kingdom and praise, and He is capable of all things',
          transliteration:
              'La ilaha illa Allah wahdahu la sharika lah, lahul mulku wa lahul hamd wa huwa ala kulli shay\'in qadeer',
          category: 'anxiety',
          associatedMoods: ['anxious'],
          repetitions: 10,
        ),
      ],
      'peaceful': [
        Azkar(
          id: 5,
          arabicText: 'سبحان الله وبحمده سبحان الله العظيم',
          translation:
              'Glory be to Allah and praise Him, Glory be to Allah the Great',
          transliteration: 'Subhanallahi wa bihamdihi subhanallahil azeem',
          category: 'peace',
          associatedMoods: ['peaceful'],
          repetitions: 10,
        ),
      ],
      'sad': [
        Azkar(
          id: 6,
          arabicText:
              'اللهم أذهب البأس رب الناس واشف أنت الشافي لا شفاء إلا شفاؤك شفاء لا يغادر سقما',
          translation:
              'O Allah, remove the hardship, Lord of mankind, and heal, You are the Healer. There is no healing except Your healing, a healing that leaves no illness',
          transliteration:
              'Allahumma adh-hibil ba\'sa rabban nas washfi antal shafi la shifa\'a illa shifa\'uk shifa\'an la yughadiru saqama',
          category: 'healing',
          associatedMoods: ['sad'],
          repetitions: 3,
        ),
      ],
    };

    return azkarMap[mood] ?? azkarMap['peaceful']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Implement bookmark functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Text(
                    '${_currentIndex + 1} / ${_azkarList.length}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _azkarList.length,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Main content
            Expanded(
              child: PageView.builder(
                itemCount: _azkarList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _AzkarCard(azkar: _azkarList[index]);
                },
              ),
            ),

            // Navigation controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentIndex > 0 ? _previousAzkar : null,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      // TODO: Mark as completed
                      context.push(AppRoutes.progress);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('تم'),
                  ),

                  ElevatedButton(
                    onPressed: _currentIndex < _azkarList.length - 1
                        ? _nextAzkar
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previousAzkar() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _nextAzkar() {
    if (_currentIndex < _azkarList.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }
}

class _AzkarCard extends StatefulWidget {
  final Azkar azkar;

  const _AzkarCard({required this.azkar});

  @override
  State<_AzkarCard> createState() => _AzkarCardState();
}

class _AzkarCardState extends State<_AzkarCard> {
  int _currentRepetition = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Arabic text
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    widget.azkar.arabicText,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.8,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),

              const Divider(height: 32),

              // Transliteration
              if (widget.azkar.transliteration != null)
                Expanded(
                  flex: 1,
                  child: Text(
                    widget.azkar.transliteration!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // English translation
              if (widget.azkar.translation != null)
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.azkar.translation!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 16),

              // Repetition counter
              if (widget.azkar.repetitions > 1) ...[
                Text(
                  'التكرار: ${_currentRepetition + 1} / ${widget.azkar.repetitions}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _currentRepetition < widget.azkar.repetitions - 1
                      ? _incrementRepetition
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    '${_currentRepetition + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _incrementRepetition() {
    if (_currentRepetition < widget.azkar.repetitions - 1) {
      setState(() {
        _currentRepetition++;
      });
    }
  }
}
