import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/exercise_providers.dart';
import 'widgets/body_svg_painter.dart';

class MusclesSelectorScreen extends ConsumerStatefulWidget {
  const MusclesSelectorScreen({super.key});

  @override
  ConsumerState<MusclesSelectorScreen> createState() =>
      _MusclesSelectorScreenState();
}

class _MusclesSelectorScreenState extends ConsumerState<MusclesSelectorScreen>
    with SingleTickerProviderStateMixin {
  bool _isFront = true;
  String? _selectedBodyPart;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyCounts = ref.watch(bodyPartCountsProvider);
    print('BODY COUNTS: $bodyCounts');
    print('SELECTED BODY PART: $_selectedBodyPart');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Select Muscle',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Front / Back Toggle ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 0.5),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isFront = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isFront
                              ? AppColors.accent
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            'Front',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _isFront
                                  ? AppColors.textOnAccent
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isFront = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isFront
                              ? AppColors.accent
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: !_isFront
                                  ? AppColors.textOnAccent
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),

          // ── Body Map ──────────────────────────────────────────────────
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapDown: (details) {
                    final bodySize = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    final hit = BodySvgPainter.getMuscleAtPoint(
                      details.localPosition,
                      bodySize,
                      _isFront,
                    );
                    setState(() {
                      _selectedBodyPart = hit;
                    });
                  },
                  child: Stack(
                    children: [
                      // The body painter
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            size: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            painter: BodySvgPainter(
                              isFront: _isFront,
                              selectedMuscle: _selectedBodyPart,
                              animationValue: _glowAnimation.value,
                            ),
                          );
                        },
                      ),

                      // Muscle labels
                      ..._buildMuscleLabels(
                        Size(constraints.maxWidth, constraints.maxHeight),
                        bodyCounts,
                      ),
                    ],
                  ),
                );
              },
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

          // ── Bottom Info Card ───────────────────────────────────────────
          if (_selectedBodyPart != null)
            _MuscleInfoCard(
              bodyPart: _selectedBodyPart!,
              exerciseCount: bodyCounts[_selectedBodyPart] ?? 0,
              onTap: () => context.push('/exercises/$_selectedBodyPart'),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildMuscleLabels(
    Size size,
    Map<String, int> bodyCounts,
  ) {
    final labels = BodySvgPainter.getUniqueLabels(size, _isFront);
    return labels.map((muscle) {
      final isSelected = _selectedBodyPart == muscle.bodyPart;
      final isLeft = muscle.labelPosition.dx < size.width / 2;

      return Positioned(
        left: muscle.labelPosition.dx,
        top: muscle.labelPosition.dy,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedBodyPart = muscle.bodyPart;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isLeft)
                Container(
                  width: 20,
                  height: 1,
                  color: isSelected
                      ? AppColors.accent.withOpacity(0.5)
                      : AppColors.textTertiary.withOpacity(0.3),
                ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withOpacity(0.15)
                      : AppColors.surfaceLight.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: AppColors.accent.withOpacity(0.3))
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fitness_center_rounded,
                      size: 12,
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      muscle.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLeft)
                Container(
                  width: 20,
                  height: 1,
                  color: isSelected
                      ? AppColors.accent.withOpacity(0.5)
                      : AppColors.textTertiary.withOpacity(0.3),
                ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _MuscleInfoCard extends StatelessWidget {
  final String bodyPart;
  final int exerciseCount;
  final VoidCallback onTap;

  const _MuscleInfoCard({
    required this.bodyPart,
    required this.exerciseCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        AppConstants.bodyPartDisplayNames[bodyPart] ?? bodyPart;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                color: AppColors.accent,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$exerciseCount Exercises',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
