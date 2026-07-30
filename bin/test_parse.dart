// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';
import 'package:gymbro/data/models/exercise_model.dart';

void main() async {
  try {
    final jsonString = await File('assets/data/exercises.json').readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    final exercises = jsonList.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>)).toList();
    print('Successfully parsed ${exercises.length} exercises.');
    
    final counts = <String, int>{};
    for (var e in exercises) {
      counts[e.bodyPart] = (counts[e.bodyPart] ?? 0) + 1;
    }
    print('Counts: $counts');
  } catch (e, st) {
    print('Error: $e');
    print(st);
  }
}
