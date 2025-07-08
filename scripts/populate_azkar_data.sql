-- Step-by-step migration from JSON data to normalized schema
-- This script should be run after the create_azkar_tables.sql script

-- First, let's create a temporary table to hold the JSON data
CREATE TABLE IF NOT EXISTS temp_azkar_json (
    id SERIAL PRIMARY KEY,
    json_data JSONB
);

-- Insert the JSON data (this needs to be done manually or through a script)
-- The JSON data structure from assets/data/azkar_database.json should be inserted here

-- For now, let's create the categories that exist in the JSON
INSERT INTO azkar_categories (id, name_ar, name_en, description, icon, order_index) VALUES
('morning', 'أذكار الصباح', 'Morning Azkar', 'Remembrances to be recited in the morning', '🌅', 1),
('evening', 'أذكار المساء', 'Evening Azkar', 'Remembrances to be recited in the evening', '🌆', 2),
('gratitude', 'أذكار الشكر', 'Gratitude Azkar', 'Remembrances expressing gratitude', '🙏', 3),
('peace', 'أذكار السكينة', 'Peace & Tranquility', 'Remembrances for inner peace', '☮️', 4),
('stress_relief', 'أذكار تفريج الكرب', 'Stress Relief', 'Remembrances for anxiety and stress', '💆‍♀️', 5),
('protection', 'أذكار الحماية', 'Protection', 'Seeking Allah''s protection', '🛡️', 6)
ON CONFLICT (id) DO NOTHING;

-- Sample azkar data to populate the tables
-- This would normally come from the JSON file, but for now we'll add some examples

-- Morning Azkar
INSERT INTO azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
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
INSERT INTO azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('evening', 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 
'Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illa Allah wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa ''ala kulli shay''in qadeer', 
'We have reached the evening and with it Allah''s kingdom. All praise is for Allah. There is no god but Allah alone, who has no partner. To Him belongs the kingdom, and all praise, and He is capable of all things.', 
1, 1),

('evening', 'اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ', 
'Allahumma bika amsayna wa bika asbahnaa, wa bika nahyaa wa bika namootu, wa ilaykal-maseer', 
'O Allah, by You we have reached the evening and by You we have reached the morning, by You we live and by You we die, and to You is the return.', 
1, 2);

-- Gratitude Azkar
INSERT INTO azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('gratitude', 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 
'Alhamdu lillahi rabbil-''alameen', 
'All praise is for Allah, Lord of the worlds.', 
1, 1),

('gratitude', 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ', 
'Allahumma a''innee ''ala dhikrika wa shukrika wa husni ''ibaadatik', 
'O Allah, help me to remember You, to thank You, and to worship You in the best way.', 
1, 2);

-- Peace & Tranquility Azkar
INSERT INTO azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('peace', 'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 
'La ilaha illa Allah wahdahu la shareeka lah, lahul-mulku wa lahul-hamdu wa huwa ''ala kulli shay''in qadeer', 
'There is no god but Allah alone, who has no partner. To Him belongs the kingdom, and all praise, and He is capable of all things.', 
10, 1),

('peace', 'سُبْحَانَ اللهِ وَبِحَمْدِهِ', 
'Subhanallaahi wa bihamdihi', 
'Glory be to Allah and praise be to Him.', 
100, 2);

-- Stress Relief Azkar
INSERT INTO azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('stress_relief', 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ', 
'La ilaha illa anta subhaanaka innee kuntu minadh-dhaalimeen', 
'There is no god but You, glory be to You. Indeed, I was among the wrongdoers.', 
1, 1),

('stress_relief', 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ وَرَحْمَتِكَ، فَإِنَّهُ لَا يَمْلِكُهَا إِلَّا أَنْتَ', 
'Allahumma innee as''aluka min fadlika wa rahmatika, fa innahu la yamlikuha illa ant', 
'O Allah, I ask You for Your grace and mercy, for no one possesses them but You.', 
1, 2);

-- Protection Azkar
INSERT INTO azkar (category_id, text_ar, transliteration, translation, repeat_count, order_index) VALUES
('protection', 'أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ', 
'A''oodhu billaahi minash-shaytaanir-rajeem', 
'I seek refuge with Allah from Satan the accursed.', 
1, 1),

('protection', 'بِسْمِ اللهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ', 
'Bismillaahil-ladhee la yadurru ma''as-mihi shay''un fil-ardi wa la fis-samaa''i wa huwas-samee''ul-''aleem', 
'In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, All-Knowing.', 
3, 2);

-- Create mood mappings (this would be extracted from the JSON)
-- For now, we'll create some sample mappings based on the JSON structure

-- Note: The actual migration would involve:
-- 1. Reading the JSON file
-- 2. Parsing the azkar data
-- 3. Inserting each azkar with proper category associations
-- 4. Setting up mood mappings if needed

-- Update the statistics
UPDATE azkar_categories SET 
    updated_at = NOW(),
    order_index = CASE 
        WHEN id = 'morning' THEN 1
        WHEN id = 'evening' THEN 2
        WHEN id = 'gratitude' THEN 3
        WHEN id = 'peace' THEN 4
        WHEN id = 'stress_relief' THEN 5
        WHEN id = 'protection' THEN 6
        ELSE order_index
    END;

-- Clean up temporary table
DROP TABLE IF EXISTS temp_azkar_json;
