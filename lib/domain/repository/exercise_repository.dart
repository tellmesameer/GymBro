import '../../data/models/exercise_model.dart';

/// Abstract repository interface for exercise data access.
abstract class ExerciseRepository {
  /// Get all exercises from the local database
  Future<List<ExerciseModel>> getAllExercises();

  /// Get exercises filtered by body part
  Future<List<ExerciseModel>> getExercisesByBodyPart(String bodyPart);

  /// Get exercises filtered by equipment type
  Future<List<ExerciseModel>> getExercisesByEquipment(String equipment);

  /// Get exercises filtered by target muscle
  Future<List<ExerciseModel>> getExercisesByTarget(String target);

  /// Search exercises by name, equipment, or target
  Future<List<ExerciseModel>> searchExercises(String query);

  /// Get a single exercise by ID
  Future<ExerciseModel?> getExerciseById(String id);

  /// Get exercise count by body part
  Map<String, int> getExerciseCountByBodyPart();

  /// Check if data is loaded
  bool get isLoaded;

  /// Initialize and load data
  Future<void> initialize();
}
