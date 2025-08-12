-- ALTERNATIVE FIX: Create permissive policy instead of disabling RLS
-- Run this in Supabase SQL Editor if you want to keep RLS enabled

-- Create a policy that allows all operations
CREATE POLICY "temp_allow_all" ON user_progress
FOR ALL 
USING (true) 
WITH CHECK (true);

-- Verify policy was created
SELECT policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'user_progress';
