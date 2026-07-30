import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/workout_model.dart';
import '../../data/repository/workout_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository();
});

// ── Workout List State ────────────────────────────────────────────────────
final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, List<WorkoutModel>>((ref) {
  return WorkoutNotifier(ref.read(workoutRepositoryProvider));
});

class WorkoutNotifier extends StateNotifier<List<WorkoutModel>> {
  final WorkoutRepository _repo;
  static const _uuid = Uuid();

  WorkoutNotifier(this._repo) : super([]);

  Future<void> initialize() async {
    await _repo.initialize();
    state = List<WorkoutModel>.from(_repo.workouts);
  }

  Future<WorkoutModel> createWorkout({
    required String name,
    String emoji = '💪',
  }) async {
    final workout = WorkoutModel(
      id: _uuid.v4(),
      name: name,
      emoji: emoji,
      exercises: [],
      createdAt: DateTime.now(),
    );
    await _repo.addWorkout(workout);
    state = List<WorkoutModel>.from(_repo.workouts);
    return workout;
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    await _repo.updateWorkout(workout);
    state = List<WorkoutModel>.from(_repo.workouts);
  }

  Future<void> deleteWorkout(String id) async {
    await _repo.deleteWorkout(id);
    state = List<WorkoutModel>.from(_repo.workouts);
  }

  Future<void> addExerciseToWorkout(
    String workoutId,
    WorkoutExercise exercise,
  ) async {
    final workout = _repo.getWorkoutById(workoutId);
    if (workout == null) return;

    final updated = workout.copyWith(
      exercises: [...workout.exercises, exercise],
    );
    await _repo.updateWorkout(updated);
    state = List<WorkoutModel>.from(_repo.workouts);
  }

  Future<void> removeExerciseFromWorkout(
    String workoutId,
    int index,
  ) async {
    final workout = _repo.getWorkoutById(workoutId);
    if (workout == null) return;

    final exercises = List<WorkoutExercise>.from(workout.exercises);
    exercises.removeAt(index);
    final updated = workout.copyWith(exercises: exercises);
    await _repo.updateWorkout(updated);
    state = List<WorkoutModel>.from(_repo.workouts);
  }

  Future<void> reorderExercises(
    String workoutId,
    int oldIndex,
    int newIndex,
  ) async {
    if (newIndex > oldIndex) newIndex--;
    await _repo.reorderExercises(workoutId, oldIndex, newIndex);
    state = List<WorkoutModel>.from(_repo.workouts);
  }

  WorkoutModel? getWorkoutById(String id) => _repo.getWorkoutById(id);
}

// ── Single Workout Provider ───────────────────────────────────────────────
final workoutByIdProvider =
    Provider.family<WorkoutModel?, String>((ref, id) {
  final workouts = ref.watch(workoutProvider);
  try {
    return workouts.firstWhere((w) => w.id == id);
  } catch (_) {
    return null;
  }
});
