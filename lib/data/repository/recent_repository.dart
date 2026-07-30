import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';

/// Repository for tracking recently viewed exercise IDs using Hive.
/// Maintains a FIFO queue of the last [AppConstants.maxRecentExercises] IDs.
class RecentRepository {
  Box? _box;
  List<String> _recentIds = [];

  List<String> get recentIds => List.unmodifiable(_recentIds);

  Future<void> initialize() async {
    _box = await Hive.openBox(AppConstants.recentBox);
    final stored = _box?.get('recent_ids');
    if (stored != null) {
      _recentIds = List<String>.from(jsonDecode(stored as String));
    }
  }

  /// Add an exercise ID to the front of the recent list.
  /// If it already exists, move it to the front.
  Future<void> addRecent(String exerciseId) async {
    _recentIds.remove(exerciseId); // Remove if exists
    _recentIds.insert(0, exerciseId); // Add to front

    // Trim to max size
    if (_recentIds.length > AppConstants.maxRecentExercises) {
      _recentIds = _recentIds.sublist(0, AppConstants.maxRecentExercises);
    }

    await _save();
  }

  Future<void> clearRecent() async {
    _recentIds.clear();
    await _save();
  }

  Future<void> _save() async {
    await _box?.put('recent_ids', jsonEncode(_recentIds));
  }
}
