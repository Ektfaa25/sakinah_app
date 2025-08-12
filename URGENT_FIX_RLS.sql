-- IMMEDIATE FIX: Run this in Supabase SQL Editor
-- This will disable Row Level Security and allow your app to work

ALTER TABLE user_progress DISABLE ROW LEVEL SECURITY;

-- Verify it worked
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'user_progress';
