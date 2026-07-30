import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/recent_repository.dart';
import '../../data/models/exercise_model.dart';
import 'exercise_providers.dart';

// ── Repository ────────────────────────────────────────────────────────────
final recentRepositoryProvider = Provider<RecentRepository>((ref) {
  return RecentRepository();
});

// ── Recent IDs State ──────────────────────────────────────────────────────
final recentProvider =
    StateNotifierProvider<RecentNotifier, List<String>>((ref) {
  return RecentNotifier(ref.read(recentRepositoryProvider));
});

class RecentNotifier extends StateNotifier<List<String>> {
  final RecentRepository _repo;

  RecentNotifier(this._repo) : super([]);

  Future<void> initialize() async {
    await _repo.initialize();
    state = List<String>.from(_repo.recentIds);
  }

  Future<void> addRecent(String exerciseId) async {
    await _repo.addRecent(exerciseId);
    state = List<String>.from(_repo.recentIds);
  }

  Future<void> clear() async {
    await _repo.clearRecent();
    state = [];
  }
}

// ── Recent Exercises (resolved models) ────────────────────────────────────
final recentExercisesProvider =
    FutureProvider<List<ExerciseModel>>((ref) async {
  final recentIds = ref.watch(recentProvider);
  final repo = ref.read(exerciseRepositoryProvider);

  final exercises = <ExerciseModel>[];
  for (final id in recentIds) {
    final exercise = await repo.getExerciseById(id);
    if (exercise != null) {
      exercises.add(exercise);
    }
  }
  return exercises;
});
