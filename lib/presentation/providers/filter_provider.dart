import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/exercise_model.dart';
import 'exercise_providers.dart';

/// Active filter state for the exercise list
class ExerciseFilters {
  final String? equipment;
  final String? difficulty;
  final String? goal;
  final String? bodyPart;

  const ExerciseFilters({
    this.equipment,
    this.difficulty,
    this.goal,
    this.bodyPart,
  });

  ExerciseFilters copyWith({
    String? equipment,
    String? difficulty,
    String? goal,
    String? bodyPart,
    bool clearEquipment = false,
    bool clearDifficulty = false,
    bool clearGoal = false,
    bool clearBodyPart = false,
  }) {
    return ExerciseFilters(
      equipment: clearEquipment ? null : (equipment ?? this.equipment),
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
      goal: clearGoal ? null : (goal ?? this.goal),
      bodyPart: clearBodyPart ? null : (bodyPart ?? this.bodyPart),
    );
  }

  bool get hasActiveFilters =>
      equipment != null ||
      difficulty != null ||
      goal != null;

  ExerciseFilters reset() => const ExerciseFilters();

  int get activeFilterCount {
    int count = 0;
    if (equipment != null) count++;
    if (difficulty != null) count++;
    if (goal != null) count++;
    return count;
  }
}

// ── Filter State ──────────────────────────────────────────────────────────
final filterProvider =
    StateNotifierProvider<FilterNotifier, ExerciseFilters>((ref) {
  return FilterNotifier();
});

class FilterNotifier extends StateNotifier<ExerciseFilters> {
  FilterNotifier() : super(const ExerciseFilters());

  void setEquipment(String? equipment) {
    state = state.copyWith(
      equipment: equipment,
      clearEquipment: equipment == null,
    );
  }

  void setDifficulty(String? difficulty) {
    state = state.copyWith(
      difficulty: difficulty,
      clearDifficulty: difficulty == null,
    );
  }

  void setGoal(String? goal) {
    state = state.copyWith(
      goal: goal,
      clearGoal: goal == null,
    );
  }

  void setBodyPart(String? bodyPart) {
    state = state.copyWith(
      bodyPart: bodyPart,
      clearBodyPart: bodyPart == null,
    );
  }

  void reset() {
    state = const ExerciseFilters();
  }
}

// ── Filtered Exercises ────────────────────────────────────────────────────
final filteredExercisesProvider = FutureProvider.family<List<ExerciseModel>, String>(
    (ref, bodyPart) async {
  final filters = ref.watch(filterProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final repo = ref.read(exerciseRepositoryProvider);

  // Start with body part filter
  List<ExerciseModel> exercises;
  if (bodyPart.isNotEmpty) {
    exercises = await repo.getExercisesByBodyPart(bodyPart);
  } else {
    exercises = await repo.getAllExercises();
  }

  // Apply search filter
  if (searchQuery.isNotEmpty) {
    final lowerQuery = searchQuery.toLowerCase();
    exercises = exercises
        .where((e) => e.searchableText.contains(lowerQuery))
        .toList();
  }

  // Apply equipment filter
  if (filters.equipment != null) {
    exercises = exercises
        .where((e) => e.equipment == filters.equipment!.toLowerCase())
        .toList();
  }

  // Apply difficulty filter
  if (filters.difficulty != null) {
    exercises = exercises
        .where((e) => e.difficulty == filters.difficulty)
        .toList();
  }

  return exercises;
});
