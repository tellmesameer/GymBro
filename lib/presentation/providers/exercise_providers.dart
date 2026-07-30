import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/local_exercise_datasource.dart';
import '../../data/models/exercise_model.dart';
import '../../data/repository/exercise_repository_impl.dart';
import '../../domain/repository/exercise_repository.dart';

// ── Datasource ────────────────────────────────────────────────────────────
final localDatasourceProvider = Provider<LocalExerciseDatasource>((ref) {
  return LocalExerciseDatasource();
});

// ── Repository ────────────────────────────────────────────────────────────
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepositoryImpl(ref.read(localDatasourceProvider));
});

// ── All Exercises ─────────────────────────────────────────────────────────
final allExercisesProvider =
    FutureProvider<List<ExerciseModel>>((ref) async {
  final repo = ref.read(exerciseRepositoryProvider);
  return repo.getAllExercises();
});

// ── Exercises by Body Part ────────────────────────────────────────────────
final exercisesByBodyPartProvider =
    FutureProvider.family<List<ExerciseModel>, String>((ref, bodyPart) async {
  final repo = ref.read(exerciseRepositoryProvider);
  return repo.getExercisesByBodyPart(bodyPart);
});

// ── Exercise by ID ────────────────────────────────────────────────────────
final exerciseByIdProvider =
    FutureProvider.family<ExerciseModel?, String>((ref, id) async {
  final repo = ref.read(exerciseRepositoryProvider);
  return repo.getExerciseById(id);
});

// ── Search ────────────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider<List<ExerciseModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.read(exerciseRepositoryProvider);
  return repo.searchExercises(query);
});

// ── Body Part Exercise Counts ─────────────────────────────────────────────
final bodyPartCountsProvider = Provider<Map<String, int>>((ref) {
  final repo = ref.read(exerciseRepositoryProvider);
  return repo.getExerciseCountByBodyPart();
});

// ── Initialization ────────────────────────────────────────────────────────
final initializationProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(exerciseRepositoryProvider);
  await repo.initialize();
});
