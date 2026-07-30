import '../models/exercise_model.dart';
import '../datasource/local_exercise_datasource.dart';
import '../../domain/repository/exercise_repository.dart';

/// Concrete implementation of [ExerciseRepository] using local datasource
class ExerciseRepositoryImpl implements ExerciseRepository {
  final LocalExerciseDatasource _datasource;

  ExerciseRepositoryImpl(this._datasource);

  @override
  bool get isLoaded => _datasource.isLoaded;

  @override
  Future<void> initialize() => _datasource.initialize();

  @override
  Future<List<ExerciseModel>> getAllExercises() async {
    return _datasource.getAllExercises();
  }

  @override
  Future<List<ExerciseModel>> getExercisesByBodyPart(String bodyPart) async {
    return _datasource.getByBodyPart(bodyPart);
  }

  @override
  Future<List<ExerciseModel>> getExercisesByEquipment(String equipment) async {
    return _datasource.getByEquipment(equipment);
  }

  @override
  Future<List<ExerciseModel>> getExercisesByTarget(String target) async {
    return _datasource.getByTarget(target);
  }

  @override
  Future<List<ExerciseModel>> searchExercises(String query) async {
    return _datasource.search(query);
  }

  @override
  Future<ExerciseModel?> getExerciseById(String id) async {
    return _datasource.getById(id);
  }

  @override
  Map<String, int> getExerciseCountByBodyPart() {
    return _datasource.getBodyPartCounts();
  }
}
