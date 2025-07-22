# Azkar Favorites Functionality

## Overview
The favorites functionality allows users to mark specific azkar as favorites and access them quickly. The implementation uses a Supabase database to persist favorites across sessions.

## Database Setup

### 1. Create the user_favorites table
Run the SQL script located at `scripts/create_user_favorites_table.sql` in your Supabase database:

```sql
-- This script creates the user_favorites table and necessary indexes
-- Run this in your Supabase SQL editor
```

### 2. Table Structure
The `user_favorites` table contains:
- `id`: Primary key (UUID)
- `user_id`: User identifier (can be device ID for anonymous users)
- `azkar_id`: Reference to the azkar that was favorited
- `created_at`: When the azkar was favorited
- `updated_at`: When the favorite record was last updated

## Implementation

### Backend Methods (AzkarDatabaseAdapter)
- `addToFavorites()`: Add an azkar to favorites
- `removeFromFavorites()`: Remove an azkar from favorites
- `isAzkarFavorite()`: Check if an azkar is favorited
- `getFavoriteAzkar()`: Get all favorite azkar for a user

### Frontend Implementation (AzkarDetailScreen)
- Heart icon in the top-right corner
- Visual feedback when toggling favorite status
- Automatic loading of favorite status when viewing azkar
- Error handling with state reversion on failures

## User Experience

### Visual Indicators
- **Unfavorited**: Empty heart icon with category color
- **Favorited**: Filled red heart icon
- **Loading**: Heart icon shows current state while loading

### Interactions
1. **Tap heart icon**: Toggles favorite status
2. **Visual feedback**: Heart fills/empties immediately
3. **Database sync**: Changes are saved to Supabase
4. **Error handling**: Reverts visual state if database operation fails
5. **Toast messages**: Success/error messages in Arabic

### Navigation Between Azkar
- When swiping between azkar in the detail view, the heart icon updates to reflect each azkar's favorite status
- Favorite status is loaded automatically for each azkar

## Anonymous Users
The system supports anonymous users by using a device identifier (`local_device_user`). This allows favorites to persist on the same device even without user authentication.

## Error Handling
- Network errors: Visual state reverts, error message shown
- Database errors: Graceful fallback to unfavorited state
- Loading errors: Defaults to unfavorited state

## Future Enhancements
- Sync favorites across devices when user authentication is implemented
- Bulk favorite/unfavorite operations
- Favorite categories and collections
- Export/import favorites functionality
