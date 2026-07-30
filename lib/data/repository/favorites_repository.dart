import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

/// Repository for managing favorite exercise IDs using Hive
class FavoritesRepository {
  Box? _box;
  Set<String> _favorites = {};

  Set<String> get favorites => _favorites;

  Future<void> initialize() async {
    _box = await Hive.openBox(AppConstants.favoritesBox);
    final stored = _box?.get('favorite_ids');
    if (stored != null) {
      _favorites = Set<String>.from(jsonDecode(stored as String));
    }
  }

  bool isFavorite(String exerciseId) => _favorites.contains(exerciseId);

  Future<void> toggleFavorite(String exerciseId) async {
    if (_favorites.contains(exerciseId)) {
      _favorites.remove(exerciseId);
    } else {
      _favorites.add(exerciseId);
    }
    await _save();
  }

  Future<void> addFavorite(String exerciseId) async {
    _favorites.add(exerciseId);
    await _save();
  }

  Future<void> removeFavorite(String exerciseId) async {
    _favorites.remove(exerciseId);
    await _save();
  }

  Future<void> _save() async {
    await _box?.put('favorite_ids', jsonEncode(_favorites.toList()));
  }
}
