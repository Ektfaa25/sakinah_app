-- Migration script to populate the new azkar structure from existing data
-- This will extract categories from the old azkar table and populate the new normalized structure

DO $$
DECLARE
    category_record RECORD;
    azkar_record RECORD;
    category_mapping JSONB;
    new_category_id UUID;
BEGIN
    -- Create a mapping for category translations
    category_mapping := '{
        "أذكار الصباح": {"name_en": "Morning Azkar", "icon": "morning", "color": "#FF8A65"},
        "أذكار المساء": {"name_en": "Evening Azkar", "icon": "evening", "color": "#5C6BC0"},
        "أذكار النوم": {"name_en": "Sleep Azkar", "icon": "sleep", "color": "#7986CB"},
        "أذكار الصلاة": {"name_en": "Prayer Azkar", "icon": "prayer", "color": "#66BB6A"},
        "أذكار السفر": {"name_en": "Travel Azkar", "icon": "travel", "color": "#42A5F5"},
        "أذكار الطعام": {"name_en": "Food Azkar", "icon": "food", "color": "#FFA726"},
        "أذكار الشكر": {"name_en": "Gratitude Azkar", "icon": "gratitude", "color": "#EF5350"},
        "أذكار الكرب": {"name_en": "Distress Relief Azkar", "icon": "stress_relief", "color": "#26A69A"},
        "أذكار الحماية": {"name_en": "Protection Azkar", "icon": "protection", "color": "#AB47BC"},
        "دعاء الاستيقاظ": {"name_en": "Waking Up Dua", "icon": "morning", "color": "#FFCA28"},
        "دعاء لبس الثوب الجديد": {"name_en": "New Clothes Dua", "icon": "general", "color": "#78909C"},
        "دعاء دخول الخلاء": {"name_en": "Entering Toilet Dua", "icon": "general", "color": "#78909C"},
        "دعاء الخروج من الخلاء": {"name_en": "Exiting Toilet Dua", "icon": "general", "color": "#78909C"},
        "دعاء الوضوء": {"name_en": "Ablution Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الذهاب إلى المسجد": {"name_en": "Going to Mosque Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء دخول المسجد": {"name_en": "Entering Mosque Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الخروج من المسجد": {"name_en": "Exiting Mosque Dua", "icon": "prayer", "color": "#66BB6A"},
        "أذكار الأذان": {"name_en": "Adhan Azkar", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الاستفتاح": {"name_en": "Opening Prayer Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الركوع": {"name_en": "Bowing Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الرفع من الركوع": {"name_en": "Rising from Bowing Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء السجود": {"name_en": "Prostration Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الجلسة بين السجدتين": {"name_en": "Between Prostrations Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء التشهد": {"name_en": "Tashahhud Dua", "icon": "prayer", "color": "#66BB6A"},
        "الصلاة على النبي": {"name_en": "Prayers upon Prophet", "icon": "prayer", "color": "#66BB6A"},
        "الدعاء بعد التشهد الأخير": {"name_en": "Final Tashahhud Dua", "icon": "prayer", "color": "#66BB6A"},
        "أذكار بعد السلام من الصلاة": {"name_en": "Post-Prayer Azkar", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الاستخارة": {"name_en": "Istikhara Dua", "icon": "prayer", "color": "#66BB6A"},
        "أذكار بعد السلام من الصلاة مباشرة": {"name_en": "Immediate Post-Prayer Azkar", "icon": "prayer", "color": "#66BB6A"},
        "دعاء قنوت الوتر": {"name_en": "Witr Qunut Dua", "icon": "prayer", "color": "#66BB6A"},
        "الذكر عقب السلام من الوتر": {"name_en": "Post-Witr Azkar", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الهم والحزن": {"name_en": "Sadness and Worry Dua", "icon": "stress_relief", "color": "#26A69A"},
        "دعاء الكرب": {"name_en": "Distress Dua", "icon": "stress_relief", "color": "#26A69A"},
        "دعاء لقاء العدو وذي السلطان": {"name_en": "Meeting Enemy/Authority Dua", "icon": "protection", "color": "#AB47BC"},
        "دعاء من خاف ظلم السلطان": {"name_en": "Fear of Authority Dua", "icon": "protection", "color": "#AB47BC"},
        "دعاء من أصابه وسوسة في الإيمان": {"name_en": "Faith Doubts Dua", "icon": "protection", "color": "#AB47BC"},
        "دعاء قضاء الدين": {"name_en": "Debt Relief Dua", "icon": "stress_relief", "color": "#26A69A"},
        "دعاء الوسوسة": {"name_en": "Whispers Dua", "icon": "protection", "color": "#AB47BC"},
        "دعاء من استصعب عليه أمر": {"name_en": "Difficult Matters Dua", "icon": "stress_relief", "color": "#26A69A"},
        "ما يقول ويفعل من أذنب ذنبا": {"name_en": "Repentance Dua", "icon": "general", "color": "#78909C"},
        "دعاء طرد الشيطان ووساوسه": {"name_en": "Expelling Satan Dua", "icon": "protection", "color": "#AB47BC"},
        "الدعاء حينما يقع ما لا يرضاه أو غلب على أمره": {"name_en": "When Displeased Dua", "icon": "stress_relief", "color": "#26A69A"},
        "تهنئة المولود له وجوابه": {"name_en": "New Baby Congratulations", "icon": "general", "color": "#78909C"},
        "ما يعوذ به الأولاد": {"name_en": "Children Protection", "icon": "protection", "color": "#AB47BC"},
        "دعاء المريض": {"name_en": "Sick Person Dua", "icon": "stress_relief", "color": "#26A69A"},
        "ثواب عيادة المريض": {"name_en": "Visiting Sick Reward", "icon": "general", "color": "#78909C"},
        "دعاء المريض الذي يئس من حياته": {"name_en": "Dying Person Dua", "icon": "general", "color": "#78909C"},
        "تلقين المحتضر": {"name_en": "Dying Person Guidance", "icon": "general", "color": "#78909C"},
        "دعاء من أصيب بمصيبة": {"name_en": "Calamity Dua", "icon": "stress_relief", "color": "#26A69A"},
        "الدعاء عند إغماض الميت": {"name_en": "Closing Eyes of Deceased", "icon": "general", "color": "#78909C"},
        "الدعاء للميت في الصلاة عليه": {"name_en": "Funeral Prayer Dua", "icon": "general", "color": "#78909C"},
        "الدعاء للفرط في الصلاة عليه": {"name_en": "Child Funeral Prayer", "icon": "general", "color": "#78909C"},
        "دعاء التعزية": {"name_en": "Condolence Dua", "icon": "general", "color": "#78909C"},
        "الدعاء عند إدخال الميت القبر": {"name_en": "Burial Dua", "icon": "general", "color": "#78909C"},
        "الدعاء بعد دفن الميت": {"name_en": "Post-Burial Dua", "icon": "general", "color": "#78909C"},
        "دعاء زيارة القبور": {"name_en": "Visiting Graves Dua", "icon": "general", "color": "#78909C"},
        "دعاء الريح": {"name_en": "Wind Dua", "icon": "general", "color": "#78909C"},
        "دعاء الرعد": {"name_en": "Thunder Dua", "icon": "general", "color": "#78909C"},
        "دعاء المطر": {"name_en": "Rain Dua", "icon": "general", "color": "#78909C"},
        "الذكر بعد نزول المطر": {"name_en": "After Rain Azkar", "icon": "general", "color": "#78909C"},
        "دعاء الاستسقاء": {"name_en": "Rain Seeking Dua", "icon": "general", "color": "#78909C"},
        "دعاء الكسوف": {"name_en": "Eclipse Dua", "icon": "general", "color": "#78909C"},
        "دعاء النزول منزل في السفر": {"name_en": "Travel Lodging Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء الركوب": {"name_en": "Mount/Vehicle Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء السفر": {"name_en": "Travel Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء دخول القرية أو البلدة": {"name_en": "Entering Town Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء دخول السوق": {"name_en": "Entering Market Dua", "icon": "general", "color": "#78909C"},
        "الدعاء إذا تعس المركوب": {"name_en": "Vehicle Trouble Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء المسافر للمقيم": {"name_en": "Traveler for Resident Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء المقيم للمسافر": {"name_en": "Resident for Traveler Dua", "icon": "travel", "color": "#42A5F5"},
        "التكبير والتسبيح في سير السفر": {"name_en": "Travel Takbeer Tasbih", "icon": "travel", "color": "#42A5F5"},
        "دعاء المسافر إذا أسحر": {"name_en": "Dawn Travel Dua", "icon": "travel", "color": "#42A5F5"},
        "الدعاء إذا نزل بلاد الكفار": {"name_en": "Non-Muslim Land Dua", "icon": "travel", "color": "#42A5F5"},
        "الدعاء عند الرجوع من السفر": {"name_en": "Returning from Travel Dua", "icon": "travel", "color": "#42A5F5"},
        "ما يقول من ركب دابة أو سيارة ونحوها": {"name_en": "Riding Animal/Vehicle", "icon": "travel", "color": "#42A5F5"},
        "دعاء الضيافة": {"name_en": "Hospitality Dua", "icon": "food", "color": "#FFA726"},
        "دعاء الضيف لصاحب الطعام": {"name_en": "Guest for Host Dua", "icon": "food", "color": "#FFA726"},
        "التعريض بالدعاء لطلب الطعام أو الشراب": {"name_en": "Hinting for Food/Drink", "icon": "food", "color": "#FFA726"},
        "الدعاء عند إفطار الصائم": {"name_en": "Breaking Fast Dua", "icon": "food", "color": "#FFA726"},
        "الدعاء قبل الطعام": {"name_en": "Before Eating Dua", "icon": "food", "color": "#FFA726"},
        "الدعاء عند الفراغ من الطعام": {"name_en": "After Eating Dua", "icon": "food", "color": "#FFA726"},
        "دعاء الضيف إذا أفطر عنده": {"name_en": "Guest Breaking Fast Dua", "icon": "food", "color": "#FFA726"},
        "ما يقول الصائم إذا سابه أحد أو جهل عليه": {"name_en": "Fasting Person Insulted", "icon": "general", "color": "#78909C"},
        "الدعاء عند رؤية باكورة الثمر": {"name_en": "First Fruit Dua", "icon": "food", "color": "#FFA726"},
        "دعاء العطاس": {"name_en": "Sneezing Dua", "icon": "general", "color": "#78909C"},
        "ما يقال للكافر إذا عطس فحمد الله": {"name_en": "Non-Muslim Sneezing", "icon": "general", "color": "#78909C"},
        "الدعاء للمتزوج": {"name_en": "Marriage Dua", "icon": "general", "color": "#78909C"},
        "دعاء المتزوج وشراء الدابة": {"name_en": "Marriage and Purchase Dua", "icon": "general", "color": "#78909C"},
        "الدعاء قبل إتيان الزوجة": {"name_en": "Before Intimacy Dua", "icon": "general", "color": "#78909C"},
        "دعاء الغضب": {"name_en": "Anger Dua", "icon": "stress_relief", "color": "#26A69A"},
        "دعاء من رأى مبتلى": {"name_en": "Seeing Afflicted Person Dua", "icon": "general", "color": "#78909C"},
        "ما يقال في المجلس": {"name_en": "Gathering Dua", "icon": "general", "color": "#78909C"},
        "كفارة المجلس": {"name_en": "Gathering Expiation", "icon": "general", "color": "#78909C"},
        "الدعاء لمن قال غفر الله لك": {"name_en": "Forgiveness Response Dua", "icon": "general", "color": "#78909C"},
        "الدعاء لمن صنع إليك معروفا": {"name_en": "Kindness Response Dua", "icon": "gratitude", "color": "#EF5350"},
        "ما يعصم الله به من الدجال": {"name_en": "Protection from Dajjal", "icon": "protection", "color": "#AB47BC"},
        "الدعاء لمن قال إني أحبك في الله": {"name_en": "Love for Allah Response", "icon": "general", "color": "#78909C"},
        "الدعاء لمن عرض عليك ماله": {"name_en": "Offered Wealth Response", "icon": "general", "color": "#78909C"},
        "الدعاء لمن أقرض عند القضاء": {"name_en": "Loan Repayment Dua", "icon": "general", "color": "#78909C"},
        "دعاء الخوف من الشرك": {"name_en": "Shirk Fear Dua", "icon": "protection", "color": "#AB47BC"},
        "الدعاء لمن قال بارك الله فيك": {"name_en": "Blessing Response Dua", "icon": "general", "color": "#78909C"},
        "دعاء كراهية الطيرة": {"name_en": "Bad Omen Dua", "icon": "protection", "color": "#AB47BC"},
        "دعاء الركوب": {"name_en": "Riding Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء السفر": {"name_en": "Travel Dua", "icon": "travel", "color": "#42A5F5"},
        "دعاء دخول البيت": {"name_en": "Entering House Dua", "icon": "general", "color": "#78909C"},
        "دعاء الخروج من البيت": {"name_en": "Leaving House Dua", "icon": "general", "color": "#78909C"},
        "دعاء الذهاب إلى المسجد": {"name_en": "Going to Mosque Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء دخول المسجد": {"name_en": "Entering Mosque Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الخروج من المسجد": {"name_en": "Exiting Mosque Dua", "icon": "prayer", "color": "#66BB6A"},
        "دعاء الاستيقاظ من النوم": {"name_en": "Waking Up Dua", "icon": "morning", "color": "#FFCA28"},
        "دعاء الأرق": {"name_en": "Insomnia Dua", "icon": "sleep", "color": "#7986CB"},
        "دعاء الفزع في النوم و من بُلِيَ بالوحشة": {"name_en": "Nightmare Dua", "icon": "sleep", "color": "#7986CB"},
        "ما يفعل من رأى الرؤيا أو الحلم": {"name_en": "Dream Response", "icon": "sleep", "color": "#7986CB"},
        "دعاء قنوت الوتر": {"name_en": "Witr Qunut Dua", "icon": "prayer", "color": "#66BB6A"},
        "الذكر عقب السلام من الوتر": {"name_en": "Post-Witr Azkar", "icon": "prayer", "color": "#66BB6A"}
    }'::JSONB;

    -- First, ensure we have the basic categories
    RAISE NOTICE 'Ensuring basic categories exist...';
    
    -- Get unique categories from the old azkar table
    FOR category_record IN 
        SELECT DISTINCT category, COUNT(*) as azkar_count
        FROM public.azkar 
        WHERE category IS NOT NULL 
        GROUP BY category
        ORDER BY category
    LOOP
        RAISE NOTICE 'Processing category: %', category_record.category;
        
        -- Check if category already exists
        SELECT id INTO new_category_id
        FROM public.azkar_categories 
        WHERE name_ar = category_record.category;
        
        IF new_category_id IS NULL THEN
            -- Insert new category
            INSERT INTO public.azkar_categories (
                name_ar, 
                name_en, 
                icon, 
                color, 
                order_index,
                description
            ) VALUES (
                category_record.category,
                COALESCE((category_mapping->>category_record.category)->>'name_en', category_record.category),
                COALESCE((category_mapping->>category_record.category)->>'icon', 'general'),
                COALESCE((category_mapping->>category_record.category)->>'color', '#78909C'),
                (SELECT COALESCE(MAX(order_index), 0) + 1 FROM public.azkar_categories),
                'فئة تحتوي على ' || category_record.azkar_count || ' من الأذكار'
            ) RETURNING id INTO new_category_id;
            
            RAISE NOTICE 'Created new category: % with ID: %', category_record.category, new_category_id;
        END IF;
        
        -- Now migrate azkar from old table to new table
        FOR azkar_record IN 
            SELECT * FROM public.azkar 
            WHERE category = category_record.category
            ORDER BY id
        LOOP
            -- Check if this azkar already exists in new table
            IF NOT EXISTS (
                SELECT 1 FROM public.azkar AS new_azkar
                WHERE new_azkar.category_id = new_category_id 
                AND new_azkar.text_ar = azkar_record.arabic_text
            ) THEN
                -- Extract moods from search_tags or set based on category
                DECLARE
                    mood_array TEXT[] := '{}';
                BEGIN
                    CASE category_record.category
                        WHEN 'أذكار الصباح' THEN mood_array := ARRAY['peaceful', 'grateful', 'energetic'];
                        WHEN 'أذكار المساء' THEN mood_array := ARRAY['peaceful', 'grateful', 'reflective'];
                        WHEN 'أذكار النوم' THEN mood_array := ARRAY['peaceful', 'sleepy', 'calm'];
                        WHEN 'أذكار الكرب' THEN mood_array := ARRAY['stressed', 'anxious', 'sad'];
                        WHEN 'أذكار الحماية' THEN mood_array := ARRAY['anxious', 'fearful', 'protective'];
                        WHEN 'أذكار الشكر' THEN mood_array := ARRAY['grateful', 'happy', 'blessed'];
                        WHEN 'أذكار الصلاة' THEN mood_array := ARRAY['spiritual', 'focused', 'peaceful'];
                        WHEN 'أذكار السفر' THEN mood_array := ARRAY['adventurous', 'protective', 'hopeful'];
                        WHEN 'أذكار الطعام' THEN mood_array := ARRAY['grateful', 'blessed', 'satisfied'];
                        ELSE mood_array := ARRAY['general', 'spiritual'];
                    END CASE;
                    
                    -- Insert the azkar
                    INSERT INTO public.azkar (
                        category_id,
                        text_ar,
                        translation,
                        reference,
                        description,
                        repeat_count,
                        associated_moods,
                        search_tags,
                        order_index
                    ) VALUES (
                        new_category_id,
                        azkar_record.arabic_text,
                        azkar_record.description,
                        azkar_record.reference,
                        azkar_record.description,
                        COALESCE(azkar_record.repetitions, 1),
                        mood_array,
                        azkar_record.search_tags,
                        (SELECT COALESCE(MAX(order_index), 0) + 1 FROM public.azkar WHERE category_id = new_category_id)
                    );
                END;
            END IF;
        END LOOP;
    END LOOP;
    
    RAISE NOTICE 'Migration completed successfully!';
END $$;
