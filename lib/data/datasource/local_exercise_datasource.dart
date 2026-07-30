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
      // Try loading from Hive cache first
      final box = await Hive.openBox(AppConstants.exerciseBox);
      await box.delete('exercises_data'); // Force clear cache to load fresh JSON
      final cachedData = box.get('exercises_data');

      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData as String);
        _cachedExercises = jsonList
            .map((e) =>
                ExerciseModel.fromCachedJson(e as Map<String, dynamic>))
            .toList();
      } else {
        // Load from bundled asset
        await _loadFromAsset();

        // Cache in Hive for next launch
        if (_cachedExercises != null) {
          final jsonString = jsonEncode(
            _cachedExercises!.map((e) => e.toJson()).toList(),
          );
          await box.put('exercises_data', jsonString);
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

  /// Load exercises from the bundled JSON asset
  Future<void> _loadFromAsset() async {
    final jsonString =
        await rootBundle.loadString(AppConstants.exercisesJsonPath);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    _cachedExercises = jsonList
        .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
