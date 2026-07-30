import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/favorites_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

// ── Favorites State ───────────────────────────────────────────────────────
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.read(favoritesRepositoryProvider));
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoritesRepository _repo;

  FavoritesNotifier(this._repo) : super({});

  Future<void> initialize() async {
    await _repo.initialize();
    state = Set<String>.from(_repo.favorites);
  }

  Future<void> toggle(String exerciseId) async {
    await _repo.toggleFavorite(exerciseId);
    state = Set<String>.from(_repo.favorites);
  }

  bool isFavorite(String exerciseId) => state.contains(exerciseId);
}

// ── Convenience provider to check single exercise ─────────────────────────
final isFavoriteProvider = Provider.family<bool, String>((ref, id) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(id);
});
