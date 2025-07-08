-- Create normalized azkar database schema for Supabase
-- This schema supports the three-screen flow: AzkarScreen -> AzkarCategoryScreen -> AzkarDetailScreen

-- 1. Create azkar_categories table
CREATE TABLE IF NOT EXISTS public.azkar_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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

-- 2. Create azkar table with foreign key to categories
CREATE TABLE IF NOT EXISTS public.azkar (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES public.azkar_categories(id) ON DELETE CASCADE,
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

-- 3. Create user_azkar_progress table for tracking completion
CREATE TABLE IF NOT EXISTS public.user_azkar_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID, -- Optional for anonymous users
    azkar_id UUID NOT NULL REFERENCES public.azkar(id) ON DELETE CASCADE,
    completed_count INTEGER DEFAULT 0,
    total_count INTEGER DEFAULT 0,
    last_completed_at TIMESTAMP WITH TIME ZONE,
    streak_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 4. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_azkar_categories_order ON public.azkar_categories(order_index);
CREATE INDEX IF NOT EXISTS idx_azkar_categories_active ON public.azkar_categories(is_active);
CREATE INDEX IF NOT EXISTS idx_azkar_category_id ON public.azkar(category_id);
CREATE INDEX IF NOT EXISTS idx_azkar_order ON public.azkar(order_index);
CREATE INDEX IF NOT EXISTS idx_azkar_moods ON public.azkar USING GIN(associated_moods);
CREATE INDEX IF NOT EXISTS idx_azkar_search ON public.azkar USING GIN(to_tsvector('arabic', text_ar || ' ' || COALESCE(search_tags, '')));
CREATE INDEX IF NOT EXISTS idx_user_azkar_progress_user ON public.user_azkar_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_azkar_progress_azkar ON public.user_azkar_progress(azkar_id);

-- 5. Create updated_at triggers
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_azkar_categories_updated_at BEFORE UPDATE ON public.azkar_categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_azkar_updated_at BEFORE UPDATE ON public.azkar FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_azkar_progress_updated_at BEFORE UPDATE ON public.user_azkar_progress FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 6. Enable Row Level Security (RLS)
ALTER TABLE public.azkar_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.azkar ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_azkar_progress ENABLE ROW LEVEL SECURITY;

-- 7. Create policies for public read access to azkar and categories
CREATE POLICY "Public can read azkar categories" ON public.azkar_categories FOR SELECT USING (true);
CREATE POLICY "Public can read azkar" ON public.azkar FOR SELECT USING (true);

-- 8. Create policies for user progress (users can only access their own progress)
CREATE POLICY "Users can read their own progress" ON public.user_azkar_progress FOR SELECT USING (user_id = auth.uid() OR user_id IS NULL);
CREATE POLICY "Users can insert their own progress" ON public.user_azkar_progress FOR INSERT WITH CHECK (user_id = auth.uid() OR user_id IS NULL);
CREATE POLICY "Users can update their own progress" ON public.user_azkar_progress FOR UPDATE USING (user_id = auth.uid() OR user_id IS NULL);
CREATE POLICY "Users can delete their own progress" ON public.user_azkar_progress FOR DELETE USING (user_id = auth.uid() OR user_id IS NULL);

-- 9. Insert default azkar categories
INSERT INTO public.azkar_categories (name_ar, name_en, description, icon, color, order_index) VALUES
('أذكار الصباح', 'Morning Azkar', 'أذكار تقال في الصباح للحماية والبركة', 'morning', '#FF8A65', 1),
('أذكار المساء', 'Evening Azkar', 'أذكار تقال في المساء للحماية والاستقرار', 'evening', '#5C6BC0', 2),
('أذكار النوم', 'Sleep Azkar', 'أذكار تقال قبل النوم للحماية والراحة', 'sleep', '#7986CB', 3),
('أذكار الصلاة', 'Prayer Azkar', 'أذكار تقال بعد الصلاة', 'prayer', '#66BB6A', 4),
('أذكار السفر', 'Travel Azkar', 'أذكار تقال عند السفر للحماية والأمان', 'travel', '#42A5F5', 5),
('أذكار الطعام', 'Food Azkar', 'أذكار تقال قبل وبعد الطعام', 'food', '#FFA726', 6),
('أذكار الشكر', 'Gratitude Azkar', 'أذكار الشكر والحمد', 'gratitude', '#EF5350', 7),
('أذكار الكرب', 'Distress Relief Azkar', 'أذكار تقال عند الضيق والكرب', 'stress_relief', '#26A69A', 8),
('أذكار الحماية', 'Protection Azkar', 'أذكار للحماية من الشر والحسد', 'protection', '#AB47BC', 9),
('أذكار عامة', 'General Azkar', 'أذكار عامة للذكر والتسبيح', 'general', '#78909C', 10);

-- 10. Comment on tables
COMMENT ON TABLE public.azkar_categories IS 'Categories of azkar (Islamic remembrances)';
COMMENT ON TABLE public.azkar IS 'Islamic remembrances and supplications';
COMMENT ON TABLE public.user_azkar_progress IS 'User progress tracking for azkar completion';
