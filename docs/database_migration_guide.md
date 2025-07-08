# Database Schema Migration Guide for Azkar App

This guide explains how to migrate from the existing single `azkar` table to a normalized database structure that supports the three-screen azkar flow: **AzkarScreen** → **AzkarCategoryScreen** → **AzkarDetailScreen**.

## Overview

The new database schema consists of three main tables:
1. `azkar_categories` - Categories of azkar (Morning, Evening, Prayer, etc.)
2. `azkar` - Individual azkar items linked to categories
3. `user_azkar_progress` - User progress tracking for each azkar

## Step-by-Step Migration Process

### Step 1: Create New Database Schema

First, run the schema creation script in your Supabase dashboard:

```sql
-- Execute the contents of scripts/create_azkar_tables.sql
```

This will create:
- ✅ Three normalized tables with proper foreign key relationships
- ✅ Indexes for optimal performance
- ✅ Row Level Security (RLS) policies
- ✅ Triggers for automatic timestamp updates
- ✅ Default azkar categories

### Step 2: Migrate Existing Data

Run the data migration script to transfer your existing azkar data:

```sql
-- Execute the contents of scripts/migrate_azkar_data.sql
```

This will:
- ✅ Extract unique categories from your existing azkar table
- ✅ Create category records with Arabic/English names, icons, and colors
- ✅ Migrate all azkar to the new structure with proper categorization
- ✅ Assign appropriate mood associations based on category

### Step 3: Update Your Flutter App

#### 3.1 Add New Model Classes

Replace your existing azkar models with the new entities:

```dart
// Use: lib/features/azkar/domain/entities/azkar_new.dart
// Contains: AzkarCategory, Azkar, UserAzkarProgress
```

#### 3.2 Update Supabase Service

Replace your existing service with the new azkar service:

```dart
// Use: lib/features/azkar/data/services/azkar_supabase_service.dart
// Provides methods for categories, azkar, and progress tracking
```

#### 3.3 Add New Screen Components

Add the three new screen files to your presentation layer:

```dart
// 1. lib/features/azkar/presentation/pages/azkar_categories_screen.dart
//    - Shows all azkar categories in a beautiful grid
//    - Handles loading states, errors, and empty states
//    - Supports pull-to-refresh

// 2. lib/features/azkar/presentation/pages/azkar_category_screen.dart
//    - Shows azkar within a selected category
//    - Preview cards with Arabic text and metadata
//    - Copy and share functionality

// 3. lib/features/azkar/presentation/pages/azkar_detail_screen.dart
//    - Full azkar view with counter and progress tracking
//    - Beautiful typography and animations
//    - Progress persistence to database
```

## Screen Flow Architecture

```
┌─────────────────────┐
│   AzkarScreen       │ ← Main entry point
│   (Categories)      │   Shows all categories
└─────────┬───────────┘
          │ User taps category
          ▼
┌─────────────────────┐
│ AzkarCategoryScreen │ ← Category details
│ (List of Azkar)     │   Shows azkar in category
└─────────┬───────────┘
          │ User taps azkar
          ▼
┌─────────────────────┐
│ AzkarDetailScreen   │ ← Individual azkar
│ (Full Azkar View)   │   Counter & progress
└─────────────────────┘
```

## Database Schema Details

### azkar_categories Table
```sql
- id (UUID) - Primary key
- name_ar (TEXT) - Arabic name
- name_en (TEXT) - English name
- description (TEXT) - Category description
- icon (TEXT) - Icon identifier
- color (TEXT) - Hex color code
- order_index (INTEGER) - Display order
- is_active (BOOLEAN) - Active status
- created_at (TIMESTAMP) - Creation time
- updated_at (TIMESTAMP) - Last update
```

### azkar Table
```sql
- id (UUID) - Primary key
- category_id (UUID) - Foreign key to azkar_categories
- text_ar (TEXT) - Arabic text
- text_en (TEXT) - English text (optional)
- transliteration (TEXT) - Phonetic spelling
- translation (TEXT) - Translation
- reference (TEXT) - Source reference
- description (TEXT) - Description
- repeat_count (INTEGER) - Number of repetitions
- order_index (INTEGER) - Order within category
- associated_moods (TEXT[]) - Array of mood associations
- search_tags (TEXT) - Search keywords
- is_active (BOOLEAN) - Active status
- created_at (TIMESTAMP) - Creation time
- updated_at (TIMESTAMP) - Last update
```

### user_azkar_progress Table
```sql
- id (UUID) - Primary key
- user_id (UUID) - User identifier (nullable for anonymous)
- azkar_id (UUID) - Foreign key to azkar
- completed_count (INTEGER) - Current completion count
- total_count (INTEGER) - Total required count
- last_completed_at (TIMESTAMP) - Last completion time
- streak_count (INTEGER) - Consecutive completion streak
- created_at (TIMESTAMP) - Creation time
- updated_at (TIMESTAMP) - Last update
```

## Features of the New System

### 🎨 Beautiful UI Components
- Animated category cards with gradient backgrounds
- Smooth transitions between screens
- Progress indicators with circular progress rings
- Haptic feedback for interactions

### 📊 Progress Tracking
- Individual azkar completion counters
- Streak tracking for consecutive completions
- Progress persistence across sessions
- Visual progress indicators

### 🔍 Enhanced Functionality
- Category-based organization
- Mood-based azkar filtering
- Copy and share functionality
- Search capabilities
- Offline support preparation

### 🌐 Internationalization Ready
- Arabic and English support
- RTL text direction handling
- Localized number formatting
- Cultural-appropriate animations

## Migration Checklist

- [ ] **Step 1**: Execute `create_azkar_tables.sql` in Supabase
- [ ] **Step 2**: Execute `migrate_azkar_data.sql` in Supabase
- [ ] **Step 3**: Verify data migration in Supabase dashboard
- [ ] **Step 4**: Add new model files to Flutter project
- [ ] **Step 5**: Add new service file to Flutter project
- [ ] **Step 6**: Add new screen files to Flutter project
- [ ] **Step 7**: Update routing to use new screens
- [ ] **Step 8**: Test all three screens
- [ ] **Step 9**: Test progress tracking
- [ ] **Step 10**: Test error handling and loading states

## Example Usage

```dart
// Navigate to azkar categories
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AzkarScreen(),
  ),
);

// Or integrate into your existing navigation
context.go('/azkar');
```

## Performance Considerations

The new schema includes optimized indexes:
- Category ordering index
- Azkar category and ordering indexes
- User progress indexes
- Full-text search indexes for Arabic content

## Security

Row Level Security (RLS) is enabled with policies:
- Public read access for azkar and categories
- User-specific access for progress tracking
- Anonymous user support for progress tracking

## Support

If you encounter any issues during migration:
1. Check Supabase logs for database errors
2. Verify all foreign key relationships
3. Ensure RLS policies are correctly applied
4. Test with sample data before full migration

The new system provides a much more robust foundation for azkar functionality while maintaining the spiritual focus and beautiful user experience of your app.
