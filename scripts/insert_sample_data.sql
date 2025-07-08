-- Add sample azkar data to the database
-- Run this AFTER creating the tables

-- Morning Azkar
INSERT INTO public.azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('morning', 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 
'Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illa Allah wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa ''ala kulli shay''in qadeer', 
'We have reached the morning and with it Allah''s kingdom. All praise is for Allah. There is no god but Allah alone, who has no partner. To Him belongs the kingdom, and all praise, and He is capable of all things.', 
1, 1),

('morning', 'اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ', 
'Allahumma bika asbahnaa wa bika amsayna, wa bika nahyaa wa bika namootu, wa ilaykan-nushoor', 
'O Allah, by You we have reached the morning and by You we have reached the evening, by You we live and by You we die, and to You is the resurrection.', 
1, 2),

('morning', 'رَضِيتُ بِاللهِ رَبًّا وَبِالْإِسْلَامِ دِينًا وَبِمُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ رَسُولًا', 
'Radeetu billahi rabban, wa bil-Islami deenan, wa bi Muhammadin sallallahu ''alayhi wa sallam rasoolan', 
'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my messenger.', 
3, 3);

-- Evening Azkar
INSERT INTO public.azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('evening', 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 
'Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illa Allah wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa ''ala kulli shay''in qadeer', 
'We have reached the evening and with it Allah''s kingdom. All praise is for Allah. There is no god but Allah alone, who has no partner. To Him belongs the kingdom, and all praise, and He is capable of all things.', 
1, 1),

('evening', 'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ', 
'Allahumma bika amsayna wa bika asbahnaa, wa bika nahyaa wa bika namootu, wa ilaykal-maseer', 
'O Allah, by You we have reached the evening and by You we have reached the morning, by You we live and by You we die, and to You is the return.', 
1, 2);

-- Gratitude Azkar
INSERT INTO public.azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('gratitude', 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 
'Alhamdu lillahi rabbil-''alameen', 
'All praise is for Allah, Lord of the worlds.', 
1, 1),

('gratitude', 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ', 
'Allahumma a''innee ''ala dhikrika wa shukrika wa husni ''ibaadatik', 
'O Allah, help me to remember You, to thank You, and to worship You in the best way.', 
1, 2);

-- Peace & Tranquility Azkar
INSERT INTO public.azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('peace', 'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 
'La ilaha illa Allah wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa ''ala kulli shay''in qadeer', 
'There is no god but Allah alone, who has no partner. To Him belongs the kingdom, and all praise, and He is capable of all things.', 
10, 1),

('peace', 'سُبْحَانَ اللهِ وَبِحَمْدِهِ', 
'Subhanallaahi wa bihamdihi', 
'Glory be to Allah and praise be to Him.', 
100, 2);

-- Stress Relief Azkar
INSERT INTO public.azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('stress_relief', 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ', 
'La ilaha illa anta subhaanaka innee kuntu minadh-dhaalimeen', 
'There is no god but You, glory be to You. Indeed, I was among the wrongdoers.', 
1, 1),

('stress_relief', 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ وَرَحْمَتِكَ، فَإِنَّهُ لَا يَمْلِكُهَا إِلَّا أَنْتَ', 
'Allahumma innee as''aluka min fadlika wa rahmatika, fa innahu la yamlikuha illa ant', 
'O Allah, I ask You for Your grace and mercy, for no one possesses them but You.', 
1, 2);

-- Protection Azkar
INSERT INTO public.azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('protection', 'أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ', 
'A''oodhu billaahi minash-shaytaanir-rajeem', 
'I seek refuge with Allah from Satan the accursed.', 
1, 1),

('protection', 'بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ', 
'Bismillaahil-ladhee la yadurru ma''as-mihi shay''un fil-ardi wa la fis-samaa''i wa huwas-samee''ul-''aleem', 
'In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, All-Knowing.', 
3, 2);
