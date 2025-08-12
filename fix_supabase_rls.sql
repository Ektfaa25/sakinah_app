-- Quick fix: Disable Row Level Security for development
-- Run this in your Supabase SQL Editor

-- Disable RLS on user_progress table
ALTER TABLE user_progress DISABLE ROW LEVEL SECURITY;

-- Optional: Also disable for other tables if they have RLS issues
-- ALTER TABLE user_azkar_progress DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE azkar DISABLE ROW LEVEL SECURITY;

-- Verify RLS status
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename IN ('user_progress', 'user_azkar_progress', 'azkar');
