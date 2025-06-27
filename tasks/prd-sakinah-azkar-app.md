# Product Requirements Document: Sakīnah - Emotionally Intelligent Azkar App

## Introduction/Overview

Sakīnah is a Flutter-based Islamic spiritual companion app that provides emotionally intelligent azkar suggestions, helping users maintain consistent dhikr habits through personalized, beautiful, and meaningful spiritual experiences. Unlike basic azkar apps, Sakīnah focuses on the personal touch and emotional connection, adapting to users' feelings and spiritual needs while maintaining a minimalist, pastel, and glassy UI design.

**Problem Statement:** Most existing azkar apps feel impersonal and robotic, failing to help users maintain consistent spiritual habits or provide emotional support through Islamic practices.

**Goal:** Create a spiritually enriching app that understands users' emotional states and provides personalized azkar recommendations while fostering consistent dhikr habits through beautiful design and meaningful interactions.

## Goals

1. **Primary Goal:** Help users maintain consistent dhikr habits through personalized, emotion-based azkar suggestions
2. **Secondary Goal:** Provide emotional and spiritual support through adaptive Islamic practices
3. **Engagement Goal:** Achieve high daily active user rates and long-term retention through meaningful spiritual connections
4. **Experience Goal:** Deliver a beautiful, minimalist, and emotionally resonant user experience

## User Stories

**As a Muslim seeking spiritual connection:**
- I want to receive azkar suggestions based on how I'm feeling so that my spiritual practice feels personal and relevant
- I want to easily access azkar throughout my day so that I can maintain consistent spiritual habits
- I want to track my spiritual progress so that I feel motivated to continue my dhikr practice

**As a busy professional:**
- I want quick access to azkar through widgets so that I can practice dhikr without interrupting my workflow
- I want gentle reminders and motivation so that I don't feel guilty about missed sessions

**As someone learning about Islam:**
- I want to read and listen to Quran alongside azkar so that I can deepen my understanding
- I want offline access to spiritual content so that I can practice anywhere

## Functional Requirements

### Core Features (Priority 1)

1. **Emotion-Based Azkar Suggestions**
   - The system must present mood selection interface with simple emotional states (happy, sad, anxious, grateful, stressed, peaceful, etc.)
   - The system must provide curated azkar recommendations based on selected emotional state
   - The system must use emoji and intuitive icons for mood selection
   - The system must store user's mood patterns for insights

2. **Streaks and Daily Motivation**
   - The system must track daily azkar completion streaks
   - The system must display motivational messages and progress indicators
   - The system must send encouraging notifications without guilt-inducing language
   - The system must show weekly and monthly spiritual progress summaries

3. **Widget and Quick Access**
   - The system must provide home screen widget for instant azkar access
   - The system must send smart, contextual notifications (e.g., "🌄 It's Fajr time. Let's say 3 simple azkar together")
   - The system must enable one-tap azkar initiation from notifications

### Essential Features (Priority 2)

4. **Voice Mode and Audio Experience**
   - The system must play azkar in soft, beautiful recitation
   - The system must offer multiple qualified reciters
   - The system must provide optional background nature sounds (birds, water, wind)
   - The system must support offline audio playback
   - The system must allow background audio while using other apps

5. **Progress Tracker and Spiritual Journal**
   - The system must ask "How do you feel now?" after completing azkar
   - The system must store personal reflections locally and privately
   - The system must show previous spiritual insights and growth patterns
   - The system must provide weekly spiritual reflection summaries

6. **Quran Integration Module**
   - The system must provide Quran reading interface with beautiful Arabic typography
   - The system must offer Quran audio with multiple reciters
   - The system must support offline Quran access
   - The system must connect relevant Quran verses with specific azkar

### Customization Features (Priority 3)

7. **Moderate Personalization**
   - The system must allow users to create custom azkar sets ("Before Exam", "When Anxious")
   - The system must enable personal goal setting for dhikr frequency
   - The system must provide theme customization with pastel color options
   - The system must allow notification timing personalization

8. **Design and User Experience**
   - The system must implement minimalist, pastel color scheme with glassy UI elements
   - The system must use beautiful Arabic calligraphy (Amiri font or similar)
   - The system must follow thumb zone design principles for easy one-handed use
   - The system must provide smooth animations and transitions
   - The system must support both Arabic and English interfaces

## Non-Goals (Out of Scope)

1. **Social Features:** No public sharing, social media integration, or community features
2. **Complex AI:** No advanced machine learning or AI-based mood detection
3. **Extensive Islamic Library:** Focus on azkar and Quran only, not hadith collections or Islamic education
4. **Multi-language Support:** Initially only Arabic and English
5. **Complex Analytics:** No detailed behavioral analytics or data collection beyond basic usage patterns
6. **Payment Features:** Free app without premium subscriptions or in-app purchases

## Design Considerations

### Visual Design
- **Color Palette:** Soft pastels (sage green, dusty rose, cream, lavender) with glassy transparency effects
- **Typography:** Beautiful Arabic calligraphy (Amiri) paired with clean sans-serif for English (SF Pro/Roboto)
- **UI Style:** Minimalist with generous white space, subtle shadows, and glassy blur effects
- **Icons:** Soft, rounded icons with subtle gradients

### UX Principles
- **Thumb Zone Optimization:** Primary actions positioned in easy-reach green zone
- **One-Handed Use:** All essential features accessible with thumb
- **Gentle Interactions:** Smooth animations, soft haptic feedback
- **Emotional Design:** Every interaction should feel calm and spiritually uplifting

### Components
- **Mood Selection Cards:** Beautiful, large touch targets with emoji and gradient backgrounds
- **Azkar Display:** Clean, readable Arabic text with translation and transliteration options
- **Progress Rings:** Soft, animated progress indicators for streaks and daily goals
- **Audio Player:** Minimalist controls with beautiful waveform visualization

## Technical Considerations

### Architecture
- **Framework:** Flutter for cross-platform development
- **Architecture Pattern:** Clean Architecture (Domain, Data, Presentation layers)
- **State Management:** Bloc/Cubit for predictable state management
- **Backend:** Supabase for real-time data, authentication, and cloud storage

### Data Storage
- **Local Storage:** Hive for offline azkar, audio files, and user preferences
- **Cloud Sync:** Supabase for progress tracking and custom azkar sets
- **Audio Storage:** Local audio files for offline capability, cloud backup for sync

### Performance Requirements
- **Offline Capability:** Core azkar and Quran content must work without internet
- **Audio Performance:** Smooth audio playback with background support
- **Launch Time:** App should launch within 2 seconds
- **Widget Response:** Home screen widget must respond instantly

### Dependencies
- **Audio:** flutter_sound or audioplayers for audio playback
- **Local Storage:** hive for offline data storage
- **UI Components:** Custom glassy components with backdrop_filter
- **Arabic Text:** proper Arabic text rendering and RTL support

## Success Metrics

### Primary Metrics (Daily Active Users Focus)
1. **Daily Active Users (DAU):** Target 70% retention rate after 7 days
2. **Weekly Active Users (WAU):** Target 50% retention rate after 30 days
3. **Monthly Active Users (MAU):** Target 30% retention rate after 90 days

### Engagement Metrics
4. **Average Session Duration:** Target 3-5 minutes per session
5. **Daily Azkar Completion Rate:** Target 60% of users completing at least one azkar set daily
6. **Streak Length:** Target average streak length of 7 days
7. **Widget Usage:** Target 40% of users actively using home screen widget

### Feature-Specific Metrics
8. **Mood Selection Usage:** Track which emotions are most commonly selected
9. **Audio Feature Adoption:** Measure percentage of users who use voice mode
10. **Custom Azkar Creation:** Track how many users create personal azkar sets

## Open Questions

1. **Reciter Selection:** Which qualified Quran reciters should we partner with for audio content?
2. **Content Curation:** How will we ensure azkar recommendations for each emotional state are islamically authentic?
3. **Notification Timing:** What's the optimal notification strategy to encourage without overwhelming?
4. **Accessibility:** What additional accessibility features should we implement for users with visual or hearing impairments?
5. **Localization:** Should we plan for additional languages (Urdu, Turkish, Indonesian) in future versions?
6. **Content Updates:** How will we handle updates to azkar content and add new spiritual content over time?
7. **User Onboarding:** What's the best way to introduce users to emotion-based azkar selection?
8. **Data Privacy:** What minimal data collection is needed for progress tracking while respecting user privacy?

## Implementation Phases

### Phase 1 (MVP - 3 months)
- Basic emotion-based azkar suggestions
- Core azkar library with offline support
- Simple progress tracking and streaks
- Minimalist UI with pastel design

### Phase 2 (Enhanced Features - 2 months)
- Audio recitation and voice mode
- Home screen widget
- Basic Quran reading module
- Advanced progress tracking with reflections

### Phase 3 (Polish & Launch - 1 month)
- Custom azkar sets
- Refined animations and micro-interactions
- Comprehensive testing and optimization
- App store submission and launch preparation

---

*This PRD is designed to guide development of Sakīnah, an emotionally intelligent azkar app that prioritizes personal connection, spiritual growth, and beautiful user experience. The focus remains on helping users maintain consistent dhikr habits through meaningful, personalized spiritual interactions.*
