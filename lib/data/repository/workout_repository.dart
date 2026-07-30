import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/workout_model.dart';

/// Repository for managing workout routines using Hive
class WorkoutRepository {
  Box? _box;
  List<WorkoutModel> _workouts = [];

  List<WorkoutModel> get workouts => List.unmodifiable(_workouts);

  Future<void> initialize() async {
    _box = await Hive.openBox(AppConstants.workoutsBox);
    final stored = _box?.get('workouts_data');
    if (stored != null) {
      final List<dynamic> jsonList = jsonDecode(stored as String);
      _workouts = jsonList
          .map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> addWorkout(WorkoutModel workout) async {
    _workouts.add(workout);
    await _save();
  }

  Future<void> updateWorkout(WorkoutModel workout) async {
    final index = _workouts.indexWhere((w) => w.id == workout.id);
    if (index >= 0) {
      _workouts[index] = workout;
      await _save();
    }
  }

  Future<void> deleteWorkout(String id) async {
    _workouts.removeWhere((w) => w.id == id);
    await _save();
  }

  WorkoutModel? getWorkoutById(String id) {
    try {
      return _workouts.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> reorderExercises(
      String workoutId, int oldIndex, int newIndex) async {
    final workout = getWorkoutById(workoutId);
    if (workout == null) return;

    final exercises = List<WorkoutExercise>.from(workout.exercises);
    final item = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, item);

    await updateWorkout(workout.copyWith(exercises: exercises));
  }

  Future<void> _save() async {
    await _box?.put(
      'workouts_data',
      jsonEncode(_workouts.map((w) => w.toJson()).toList()),
    );
  }
}
