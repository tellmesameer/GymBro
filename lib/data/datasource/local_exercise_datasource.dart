import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/exercise_model.dart';
import '../../core/constants/app_constants.dart';

/// Local datasource that loads exercises from bundled JSON asset
/// and caches them in Hive for subsequent fast access.
class LocalExerciseDatasource {
  List<ExerciseModel>? _cachedExercises;
  Map<String, List<ExerciseModel>>? _bodyPartIndex;
  Map<String, List<ExerciseModel>>? _equipmentIndex;
  Map<String, List<ExerciseModel>>? _targetIndex;
  Map<String, int>? _bodyPartCounts;

  bool get isLoaded => _cachedExercises != null;

  List<ExerciseModel> get exercises => _cachedExercises ?? [];

  /// Initialize: try Hive cache first, then fall back to asset JSON
  Future<void> initialize() async {
    if (_cachedExercises != null) return;

    try {
      // Try loading from Hive cache first. Do not clear this during hot reload;
      // only replace it after we have a validated non-empty exercise list.
      final box = await Hive.openBox(AppConstants.exerciseBox);
      final cachedExercises = _readCachedExercises(box.get('exercises_data'));

      if (_hasUsableExercises(cachedExercises)) {
        _cachedExercises = cachedExercises;
      } else {
        // Load from bundled asset when the cache is absent or unusable.
        final assetExercises = await _readExercisesFromAsset();

        if (_hasUsableExercises(assetExercises)) {
          _cachedExercises = assetExercises;
          await _writeCache(box, assetExercises);
        } else if (cachedExercises.isNotEmpty) {
          // Keep the previous cache rather than replacing it with an empty or
          // malformed import. This avoids blank exercise/media states.
          _cachedExercises = cachedExercises;
        } else {
          _cachedExercises = <ExerciseModel>[];
        }
      }

      // Build indexes for fast filtering
      _buildIndexes();
    } catch (e) {
      // If Hive fails, try direct asset load
      await _loadFromAsset();
      _buildIndexes();
    }
  }

  /// Load exercises from the bundled JSON asset.
  Future<void> _loadFromAsset() async {
    _cachedExercises = await _readExercisesFromAsset();
  }

  List<ExerciseModel> _readCachedExercises(Object? cachedData) {
    if (cachedData is! String || cachedData.isEmpty) return <ExerciseModel>[];

    try {
      final decoded = jsonDecode(cachedData);
      if (decoded is! List) return <ExerciseModel>[];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ExerciseModel.fromCachedJson)
          .where(_hasUsableMedia)
          .toList();
    } catch (_) {
      return <ExerciseModel>[];
    }
  }

  Future<List<ExerciseModel>> _readExercisesFromAsset() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.exercisesJsonPath);
    final decoded = jsonDecode(jsonString);
    if (decoded is! List) return <ExerciseModel>[];

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ExerciseModel.fromJson)
        .where(_hasUsableMedia)
        .toList();
  }

  Future<void> _writeCache(Box<dynamic> box, List<ExerciseModel> exercises) {
    final jsonString = jsonEncode(exercises.map((e) => e.toJson()).toList());
    return box.put('exercises_data', jsonString);
  }

  bool _hasUsableExercises(List<ExerciseModel> exercises) {
    return exercises.isNotEmpty && exercises.every(_hasUsableMedia);
  }

  bool _hasUsableMedia(ExerciseModel exercise) {
    return exercise.id.isNotEmpty &&
        exercise.name.isNotEmpty &&
        exercise.imageUrl.isNotEmpty &&
        exercise.gifUrl.isNotEmpty;
  }

  /// Build precomputed indexes for fast filtering
  void _buildIndexes() {
    if (_cachedExercises == null) return;

    _bodyPartIndex = {};
    _equipmentIndex = {};
    _targetIndex = {};
    _bodyPartCounts = {};

    for (final exercise in _cachedExercises!) {
      // Body part index
      _bodyPartIndex!
          .putIfAbsent(exercise.bodyPart, () => [])
          .add(exercise);

      // Equipment index
      _equipmentIndex!
          .putIfAbsent(exercise.equipment, () => [])
          .add(exercise);

      // Target index
      _targetIndex!
          .putIfAbsent(exercise.target, () => [])
          .add(exercise);

      // Body part counts
      _bodyPartCounts![exercise.bodyPart] =
          (_bodyPartCounts![exercise.bodyPart] ?? 0) + 1;
    }
  }

  /// Get all exercises
  List<ExerciseModel> getAllExercises() => _cachedExercises ?? [];

  /// Get exercises by body part (uses precomputed index)
  List<ExerciseModel> getByBodyPart(String bodyPart) {
    return _bodyPartIndex?[bodyPart.toLowerCase()] ?? [];
  }

  /// Get exercises by equipment (uses precomputed index)
  List<ExerciseModel> getByEquipment(String equipment) {
    return _equipmentIndex?[equipment.toLowerCase()] ?? [];
  }

  /// Get exercises by target muscle (uses precomputed index)
  List<ExerciseModel> getByTarget(String target) {
    return _targetIndex?[target.toLowerCase()] ?? [];
  }

  /// Search exercises by query string
  List<ExerciseModel> search(String query) {
    if (query.isEmpty) return _cachedExercises ?? [];
    final lowerQuery = query.toLowerCase();
    return (_cachedExercises ?? [])
        .where((e) => e.searchableText.contains(lowerQuery))
        .toList();
  }

  /// Get exercise by ID
  ExerciseModel? getById(String id) {
    try {
      return _cachedExercises?.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get exercise count per body part
  Map<String, int> getBodyPartCounts() => _bodyPartCounts ?? {};

  /// Clear Hive cache (for re-import)
  Future<void> clearCache() async {
    final box = await Hive.openBox(AppConstants.exerciseBox);
    await box.delete('exercises_data');
    _cachedExercises = null;
    _bodyPartIndex = null;
    _equipmentIndex = null;
    _targetIndex = null;
    _bodyPartCounts = null;
  }
}
