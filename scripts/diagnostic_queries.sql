-- Quick diagnostic queries to check if tables exist and have data
-- Run these in your Supabase SQL Editor

-- 1. Check if tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('azkar_categories', 'azkar', 'user_azkar_progress');

-- 2. Check azkar_categories table structure and data
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'azkar_categories' 
AND table_schema = 'public';

-- 3. Count records in azkar_categories
SELECT COUNT(*) as category_count FROM public.azkar_categories;

-- 4. Show all categories
SELECT id, name_ar, name_en, is_active, order_index 
FROM public.azkar_categories 
ORDER BY order_index;

-- 5. Check if azkar table has data
SELECT COUNT(*) as azkar_count FROM public.azkar;

-- 6. Show sample azkar data
SELECT category_id, text_ar, translation, repeat_count 
FROM public.azkar 
LIMIT 5;

-- 7. Check RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('azkar_categories', 'azkar', 'user_azkar_progress');
