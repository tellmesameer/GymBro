# GymBro

A beautifully designed, OLED-optimized Flutter application for tracking workouts and browsing a massive database of exercises.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK

### Installation and Setup

1. **Get dependencies:**
   ```bash
   flutter pub get
   ```

2. **Download and Process the Dataset:**
   The app relies on an exercise dataset to function. Run the provided script to download and parse it:
   ```bash
   dart run scripts/download_exercises.dart
   ```
   *This script downloads the `exercises.json` dataset from GitHub, extracts English instructions to reduce file size, and saves it to `assets/data/exercises.json`.*

3. **Run the app:**
   ```bash
   flutter run
   ```

## 📁 File Structure

The project follows a feature-first and layered architecture:

```text
lib/
├── core/                   # Core functionality (theme, colors, constants, reusable widgets)
├── data/                   # Data layer
│   ├── datasource/         # Hive local storage implementations
│   ├── models/             # Data models (ExerciseModel, WorkoutModel)
│   └── repository/         # Repositories for data access
├── domain/                 # Domain logic (interfaces, entities)
├── presentation/           # UI Layer (Screens, Widgets, Providers)
│   ├── exercise_details/   # Exercise details screen
│   ├── exercise_list/      # List of exercises by category
│   ├── favorites/          # User's favorite exercises
│   ├── filters/            # Search & filtering UI
│   ├── home/               # Dashboard and statistics
│   ├── muscles/            # Interactive muscle SVG map
│   ├── providers/          # Riverpod state management
│   ├── settings/           # App settings and profile
│   ├── splash/             # Splash screen and initialization
│   └── workout/            # Workout routines and details
└── main.dart               # Application entry point

scripts/
└── download_exercises.dart # Script to download the exercise dataset
```

## 🗄️ Schema Definitions

The application primarily operates on two core data models, which are cached locally using Hive:

### ExerciseModel
Represents a single exercise from the dataset.

- `id`: Unique identifier (String)
- `name`: Exercise name (String)
- `category`: Category (e.g., strength, stretching) (String)
- `bodyPart`: Main body part (e.g., chest, back) (String)
- `equipment`: Required equipment (e.g., barbell, body weight) (String)
- `target`: Specific target muscle (String)
- `muscleGroup`: Broader muscle group (String)
- `secondaryMuscles`: List of secondary muscles engaged (List<String>)
- `instructions`: Step-by-step instructions (List<String>)
- `imageUrl`: URL to a static image of the exercise (String)
- `gifUrl`: URL to an animated GIF demonstrating the exercise (String)
- `mediaId`: Identifier for the media files (String)

### WorkoutModel
Represents a customized workout routine.

- `id`: Unique identifier (String)
- `name`: Name of the workout (String)
- `emoji`: Visual identifier/icon (String)
- `exercises`: List of `WorkoutExercise` objects comprising the workout (List<WorkoutExercise>)
- `createdAt`: Date the workout was created (DateTime)
- `lastPerformedAt`: Date the workout was last performed (DateTime?)

#### WorkoutExercise
A single exercise entry within a `WorkoutModel`.

- `exerciseId`: ID linking to the base `ExerciseModel` (String)
- `exerciseName`: Cached name of the exercise (String)
- `sets`: Number of sets (int, default: 3)
- `reps`: Number of reps or string representation (e.g., "8-10" or "AMRAP") (String, default: '10')
- `weight`: Weight used (double?)
- `restSeconds`: Rest time between sets in seconds (int, default: 90)