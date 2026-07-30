#!/usr/bin/env dart
// ignore_for_file: avoid_print

/// Script to download and preprocess the exercises dataset from GitHub.
///
/// Usage:
///   dart run scripts/download_exercises.dart
///
/// This script:
///   1. Downloads exercises.json from the GitHub repository
///   2. Keeps only English instructions (reduces size from ~17MB to ~2MB)
///   3. Converts relative image/gif paths to full GitHub raw URLs
///   4. Saves the processed data to assets/data/exercises.json
library download_exercises;

import 'dart:convert';
import 'dart:io';

const String sourceUrl =
    'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/data/exercises.json';
const String outputPath = 'assets/data/exercises.json';
const String baseUrl =
    'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/';

Future<void> main() async {
  print('🏋️ GymBro Exercise Data Preprocessor');
  print('====================================\n');

  // Step 1: Download
  print('📥 Downloading exercises.json from GitHub...');
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(sourceUrl));
    final response = await request.close();

    if (response.statusCode != 200) {
      print('❌ Failed to download: HTTP ${response.statusCode}');
      exit(1);
    }

    final jsonString = await response.transform(utf8.decoder).join();
    final List<dynamic> exercises = jsonDecode(jsonString);
    print('✅ Downloaded ${exercises.length} exercises\n');

    // Step 2: Process
    print('⚙️  Processing exercises...');
    final processed = exercises.map((exercise) {
      final e = exercise as Map<String, dynamic>;

      // Extract English instruction steps only
      List<String> steps = [];
      if (e['instruction_steps'] != null) {
        final stepsMap = e['instruction_steps'] as Map<String, dynamic>;
        if (stepsMap.containsKey('en')) {
          steps = (stepsMap['en'] as List<dynamic>).cast<String>();
        }
      }

      return {
        'id': e['id'],
        'name': e['name'],
        'category': e['category'],
        'body_part': e['body_part'],
        'equipment': e['equipment'],
        'target': e['target'],
        'muscle_group': e['muscle_group'],
        'secondary_muscles': e['secondary_muscles'] ?? [],
        'instruction_steps': {'en': steps},
        'image': e['image'],
        'gif_url': e['gif_url'],
        'media_id': e['media_id'],
      };
    }).toList();

    // Step 3: Save
    print('💾 Saving to $outputPath...');
    final outputFile = File(outputPath);
    await outputFile.parent.create(recursive: true);

    // Compact JSON (no pretty print to save space)
    final outputJson = jsonEncode(processed);
    await outputFile.writeAsString(outputJson);

    final sizeKb = (outputFile.lengthSync() / 1024).toStringAsFixed(1);
    print('✅ Saved! Size: ${sizeKb}KB');

    // Stats
    final bodyParts = <String, int>{};
    final equipment = <String, int>{};
    for (final e in processed) {
      final bp = e['body_part'] as String;
      bodyParts[bp] = (bodyParts[bp] ?? 0) + 1;
      final eq = e['equipment'] as String;
      equipment[eq] = (equipment[eq] ?? 0) + 1;
    }

    print('\n📊 Statistics:');
    print('   Total exercises: ${processed.length}');
    print('   Body parts: ${bodyParts.length}');
    print('   Equipment types: ${equipment.length}');
    print('\n   By body part:');
    bodyParts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..forEach((e) => print('     ${e.key}: ${e.value}'));

    print('\n🎉 Done! exercises.json is ready.');
  } finally {
    client.close();
  }
}
