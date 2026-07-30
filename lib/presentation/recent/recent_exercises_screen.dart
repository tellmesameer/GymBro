import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/exercise_card_widget.dart';
import '../providers/recent_provider.dart';
import '../providers/exercise_providers.dart';

class RecentExercisesScreen extends ConsumerWidget {
  const RecentExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentIds = ref.watch(recentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Recently Viewed',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: recentIds.isEmpty
          ? _emptyState()
          : _RecentList(recentIds: recentIds.toList()),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.history_rounded,
              size: 36,
              color: AppColors.accent.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No recent exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Exercises you view will\nappear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}

class _RecentList extends ConsumerWidget {
  final List<String> recentIds;

  const _RecentList({required this.recentIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: recentIds.length,
      itemBuilder: (context, index) {
        final id = recentIds[index];
        final exerciseAsync = ref.watch(exerciseByIdProvider(id));

        return exerciseAsync.when(
          data: (exercise) {
            if (exercise == null) return const SizedBox.shrink();
            return ExerciseCardWidget(
              exercise: exercise,
              showBodyPart: true,
            ).animate().fadeIn(
              duration: 300.ms,
              delay: Duration(milliseconds: (index * 50).clamp(0, 500)),
            );
          },
          loading: () => const SizedBox(height: 90),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }
}
