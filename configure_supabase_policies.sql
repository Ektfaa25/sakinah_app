-- Production solution: Configure proper RLS policies
-- Run this in your Supabase SQL Editor

-- Create policies for user_progress table
CREATE POLICY "Allow all operations on user_progress" ON user_progress
FOR ALL USING (true) WITH CHECK (true);

-- Alternative: More secure policy (if you add auth later)
-- CREATE POLICY "Users can manage their own progress" ON user_progress
-- FOR ALL USING (auth.uid()::text = user_id) WITH CHECK (auth.uid()::text = user_id);

-- Create policies for user_azkar_progress table (if needed)
CREATE POLICY "Allow all operations on user_azkar_progress" ON user_azkar_progress
FOR ALL USING (true) WITH CHECK (true);

-- Create policies for azkar table (if needed)
CREATE POLICY "Allow read access to azkar" ON azkar
FOR SELECT USING (true);

-- Verify policies are created
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('user_progress', 'user_azkar_progress', 'azkar');
