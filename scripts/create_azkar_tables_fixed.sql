-- Create azkar database schema for Supabase
-- Updated to work with the current app structure

-- 1. Create azkar_categories table
CREATE TABLE IF NOT EXISTS public.azkar_categories (
    id TEXT PRIMARY KEY,
    name_ar TEXT NOT NULL,
    name_en TEXT,
    description TEXT,
    icon TEXT,
    color TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 2. Create azkar table
CREATE TABLE IF NOT EXISTS public.azkar (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    category_id TEXT NOT NULL REFERENCES public.azkar_categories(id) ON DELETE CASCADE,
    text_ar TEXT NOT NULL,
    text_en TEXT,
    transliteration TEXT,
    translation TEXT,
    reference TEXT,
    description TEXT,
    repeat_count INTEGER DEFAULT 1,
    order_index INTEGER NOT NULL DEFAULT 0,
    associated_moods TEXT[] DEFAULT '{}',
    search_tags TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 3. Create user_azkar_progress table
CREATE TABLE IF NOT EXISTS public.user_azkar_progress (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    user_id TEXT, -- Optional for anonymous users
    azkar_id TEXT NOT NULL REFERENCES public.azkar(id) ON DELETE CASCADE,
    completed_count INTEGER DEFAULT 0,
    total_count INTEGER DEFAULT 0,
    last_completed_at TIMESTAMP WITH TIME ZONE,
    streak_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 4. Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_azkar_categories_active ON public.azkar_categories(is_active);
CREATE INDEX IF NOT EXISTS idx_azkar_categories_order ON public.azkar_categories(order_index);
CREATE INDEX IF NOT EXISTS idx_azkar_category_id ON public.azkar(category_id);
CREATE INDEX IF NOT EXISTS idx_azkar_active ON public.azkar(is_active);
CREATE INDEX IF NOT EXISTS idx_azkar_order ON public.azkar(order_index);
CREATE INDEX IF NOT EXISTS idx_user_progress_azkar ON public.user_azkar_progress(azkar_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_user ON public.user_azkar_progress(user_id);

-- 5. Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_azkar_categories_updated_at 
    BEFORE UPDATE ON public.azkar_categories 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_azkar_updated_at 
    BEFORE UPDATE ON public.azkar 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_azkar_progress_updated_at 
    BEFORE UPDATE ON public.user_azkar_progress 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 6. Enable Row Level Security (RLS)
ALTER TABLE public.azkar_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.azkar ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_azkar_progress ENABLE ROW LEVEL SECURITY;

-- 7. Create RLS policies for public read access
CREATE POLICY "Allow public read access to azkar_categories" 
    ON public.azkar_categories FOR SELECT 
    USING (true);

CREATE POLICY "Allow public read access to azkar" 
    ON public.azkar FOR SELECT 
    USING (true);

-- 8. Create RLS policies for user progress (anonymous and authenticated)
CREATE POLICY "Allow read access to user_azkar_progress" 
    ON public.user_azkar_progress FOR SELECT 
    USING (true);

CREATE POLICY "Allow insert access to user_azkar_progress" 
    ON public.user_azkar_progress FOR INSERT 
    WITH CHECK (true);

CREATE POLICY "Allow update access to user_azkar_progress" 
    ON public.user_azkar_progress FOR UPDATE 
    USING (true);

-- 9. Insert default categories
INSERT INTO public.azkar_categories (id, name_ar, name_en, description, icon, order_index) VALUES
('morning', 'أذكار الصباح', 'Morning Azkar', 'Remembrances to be recited in the morning', '🌅', 1),
('evening', 'أذكار المساء', 'Evening Azkar', 'Remembrances to be recited in the evening', '🌆', 2),
('gratitude', 'أذكار الشكر', 'Gratitude Azkar', 'Remembrances expressing gratitude', '🙏', 3),
('peace', 'أذكار السكينة', 'Peace & Tranquility', 'Remembrances for inner peace', '☮️', 4),
('stress_relief', 'أذكار تفريج الكرب', 'Stress Relief', 'Remembrances for anxiety and stress', '💆‍♀️', 5),
('protection', 'أذكار الحماية', 'Protection', 'Seeking Allah''s protection', '🛡️', 6)
ON CONFLICT (id) DO UPDATE SET
    name_ar = EXCLUDED.name_ar,
    name_en = EXCLUDED.name_en,
    description = EXCLUDED.description,
    icon = EXCLUDED.icon,
    order_index = EXCLUDED.order_index,
    updated_at = now();
