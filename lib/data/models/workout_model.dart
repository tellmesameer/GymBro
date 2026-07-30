/// Workout data model for the GymBro app.
class WorkoutModel {
  final String id;
  final String name;
  final String emoji;
  final List<WorkoutExercise> exercises;
  final DateTime createdAt;
  final DateTime? lastPerformedAt;

  const WorkoutModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.exercises,
    required this.createdAt,
    this.lastPerformedAt,
  });

  WorkoutModel copyWith({
    String? id,
    String? name,
    String? emoji,
    List<WorkoutExercise>? exercises,
    DateTime? createdAt,
    DateTime? lastPerformedAt,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      exercises: exercises ?? this.exercises,
      createdAt: createdAt ?? this.createdAt,
      lastPerformedAt: lastPerformedAt ?? this.lastPerformedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'last_performed_at': lastPerformedAt?.toIso8601String(),
    };
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String? ?? '💪',
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      lastPerformedAt: json['last_performed_at'] != null
          ? DateTime.parse(json['last_performed_at'] as String)
          : null,
    );
  }

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.sets);
}

/// A single exercise entry within a workout routine
class WorkoutExercise {
  final String exerciseId;
  final String exerciseName;
  final int sets;
  final String reps; // e.g., "8-10" or "AMRAP"
  final double? weight;
  final int restSeconds;

  const WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    this.sets = 3,
    this.reps = '10',
    this.weight,
    this.restSeconds = 90,
  });

  WorkoutExercise copyWith({
    String? exerciseId,
    String? exerciseName,
    int? sets,
    String? reps,
    double? weight,
    int? restSeconds,
  }) {
    return WorkoutExercise(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'rest_seconds': restSeconds,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exerciseId: json['exercise_id'] as String,
      exerciseName: json['exercise_name'] as String? ?? '',
      sets: json['sets'] as int? ?? 3,
      reps: json['reps'] as String? ?? '10',
      weight: (json['weight'] as num?)?.toDouble(),
      restSeconds: json['rest_seconds'] as int? ?? 90,
    );
  }

  /// Display string like "4 sets × 8-10 reps"
  String get displaySetsReps => '$sets sets × $reps reps';
}
