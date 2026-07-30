import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/exercise_card_widget.dart';
import '../../data/models/exercise_model.dart';
import '../providers/exercise_providers.dart';
import '../providers/filter_provider.dart';

class ExerciseListScreen extends ConsumerStatefulWidget {
  final String bodyPart;

  const ExerciseListScreen({super.key, required this.bodyPart});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final _searchController = TextEditingController();
  String? _quickFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync =
        ref.watch(filteredExercisesProvider(widget.bodyPart));
    final displayName =
        AppConstants.bodyPartDisplayNames[widget.bodyPart] ??
            widget.bodyPart;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => context.push(
              '/filters?bodyPart=${widget.bodyPart}',
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.tune_rounded,
                  size: 16,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search in ${displayName.toLowerCase()} exercises...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textTertiary,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          // ── Quick Filter Chips ──────────────────────────────────────
          SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _quickFilter == null,
                  onTap: () {
                    setState(() => _quickFilter = null);
                    ref.read(filterProvider.notifier).setEquipment(null);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Barbell',
                  isSelected: _quickFilter == 'barbell',
                  onTap: () => _setQuickFilter('barbell'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Dumbbell',
                  isSelected: _quickFilter == 'dumbbell',
                  onTap: () => _setQuickFilter('dumbbell'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Machine',
                  isSelected: _quickFilter == 'leverage machine',
                  onTap: () => _setQuickFilter('leverage machine'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Cable',
                  isSelected: _quickFilter == 'cable',
                  onTap: () => _setQuickFilter('cable'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Band',
                  isSelected: _quickFilter == 'band',
                  onTap: () => _setQuickFilter('band'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Body Weight',
                  isSelected: _quickFilter == 'body weight',
                  onTap: () => _setQuickFilter('body weight'),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

          const SizedBox(height: 8),

          // ── Exercise List ───────────────────────────────────────────
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                if (exercises.isEmpty) {
                  return _emptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return ExerciseCardWidget(
                      exercise: exercises[index],
                    ).animate().fadeIn(
                      duration: 300.ms,
                      delay: Duration(milliseconds: (index * 30).clamp(0, 300)),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                ),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Error loading exercises',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setQuickFilter(String equipment) {
    setState(() {
      if (_quickFilter == equipment) {
        _quickFilter = null;
        ref.read(filterProvider.notifier).setEquipment(null);
      } else {
        _quickFilter = equipment;
        ref.read(filterProvider.notifier).setEquipment(equipment);
      }
    });
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No exercises found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : AppColors.cardBorder,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppColors.textOnAccent
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
