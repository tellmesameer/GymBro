import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/cached_gif_image.dart';
import '../../data/models/exercise_model.dart';
import '../providers/exercise_providers.dart';
import '../providers/favorites_provider.dart';
import '../providers/recent_provider.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;

  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  ConsumerState<ExerciseDetailScreen> createState() =>
      _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Track as recently viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentProvider.notifier).addRecent(widget.exerciseId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseAsync = ref.watch(exerciseByIdProvider(widget.exerciseId));

    return exerciseAsync.when(
      data: (exercise) {
        if (exercise == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(backgroundColor: AppColors.background),
            body: const Center(child: Text('Exercise not found')),
          );
        }
        return _buildContent(exercise);
      },
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: Text('Error loading exercise')),
      ),
    );
  }

  Widget _buildContent(ExerciseModel exercise) {
    final isFav = ref.watch(isFavoriteProvider(exercise.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar with back + favorite ─────────────────────────────
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            pinned: false,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              exercise.displayName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav ? AppColors.accent : AppColors.textSecondary,
                ),
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).toggle(exercise.id),
              ),
            ],
          ),

          // ── GIF Viewer ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 260,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder, width: 0.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    CachedGifImage(
                      imageUrl: exercise.gifUrl,
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.contain,
                    ),
                    // GIF badge
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'GIF',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 500.ms),
          ),

          // ── Dot Indicator ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == 0 ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColors.accent
                          : AppColors.surfaceHighlight,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Exercise Info Cards ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.gps_fixed_rounded,
                    iconColor: AppColors.error,
                    label: 'Target Muscle',
                    value: exercise.displayTarget,
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.scatter_plot_rounded,
                    iconColor: AppColors.success,
                    label: 'Secondary Muscles',
                    value: exercise.secondaryMuscles.isNotEmpty
                        ? exercise.secondaryMuscles
                            .map((m) => m.split(' ').map((w) =>
                                w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
                                .join(' '))
                            .join(', ')
                        : 'None',
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.fitness_center_rounded,
                    iconColor: AppColors.accent,
                    label: 'Equipment',
                    value: exercise.displayEquipment,
                  ),
                  const SizedBox(height: 10),
                  _DifficultyRow(difficulty: exercise.difficulty),
                ],
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            ),
          ),

          // ── Tab Bar ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Instructions'),
                  Tab(text: 'Tips & Notes'),
                ],
                onTap: (_) => setState(() {}),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
          ),

          // ── Tab Content ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _tabController.index == 0
                  ? _InstructionsList(instructions: exercise.instructions)
                  : _TipsSection(),
            ).animate().fadeIn(duration: 300.ms, delay: 350.ms),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),

      // ── Bottom Buttons ──────────────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add to workout
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('Start Workout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.textOnAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 52,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(favoritesProvider.notifier)
                      .toggle(exercise.id),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide(
                      color: isFav
                          ? AppColors.accent
                          : AppColors.cardBorder,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFav ? AppColors.accent : AppColors.textSecondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideY(begin: 0.3, end: 0),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyRow extends StatelessWidget {
  final String difficulty;

  const _DifficultyRow({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    int level;
    Color color;
    switch (difficulty) {
      case 'Beginner':
        level = 1;
        color = AppColors.beginner;
        break;
      case 'Advanced':
        level = 3;
        color = AppColors.advanced;
        break;
      default:
        level = 2;
        color = AppColors.intermediate;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.signal_cellular_alt_rounded,
                size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Difficulty',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  difficulty,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Level bars
          Row(
            children: List.generate(5, (index) {
              return Container(
                width: 5,
                height: 14 + (index * 3).toDouble(),
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: index < level
                      ? color
                      : AppColors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _InstructionsList extends StatelessWidget {
  final List<String> instructions;

  const _InstructionsList({required this.instructions});

  @override
  Widget build(BuildContext context) {
    if (instructions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No instructions available',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
      );
    }

    return Column(
      children: instructions.asMap().entries.map((entry) {
        final index = entry.key;
        final instruction = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    instruction,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TipsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tipItem(
          'Focus on proper form over heavy weight',
          Icons.check_circle_outline_rounded,
        ),
        _tipItem(
          'Control the movement on both concentric and eccentric phases',
          Icons.check_circle_outline_rounded,
        ),
        _tipItem(
          'Breathe out during exertion, breathe in during the return',
          Icons.check_circle_outline_rounded,
        ),
        _tipItem(
          'Start with lighter weight to warm up the muscle group',
          Icons.check_circle_outline_rounded,
        ),
      ],
    );
  }

  Widget _tipItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
