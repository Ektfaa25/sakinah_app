-- Create user_favorites table to store user's favorite azkar
-- This table will track which azkar each user has marked as favorite

CREATE TABLE IF NOT EXISTS user_favorites (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id TEXT NOT NULL, -- Can be actual user ID or device identifier for anonymous users
    azkar_id UUID NOT NULL REFERENCES azkar(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Ensure a user can only favorite the same azkar once
    UNIQUE(user_id, azkar_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_favorites_user_id ON user_favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_azkar_id ON user_favorites(azkar_id);
CREATE INDEX IF NOT EXISTS idx_user_favorites_created_at ON user_favorites(created_at);

-- Add RLS (Row Level Security) policies if needed
-- ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;

-- Create a trigger to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_user_favorites_updated_at ON user_favorites;
CREATE TRIGGER update_user_favorites_updated_at
    BEFORE UPDATE ON user_favorites
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Insert some sample data for testing (optional)
-- INSERT INTO user_favorites (user_id, azkar_id) VALUES 
-- ('local_device_user', 'sample_azkar_id_1'),
-- ('local_device_user', 'sample_azkar_id_2');

COMMENT ON TABLE user_favorites IS 'Stores user favorite azkar selections';
COMMENT ON COLUMN user_favorites.user_id IS 'User identifier (can be device ID for anonymous users)';
COMMENT ON COLUMN user_favorites.azkar_id IS 'Reference to the azkar that was favorited';
COMMENT ON COLUMN user_favorites.created_at IS 'When the azkar was favorited';
COMMENT ON COLUMN user_favorites.updated_at IS 'When the favorite record was last updated';
