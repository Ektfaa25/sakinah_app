import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/azkar_card.dart';
import '../../domain/entities/azkar.dart';

class AzkarCardDemoScreen extends StatelessWidget {
  const AzkarCardDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample azkar for demonstration
    final sampleAzkar = [
      const Azkar(
        id: 1,
        arabicText: 'سُبْحَانَ اللَّهِ',
        transliteration: 'Subhan Allah',
        translation: 'Glory be to Allah',
        category: 'تسبيح',
        associatedMoods: ['peaceful'],
        repetitions: 33,
      ),
      const Azkar(
        id: 2,
        arabicText: 'الْحَمْدُ لِلَّهِ',
        transliteration: 'Alhamdulillah',
        translation: 'All praise be to Allah',
        category: 'حمد',
        associatedMoods: ['grateful'],
        repetitions: 33,
      ),
      const Azkar(
        id: 3,
        arabicText: 'اللَّهُ أَكْبَرُ',
        transliteration: 'Allahu Akbar',
        translation: 'Allah is the Greatest',
        category: 'تكبير',
        associatedMoods: ['powerful'],
        repetitions: 34,
      ),
      const Azkar(
        id: 4,
        arabicText:
            'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        transliteration:
            'La ilaha illa Allah wahdahu la sharika lah, lahu al-mulku wa lahu al-hamd, wa huwa ala kulli shayin qadir',
        translation:
            'There is no god but Allah alone, with no partner. To Him belongs the kingdom and all praise, and He has power over all things.',
        category: 'توحيد',
        associatedMoods: ['focused'],
        repetitions: 10,
      ),
      const Azkar(
        id: 5,
        arabicText:
            'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
        transliteration:
            'Astaghfiru Allah al-azeem alladhi la ilaha illa huwa al-hayyu al-qayyumu wa atubu ilayh',
        translation:
            'I seek forgiveness from Allah the Mighty, whom there is no god but He, the Living, the Eternal, and I repent to Him.',
        category: 'استغفار',
        associatedMoods: ['repentant'],
        repetitions: 1,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'عرض بطاقة الأذكار',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'عرض تفاعلي لبطاقة الأذكار',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اضغط على البطاقات لرؤية الترجمة • اضغط على العداد للتكرار • اضغط مطولاً لإعادة التعيين',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),

              // Cards list
              Expanded(
                child: ListView.builder(
                  itemCount: sampleAzkar.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AzkarCard(
                        key: ValueKey('demo_azkar_$index'),
                        azkar: sampleAzkar[index],
                        isCompleted: false,
                        onCompleted: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                '✅ تم إكمال الذكر!',
                                textDirection: TextDirection.rtl,
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        onIncomplete: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                '🔄 تم إعادة تعيين العداد',
                                textDirection: TextDirection.rtl,
                              ),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
