import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/exercise_card_widget.dart';
import '../../data/models/exercise_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/exercise_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: favoriteIds.isEmpty
          ? _emptyState()
          : _FavoritesList(favoriteIds: favoriteIds.toList()),
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
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.favorite_rounded,
              size: 36,
              color: AppColors.accent.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any exercise\nto save it here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }
}

class _FavoritesList extends ConsumerWidget {
  final List<String> favoriteIds;

  const _FavoritesList({required this.favoriteIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: favoriteIds.length,
      itemBuilder: (context, index) {
        final id = favoriteIds[index];
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
