
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Muscle region definition for the interactive body map
class MuscleRegion {
  final String id;
  final String name;
  final String bodyPart; // Maps to dataset body_part
  final Path path;
  final Offset labelPosition;

  const MuscleRegion({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.path,
    required this.labelPosition,
  });
}

/// Custom painter that renders an interactive body silhouette with
/// individually tappable and highlightable muscle regions.
class BodySvgPainter extends CustomPainter {
  final bool isFront;
  final String? selectedMuscle;
  final double animationValue;

  BodySvgPainter({
    required this.isFront,
    this.selectedMuscle,
    this.animationValue = 1.0,
  });

  // ── Front View Muscle Paths ─────────────────────────────────────────────
  static List<MuscleRegion> getFrontMuscles(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    return [
      // Neck
      MuscleRegion(
        id: 'neck',
        name: 'Neck',
        bodyPart: 'neck',
        path: _createPath([
          Offset(cx - 18, h * 0.115),
          Offset(cx + 18, h * 0.115),
          Offset(cx + 22, h * 0.155),
          Offset(cx - 22, h * 0.155),
        ]),
        labelPosition: Offset(cx - 85, h * 0.13),
      ),

      // Left Shoulder (Deltoid)
      MuscleRegion(
        id: 'shoulders_l',
        name: 'Shoulders',
        bodyPart: 'shoulders',
        path: _createPath([
          Offset(cx - 45, h * 0.155),
          Offset(cx - 28, h * 0.155),
          Offset(cx - 30, h * 0.21),
          Offset(cx - 55, h * 0.21),
          Offset(cx - 62, h * 0.175),
        ]),
        labelPosition: Offset(cx - 110, h * 0.185),
      ),

      // Right Shoulder
      MuscleRegion(
        id: 'shoulders_r',
        name: 'Shoulders',
        bodyPart: 'shoulders',
        path: _createPath([
          Offset(cx + 28, h * 0.155),
          Offset(cx + 45, h * 0.155),
          Offset(cx + 62, h * 0.175),
          Offset(cx + 55, h * 0.21),
          Offset(cx + 30, h * 0.21),
        ]),
        labelPosition: Offset(cx + 65, h * 0.185),
      ),

      // Chest Left
      MuscleRegion(
        id: 'chest_l',
        name: 'Chest',
        bodyPart: 'chest',
        path: _createPath([
          Offset(cx - 8, h * 0.165),
          Offset(cx - 28, h * 0.155),
          Offset(cx - 30, h * 0.21),
          Offset(cx - 38, h * 0.26),
          Offset(cx - 8, h * 0.26),
        ]),
        labelPosition: Offset(cx + 65, h * 0.21),
      ),

      // Chest Right
      MuscleRegion(
        id: 'chest_r',
        name: 'Chest',
        bodyPart: 'chest',
        path: _createPath([
          Offset(cx + 8, h * 0.165),
          Offset(cx + 28, h * 0.155),
          Offset(cx + 30, h * 0.21),
          Offset(cx + 38, h * 0.26),
          Offset(cx + 8, h * 0.26),
        ]),
        labelPosition: Offset(cx + 65, h * 0.21),
      ),

      // Left Bicep
      MuscleRegion(
        id: 'biceps_l',
        name: 'Biceps',
        bodyPart: 'upper arms',
        path: _createPath([
          Offset(cx - 55, h * 0.215),
          Offset(cx - 62, h * 0.215),
          Offset(cx - 65, h * 0.31),
          Offset(cx - 52, h * 0.31),
        ]),
        labelPosition: Offset(cx - 110, h * 0.26),
      ),

      // Right Bicep
      MuscleRegion(
        id: 'biceps_r',
        name: 'Biceps',
        bodyPart: 'upper arms',
        path: _createPath([
          Offset(cx + 52, h * 0.215),
          Offset(cx + 62, h * 0.215),
          Offset(cx + 65, h * 0.31),
          Offset(cx + 52, h * 0.31),
        ]),
        labelPosition: Offset(cx + 65, h * 0.26),
      ),

      // Left Forearm
      MuscleRegion(
        id: 'forearms_l',
        name: 'Forearms',
        bodyPart: 'lower arms',
        path: _createPath([
          Offset(cx - 52, h * 0.315),
          Offset(cx - 65, h * 0.315),
          Offset(cx - 62, h * 0.41),
          Offset(cx - 50, h * 0.41),
        ]),
        labelPosition: Offset(cx - 110, h * 0.36),
      ),

      // Right Forearm
      MuscleRegion(
        id: 'forearms_r',
        name: 'Forearms',
        bodyPart: 'lower arms',
        path: _createPath([
          Offset(cx + 50, h * 0.315),
          Offset(cx + 65, h * 0.315),
          Offset(cx + 62, h * 0.41),
          Offset(cx + 50, h * 0.41),
        ]),
        labelPosition: Offset(cx + 65, h * 0.36),
      ),

      // Abs
      MuscleRegion(
        id: 'abs',
        name: 'Abs',
        bodyPart: 'waist',
        path: _createPath([
          Offset(cx - 22, h * 0.265),
          Offset(cx + 22, h * 0.265),
          Offset(cx + 22, h * 0.40),
          Offset(cx - 22, h * 0.40),
        ]),
        labelPosition: Offset(cx - 85, h * 0.34),
      ),

      // Left Obliques
      MuscleRegion(
        id: 'obliques_l',
        name: 'Obliques',
        bodyPart: 'waist',
        path: _createPath([
          Offset(cx - 24, h * 0.27),
          Offset(cx - 38, h * 0.265),
          Offset(cx - 36, h * 0.40),
          Offset(cx - 24, h * 0.40),
        ]),
        labelPosition: Offset(cx + 65, h * 0.33),
      ),

      // Right Obliques
      MuscleRegion(
        id: 'obliques_r',
        name: 'Obliques',
        bodyPart: 'waist',
        path: _createPath([
          Offset(cx + 24, h * 0.27),
          Offset(cx + 38, h * 0.265),
          Offset(cx + 36, h * 0.40),
          Offset(cx + 24, h * 0.40),
        ]),
        labelPosition: Offset(cx + 65, h * 0.33),
      ),

      // Left Quadriceps
      MuscleRegion(
        id: 'quads_l',
        name: 'Quadriceps',
        bodyPart: 'upper legs',
        path: _createPath([
          Offset(cx - 8, h * 0.42),
          Offset(cx - 32, h * 0.42),
          Offset(cx - 35, h * 0.58),
          Offset(cx - 18, h * 0.59),
          Offset(cx - 8, h * 0.58),
        ]),
        labelPosition: Offset(cx - 110, h * 0.50),
      ),

      // Right Quadriceps
      MuscleRegion(
        id: 'quads_r',
        name: 'Quadriceps',
        bodyPart: 'upper legs',
        path: _createPath([
          Offset(cx + 8, h * 0.42),
          Offset(cx + 32, h * 0.42),
          Offset(cx + 35, h * 0.58),
          Offset(cx + 18, h * 0.59),
          Offset(cx + 8, h * 0.58),
        ]),
        labelPosition: Offset(cx + 65, h * 0.50),
      ),

      // Left Calf
      MuscleRegion(
        id: 'calves_l',
        name: 'Calves',
        bodyPart: 'lower legs',
        path: _createPath([
          Offset(cx - 12, h * 0.64),
          Offset(cx - 32, h * 0.64),
          Offset(cx - 28, h * 0.78),
          Offset(cx - 14, h * 0.78),
        ]),
        labelPosition: Offset(cx - 100, h * 0.72),
      ),

      // Right Calf
      MuscleRegion(
        id: 'calves_r',
        name: 'Calves',
        bodyPart: 'lower legs',
        path: _createPath([
          Offset(cx + 12, h * 0.64),
          Offset(cx + 32, h * 0.64),
          Offset(cx + 28, h * 0.78),
          Offset(cx + 14, h * 0.78),
        ]),
        labelPosition: Offset(cx + 65, h * 0.72),
      ),
    ];
  }

  // ── Back View Muscle Paths ──────────────────────────────────────────────
  static List<MuscleRegion> getBackMuscles(Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    return [
      // Traps
      MuscleRegion(
        id: 'traps',
        name: 'Traps',
        bodyPart: 'back',
        path: _createPath([
          Offset(cx - 22, h * 0.12),
          Offset(cx + 22, h * 0.12),
          Offset(cx + 38, h * 0.17),
          Offset(cx, h * 0.20),
          Offset(cx - 38, h * 0.17),
        ]),
        labelPosition: Offset(cx - 90, h * 0.145),
      ),

      // Left Rear Delt
      MuscleRegion(
        id: 'rear_delts_l',
        name: 'Rear Delts',
        bodyPart: 'shoulders',
        path: _createPath([
          Offset(cx - 42, h * 0.155),
          Offset(cx - 58, h * 0.17),
          Offset(cx - 60, h * 0.21),
          Offset(cx - 42, h * 0.21),
        ]),
        labelPosition: Offset(cx + 65, h * 0.18),
      ),

      // Right Rear Delt
      MuscleRegion(
        id: 'rear_delts_r',
        name: 'Rear Delts',
        bodyPart: 'shoulders',
        path: _createPath([
          Offset(cx + 42, h * 0.155),
          Offset(cx + 58, h * 0.17),
          Offset(cx + 60, h * 0.21),
          Offset(cx + 42, h * 0.21),
        ]),
        labelPosition: Offset(cx + 65, h * 0.18),
      ),

      // Left Lat
      MuscleRegion(
        id: 'lats_l',
        name: 'Lats',
        bodyPart: 'back',
        path: _createPath([
          Offset(cx - 8, h * 0.20),
          Offset(cx - 38, h * 0.20),
          Offset(cx - 42, h * 0.32),
          Offset(cx - 30, h * 0.38),
          Offset(cx - 8, h * 0.34),
        ]),
        labelPosition: Offset(cx - 100, h * 0.28),
      ),

      // Right Lat
      MuscleRegion(
        id: 'lats_r',
        name: 'Lats',
        bodyPart: 'back',
        path: _createPath([
          Offset(cx + 8, h * 0.20),
          Offset(cx + 38, h * 0.20),
          Offset(cx + 42, h * 0.32),
          Offset(cx + 30, h * 0.38),
          Offset(cx + 8, h * 0.34),
        ]),
        labelPosition: Offset(cx + 65, h * 0.28),
      ),

      // Left Tricep
      MuscleRegion(
        id: 'triceps_l',
        name: 'Triceps',
        bodyPart: 'upper arms',
        path: _createPath([
          Offset(cx - 50, h * 0.215),
          Offset(cx - 62, h * 0.215),
          Offset(cx - 65, h * 0.31),
          Offset(cx - 50, h * 0.31),
        ]),
        labelPosition: Offset(cx - 110, h * 0.26),
      ),

      // Right Tricep
      MuscleRegion(
        id: 'triceps_r',
        name: 'Triceps',
        bodyPart: 'upper arms',
        path: _createPath([
          Offset(cx + 50, h * 0.215),
          Offset(cx + 62, h * 0.215),
          Offset(cx + 65, h * 0.31),
          Offset(cx + 50, h * 0.31),
        ]),
        labelPosition: Offset(cx + 65, h * 0.26),
      ),

      // Lower Back
      MuscleRegion(
        id: 'lower_back',
        name: 'Lower Back',
        bodyPart: 'back',
        path: _createPath([
          Offset(cx - 24, h * 0.35),
          Offset(cx + 24, h * 0.35),
          Offset(cx + 24, h * 0.42),
          Offset(cx - 24, h * 0.42),
        ]),
        labelPosition: Offset(cx - 100, h * 0.385),
      ),

      // Left Glute
      MuscleRegion(
        id: 'glutes_l',
        name: 'Glutes',
        bodyPart: 'upper legs',
        path: _createPath([
          Offset(cx - 8, h * 0.42),
          Offset(cx - 35, h * 0.42),
          Offset(cx - 35, h * 0.50),
          Offset(cx - 8, h * 0.50),
        ]),
        labelPosition: Offset(cx + 65, h * 0.455),
      ),

      // Right Glute
      MuscleRegion(
        id: 'glutes_r',
        name: 'Glutes',
        bodyPart: 'upper legs',
        path: _createPath([
          Offset(cx + 8, h * 0.42),
          Offset(cx + 35, h * 0.42),
          Offset(cx + 35, h * 0.50),
          Offset(cx + 8, h * 0.50),
        ]),
        labelPosition: Offset(cx + 65, h * 0.455),
      ),

      // Left Hamstring
      MuscleRegion(
        id: 'hamstrings_l',
        name: 'Hamstrings',
        bodyPart: 'upper legs',
        path: _createPath([
          Offset(cx - 8, h * 0.51),
          Offset(cx - 34, h * 0.51),
          Offset(cx - 32, h * 0.62),
          Offset(cx - 10, h * 0.62),
        ]),
        labelPosition: Offset(cx + 65, h * 0.56),
      ),

      // Right Hamstring
      MuscleRegion(
        id: 'hamstrings_r',
        name: 'Hamstrings',
        bodyPart: 'upper legs',
        path: _createPath([
          Offset(cx + 8, h * 0.51),
          Offset(cx + 34, h * 0.51),
          Offset(cx + 32, h * 0.62),
          Offset(cx + 10, h * 0.62),
        ]),
        labelPosition: Offset(cx + 65, h * 0.56),
      ),

      // Left Calf (back)
      MuscleRegion(
        id: 'calves_back_l',
        name: 'Calves',
        bodyPart: 'lower legs',
        path: _createPath([
          Offset(cx - 12, h * 0.64),
          Offset(cx - 30, h * 0.64),
          Offset(cx - 26, h * 0.76),
          Offset(cx - 14, h * 0.76),
        ]),
        labelPosition: Offset(cx - 95, h * 0.70),
      ),

      // Right Calf (back)
      MuscleRegion(
        id: 'calves_back_r',
        name: 'Calves',
        bodyPart: 'lower legs',
        path: _createPath([
          Offset(cx + 12, h * 0.64),
          Offset(cx + 30, h * 0.64),
          Offset(cx + 26, h * 0.76),
          Offset(cx + 14, h * 0.76),
        ]),
        labelPosition: Offset(cx + 65, h * 0.70),
      ),
    ];
  }

  /// Create a closed Path from a list of points
  static Path _createPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final muscles = isFront ? getFrontMuscles(size) : getBackMuscles(size);

    // Draw body outline silhouette
    _drawBodyOutline(canvas, size);

    // Draw each muscle region
    for (final muscle in muscles) {
      final isSelected = selectedMuscle != null &&
          (muscle.id == selectedMuscle ||
           muscle.id.startsWith(selectedMuscle!) ||
           muscle.bodyPart == selectedMuscle);

      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = isSelected
            ? AppColors.muscleHighlight.withValues(alpha: 0.6 * animationValue)
            : AppColors.muscleDefault.withValues(alpha: 0.4);

      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 1.5 : 0.5
        ..color = isSelected
            ? AppColors.muscleHighlight.withValues(alpha: 0.9)
            : AppColors.muscleOutline.withValues(alpha: 0.5);

      canvas.drawPath(muscle.path, fillPaint);
      canvas.drawPath(muscle.path, strokePaint);

      // Glow effect for selected
      if (isSelected) {
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = AppColors.muscleHighlight.withValues(alpha: 0.15 * animationValue)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawPath(muscle.path, glowPaint);
      }
    }
  }

  void _drawBodyOutline(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.bodyOutline.withValues(alpha: 0.3);

    final bodyPath = Path();

    // Head
    bodyPath.addOval(Rect.fromCenter(
      center: Offset(cx, h * 0.065),
      width: 40,
      height: 48,
    ));

    // Torso + limbs outline
    final torsoPath = Path();
    // Neck to left shoulder
    torsoPath.moveTo(cx - 18, h * 0.10);
    torsoPath.lineTo(cx - 22, h * 0.155);
    torsoPath.lineTo(cx - 60, h * 0.17);
    // Left arm
    torsoPath.lineTo(cx - 65, h * 0.32);
    torsoPath.lineTo(cx - 60, h * 0.42);
    torsoPath.lineTo(cx - 52, h * 0.44);
    // Back up the arm
    torsoPath.lineTo(cx - 48, h * 0.32);
    torsoPath.lineTo(cx - 42, h * 0.22);
    // Left side of torso
    torsoPath.lineTo(cx - 38, h * 0.42);
    // Left leg
    torsoPath.lineTo(cx - 36, h * 0.60);
    torsoPath.lineTo(cx - 32, h * 0.64);
    torsoPath.lineTo(cx - 30, h * 0.78);
    torsoPath.lineTo(cx - 28, h * 0.85);
    torsoPath.lineTo(cx - 14, h * 0.85);
    torsoPath.lineTo(cx - 12, h * 0.78);
    torsoPath.lineTo(cx - 10, h * 0.60);
    // Crotch
    torsoPath.lineTo(cx, h * 0.50);
    // Right leg
    torsoPath.lineTo(cx + 10, h * 0.60);
    torsoPath.lineTo(cx + 12, h * 0.78);
    torsoPath.lineTo(cx + 14, h * 0.85);
    torsoPath.lineTo(cx + 28, h * 0.85);
    torsoPath.lineTo(cx + 30, h * 0.78);
    torsoPath.lineTo(cx + 32, h * 0.64);
    torsoPath.lineTo(cx + 36, h * 0.60);
    // Right side of torso
    torsoPath.lineTo(cx + 38, h * 0.42);
    torsoPath.lineTo(cx + 42, h * 0.22);
    // Right arm
    torsoPath.lineTo(cx + 48, h * 0.32);
    torsoPath.lineTo(cx + 52, h * 0.44);
    torsoPath.lineTo(cx + 60, h * 0.42);
    torsoPath.lineTo(cx + 65, h * 0.32);
    torsoPath.lineTo(cx + 60, h * 0.17);
    // Neck to right shoulder
    torsoPath.lineTo(cx + 22, h * 0.155);
    torsoPath.lineTo(cx + 18, h * 0.10);
    torsoPath.close();

    canvas.drawPath(bodyPath, outlinePaint);
    canvas.drawPath(torsoPath, outlinePaint);

    // Body fill
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.bodyFill.withValues(alpha: 0.3);
    canvas.drawPath(torsoPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant BodySvgPainter oldDelegate) {
    return oldDelegate.selectedMuscle != selectedMuscle ||
        oldDelegate.isFront != isFront ||
        oldDelegate.animationValue != animationValue;
  }

  /// Hit test: which muscle region contains the given point?
  static String? getMuscleAtPoint(Offset position, Size size, bool isFront) {
    final muscles = isFront ? getFrontMuscles(size) : getBackMuscles(size);

    for (final muscle in muscles) {
      if (muscle.path.contains(position)) {
        return muscle.bodyPart;
      }
    }
    return null;
  }

  /// Get unique muscle labels for displaying around the body
  static List<MuscleRegion> getUniqueLabels(Size size, bool isFront) {
    final muscles = isFront ? getFrontMuscles(size) : getBackMuscles(size);
    final seen = <String>{};
    final unique = <MuscleRegion>[];

    for (final muscle in muscles) {
      if (!seen.contains(muscle.name)) {
        seen.add(muscle.name);
        unique.add(muscle);
      }
    }
    return unique;
  }
}
