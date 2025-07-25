## Relevant Files

- `lib/main.dart` - Main app entry point with theme configuration and routing setup.
- `lib/core/theme/app_theme.dart` - App-wide theme with pastel colors and glassy UI styling.
- `lib/core/theme/app_colors.dart` - Color palette definitions (sage green, dusty rose, cream, lavender).
- `lib/core/theme/app_typography.dart` - Typography configuration with Amiri font for Arabic and font fallbacks.
- `lib/core/router/app_router.dart` - GoRouter configuration with comprehensive routing setup.
- `lib/core/router/app_routes.dart` - Route names and parameters definitions.
- `lib/l10n/app_localizations.dart` - Generated localization class for i18n support.
- `lib/l10n/app_en.arb` - English translation strings.
- `lib/l10n/app_ar.arb` - Arabic translation strings.
- `l10n.yaml` - Localization configuration file.
- `lib/features/mood/presentation/pages/mood_selection_page.dart` - Main mood selection interface.
- `lib/features/mood/presentation/widgets/mood_card.dart` - Individual mood selection cards with emoji and gradients.
- `lib/features/mood/domain/entities/mood.dart` - Mood entity model.
- `lib/features/mood/data/repositories/mood_repository_impl.dart` - Mood data repository implementation.
- `lib/features/azkar/presentation/pages/azkar_display_page.dart` - Azkar display interface with Arabic text.
- `lib/features/azkar/presentation/widgets/azkar_card.dart` - Individual azkar display component.
- `lib/features/azkar/domain/entities/azkar.dart` - Azkar entity model.
- `lib/features/azkar/data/repositories/azkar_repository_impl.dart` - Azkar data repository implementation.
- `lib/features/progress/presentation/pages/progress_page.dart` - Streak tracking and progress visualization.
- `lib/features/progress/presentation/widgets/streak_counter.dart` - Animated streak counter component.
- `lib/features/progress/domain/entities/user_progress.dart` - User progress entity model.
- `lib/core/database/drift_service.dart` - Local storage service using Drift.
- `lib/core/database/database.dart` - Drift database configuration and table definitions.
- `lib/core/database/database.g.dart` - Generated Drift database code.
- `lib/core/network/supabase_service.dart` - Supabase backend service configuration.
- `lib/shared/widgets/glassy_container.dart` - Reusable glassy UI container component.
- `lib/shared/widgets/custom_button.dart` - Custom button with pastel styling.
- `assets/fonts/Amiri-Regular.ttf` - Arabic calligraphy font file.
- `assets/fonts/Amiri-Bold.ttf` - Arabic calligraphy font file (bold).
- `assets/data/azkar_database.json` - Local azkar data with emotional mappings.

### Notes

- Follow Clean Architecture pattern with clear separation between presentation, domain, and data layers.
- Use Bloc/Cubit for state management across features.
- Implement offline-first approach with Drift for local storage and Supabase for cloud sync.
- Focus on thumb zone optimization for one-handed use.
- All Arabic text should support RTL layout and use Amiri font.

## Tasks

- [x] 1.0 Setup Project Architecture and Core Infrastructure
  - [x] 1.1 Configure Flutter project with Clean Architecture folder structure (lib/core, lib/features, lib/shared)
  - [x] 1.2 Add dependencies to pubspec.yaml (flutter_bloc, drift, drift_flutter, supabase_flutter, audioplayers, backdrop_filter)
  - [x] 1.3 Initialize Drift database with table definitions and create DAOs for local storage
  - [x] 1.4 Setup Supabase client configuration and environment variables
  - [x] 1.5 Create base repository interfaces and dependency injection setup
  - [x] 1.6 Configure app routing with go_router for navigation
  - [x] 1.7 Setup localization support for Arabic and English (flutter_localizations)
  - [x] 1.8 Add Amiri font to assets and configure font fallbacks

- [x] 2.0 Implement Emotion-Based Mood Selection System
  - [x] 2.1 Create Mood entity with emotional states (happy, sad, anxious, grateful, stressed, peaceful)
  - [x] 2.2 Design mood selection UI with large touch targets and emoji icons
  - [x] 2.3 Implement MoodBloc for state management of mood selection
  - [x] 2.4 Create mood repository for storing and retrieving mood patterns
  - [x] 2.5 Build mood selection cards with gradient backgrounds and animations
  - [x] 2.6 Add haptic feedback and smooth transitions for mood selection
  - [x] 2.7 Implement mood history tracking and analytics using Drift database
  - [x] 2.8 Create mood-to-azkar mapping system for recommendations

- [x] 3.0 Create Azkar Display and Recommendation Engine
  - [x] 3.1 Create Azkar entity model with Arabic text, translation, and transliteration
  - [x] 3.2 Build local azkar database (JSON) with emotional state mappings
  - [x] 3.3 Implement AzkarRepository for CRUD operations and mood-based filtering
  - [x] 3.4 Create AzkarBloc for managing azkar state and recommendations
  - [x] 3.5 Design azkar display UI with beautiful Arabic typography (Amiri font)
  - [x] 3.6 Implement azkar card component with RTL support and clean layout
  - [x] 3.7 Add azkar completion tracking and "mark as completed" functionality
  - [x] 3.8 Create recommendation algorithm based on user's selected mood
  - [x] 3.9 Implement azkar search and filtering capabilities

- [x] 4.0 Build Progress Tracking and Streak System
  - [x] 4.1 Create UserProgress entity for tracking daily streaks and completion rates
  - [x] 4.2 Implement ProgressRepository with Drift local storage and Supabase cloud backup
  - [x] 4.3 Build ProgressBloc for managing streak calculations and progress updates
  - [x] 4.4 Design progress visualization with animated rings and streak counters
  - [x] 4.5 Create daily goal setting and tracking functionality
  - [x] 4.6 Implement motivational messages system (positive, non-guilt-inducing)
  - [x] 4.7 Build weekly and monthly progress summary views
  - [x] 4.8 Add progress sharing capabilities (local screenshots only)
  - [x] 4.9 Create streak milestone celebrations and achievements

- [x] 5.0 Design and Implement Glassy UI Components and Theme
  - [x] 5.1 Create AppTheme with pastel color palette (sage green, dusty rose, cream, lavender)
  - [x] 5.2 Implement GlassyContainer widget with backdrop_filter and blur effects
  - [x] 5.3 Design custom buttons with soft gradients and rounded corners
  - [x] 5.4 Create animated progress indicators and loading states
  - [x] 5.5 Implement thumb zone optimization for all interactive elements
  - [x] 5.6 Build responsive layout system for different screen sizes
  - [x] 5.7 Add smooth page transitions and micro-interactions
  - [x] 5.8 Create consistent spacing and typography scale
  - [x] 5.9 Implement dark/light theme variants with glassy effects
  - [x] 5.10 Add subtle shadows and elevation for depth perception
