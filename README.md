# My League

A Flutter app for managing sports leagues and tournaments. Organize teams, track rosters, record match scores, and monitor player payments — all from your phone.

## Features

- Create leagues with round-robin or single-elimination formats
- Basketball rotation matchmaking built-in
- Team management with color-coded badges and rosters
- Player profiles with jersey number, position, age, phone, and email
- Payment tracking per player with monthly fee support
- Dashboard with global player and finance views
- Password-protected access
- English and Spanish language support
- Dark theme throughout

## Tech Stack

- **Flutter** (Dart) — SDK >=3.4.3
- **Riverpod** — state management
- **Isar** — local database
- **Google Fonts** — typography
- **Shared Preferences** — lightweight persistent settings
- **UUID** — unique ID generation

## Getting Started

### Prerequisites

- Flutter SDK installed ([flutter.dev](https://flutter.dev))
- Android or iOS device/emulator

### Setup

```bash
# Install dependencies
flutter pub get

# Generate Isar schema files
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Project Structure

```
lib/
  main.dart               # App entry point
  models/                 # Data models (League, Team, Player, Match, Payment)
  providers/              # Riverpod state notifiers
  screens/                # All app screens
  theme/                  # App colors and styles
  widgets/                # Reusable UI components
```

## Version

1.0.0
