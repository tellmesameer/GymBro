/// App-wide constants for GymBro
class AppConstants {
  AppConstants._();

  // ── GitHub Raw URLs ───────────────────────────────────────────────────────
  static const String githubRawBase =
      'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/';
  static const String imageBaseUrl = '${githubRawBase}images/';
  static const String gifBaseUrl = '${githubRawBase}videos/';

  // ── Asset Paths ───────────────────────────────────────────────────────────
  static const String exercisesJsonPath = 'assets/data/exercises.json';
  static const String bodyFrontSvg = 'assets/svg/body_front.svg';
  static const String bodyBackSvg = 'assets/svg/body_back.svg';

  // ── Hive Boxes ────────────────────────────────────────────────────────────
  static const String exerciseBox = 'exercises';
  static const String favoritesBox = 'favorites';
  static const String recentBox = 'recent';
  static const String workoutsBox = 'workouts';
  static const String settingsBox = 'settings';

  // ── Limits ────────────────────────────────────────────────────────────────
  static const int maxRecentExercises = 20;
  static const int searchDebounceMs = 300;

  // ── Animation Durations ───────────────────────────────────────────────────
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 300);

  // ── Sizing ────────────────────────────────────────────────────────────────
  static const double cardRadius = 16.0;
  static const double cardRadiusSmall = 12.0;
  static const double chipRadius = 20.0;
  static const double bottomNavHeight = 80.0;
  static const double horizontalPadding = 20.0;

  // ── Exercise Stats ────────────────────────────────────────────────────────
  static const int totalExercises = 1324;
  static const int totalTargetMuscles = 50;
  static const int totalEquipment = 40;

  // ── Body Parts ────────────────────────────────────────────────────────────
  static const List<String> bodyParts = [
    'back',
    'cardio',
    'chest',
    'lower arms',
    'lower legs',
    'neck',
    'shoulders',
    'upper arms',
    'upper legs',
    'waist',
  ];

  // ── Equipment Types ───────────────────────────────────────────────────────
  static const List<String> equipmentTypes = [
    'body weight',
    'barbell',
    'dumbbell',
    'cable',
    'leverage machine',
    'band',
    'smith machine',
    'kettlebell',
    'weighted',
    'stability ball',
    'ez barbell',
    'rope',
    'medicine ball',
    'olympic barbell',
    'resistance band',
    'roller',
    'tire',
    'trap bar',
    'upper body ergometer',
    'wheel roller',
  ];

  // ── Body Part Display Names ───────────────────────────────────────────────
  static const Map<String, String> bodyPartDisplayNames = {
    'back': 'Back',
    'cardio': 'Cardio',
    'chest': 'Chest',
    'lower arms': 'Forearms',
    'lower legs': 'Calves',
    'neck': 'Neck',
    'shoulders': 'Shoulders',
    'upper arms': 'Arms',
    'upper legs': 'Legs',
    'waist': 'Core',
  };

  // ── Body Part Icons (Material Icons) ──────────────────────────────────────
  static const Map<String, int> bodyPartIcons = {
    'back': 0xe1c3,       // accessibility_new
    'cardio': 0xe566,      // directions_run
    'chest': 0xe2cc,       // fitness_center
    'lower arms': 0xe53e,  // front_hand
    'lower legs': 0xe566,  // directions_run
    'neck': 0xe7fd,        // person
    'shoulders': 0xe2cc,   // fitness_center
    'upper arms': 0xe2cc,  // fitness_center
    'upper legs': 0xe566,  // directions_run
    'waist': 0xe1c3,       // accessibility_new
  };
}
