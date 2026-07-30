

/// Exercise data model for the GymBro app.
/// Represents a single exercise from the dataset.
class ExerciseModel {
  final String id;
  final String name;
  final String category;
  final String bodyPart;
  final String equipment;
  final String target;
  final String muscleGroup;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String imageUrl;
  final String gifUrl;
  final String mediaId;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.muscleGroup,
    required this.secondaryMuscles,
    required this.instructions,
    required this.imageUrl,
    required this.gifUrl,
    required this.mediaId,
  });

  /// Create from raw JSON dataset entry
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    // Parse instruction steps (prefer structured steps over single string)
    List<String> steps = [];
    if (json['instruction_steps'] != null) {
      final stepsMap = json['instruction_steps'] as Map<String, dynamic>;
      if (stepsMap.containsKey('en')) {
        steps = (stepsMap['en'] as List<dynamic>).cast<String>();
      }
    } else if (json['instructions'] != null) {
      if (json['instructions'] is Map) {
        final instrMap = json['instructions'] as Map<String, dynamic>;
        if (instrMap.containsKey('en')) {
          final enText = instrMap['en'] as String;
          // Split numbered instructions: "1. ...\n2. ..."
          steps = enText
              .split(RegExp(r'\d+\.\s'))
              .where((s) => s.trim().isNotEmpty)
              .map((s) => s.trim())
              .toList();
        }
      } else if (json['instructions'] is List) {
        steps = (json['instructions'] as List<dynamic>).cast<String>();
      }
    }

    // Build full image/gif URLs from relative paths
    const baseUrl =
        'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/';
    final imagePath = json['image'] as String? ?? '';
    final gifPath = json['gif_url'] as String? ?? '';

    return ExerciseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      bodyPart: json['body_part'] as String? ?? '',
      equipment: json['equipment'] as String? ?? '',
      target: json['target'] as String? ?? '',
      muscleGroup: json['muscle_group'] as String? ?? '',
      secondaryMuscles: (json['secondary_muscles'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
      instructions: steps,
      imageUrl: imagePath.isNotEmpty ? '$baseUrl$imagePath' : '',
      gifUrl: gifPath.isNotEmpty ? '$baseUrl$gifPath' : '',
      mediaId: json['media_id'] as String? ?? '',
    );
  }

  /// Serialize to JSON (for Hive caching)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'body_part': bodyPart,
      'equipment': equipment,
      'target': target,
      'muscle_group': muscleGroup,
      'secondary_muscles': secondaryMuscles,
      'instructions': instructions,
      'image_url': imageUrl,
      'gif_url': gifUrl,
      'media_id': mediaId,
    };
  }

  /// Create from cached JSON (Hive)
  factory ExerciseModel.fromCachedJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      bodyPart: json['body_part'] as String? ?? '',
      equipment: json['equipment'] as String? ?? '',
      target: json['target'] as String? ?? '',
      muscleGroup: json['muscle_group'] as String? ?? '',
      secondaryMuscles:
          (json['secondary_muscles'] as List<dynamic>?)?.cast<String>() ?? [],
      instructions:
          (json['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
      imageUrl: json['image_url'] as String? ?? '',
      gifUrl: json['gif_url'] as String? ?? '',
      mediaId: json['media_id'] as String? ?? '',
    );
  }

  /// Capitalized display name
  String get displayName {
    if (name.isEmpty) return '';
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Capitalized body part
  String get displayBodyPart {
    return bodyPart.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Capitalized equipment
  String get displayEquipment {
    return equipment.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Capitalized target muscle
  String get displayTarget {
    return target.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  /// Computed difficulty based on instruction count and equipment
  String get difficulty {
    if (equipment == 'body weight' && instructions.length <= 3) {
      return 'Beginner';
    } else if (instructions.length >= 6 ||
        equipment == 'barbell' ||
        equipment == 'smith machine') {
      return 'Advanced';
    }
    return 'Intermediate';
  }

  /// Search-friendly concatenation of key fields
  String get searchableText {
    return '$name $bodyPart $equipment $target $muscleGroup'
        .toLowerCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
