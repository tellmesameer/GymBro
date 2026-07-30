import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../providers/filter_provider.dart';
import '../providers/exercise_providers.dart';

class FilterScreen extends ConsumerStatefulWidget {
  final String? bodyPart;

  const FilterScreen({super.key, this.bodyPart});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  String? _selectedEquipment;
  String? _selectedDifficulty;
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(filterProvider);
    _selectedEquipment = filters.equipment;
    _selectedDifficulty = filters.difficulty;
    _selectedGoal = filters.goal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedEquipment = null;
                _selectedDifficulty = null;
                _selectedGoal = null;
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Equipment ────────────────────────────────────────────
                  const Text(
                    'Equipment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildEquipmentGrid(),

                  const SizedBox(height: 28),

                  // ── Difficulty ───────────────────────────────────────────
                  const Text(
                    'Difficulty',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildChipRow([
                    'Beginner',
                    'Intermediate',
                    'Advanced',
                  ], _selectedDifficulty, (val) {
                    setState(() {
                      _selectedDifficulty =
                          _selectedDifficulty == val ? null : val;
                    });
                  }),

                  const SizedBox(height: 28),

                  // ── Goal ────────────────────────────────────────────────
                  const Text(
                    'Goal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildChipRow([
                    'Strength',
                    'Hypertrophy',
                    'Endurance',
                    'Mobility',
                    'General Fitness',
                  ], _selectedGoal, (val) {
                    setState(() {
                      _selectedGoal = _selectedGoal == val ? null : val;
                    });
                  }),
                ].animate(interval: 100.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
              ),
            ),
          ),

          // ── Apply Button ────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.textOnAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '1,300 Exercises',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textOnAccent.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentGrid() {
    final equipment = [
      ('All', Icons.select_all_rounded),
      ('Body Weight', Icons.self_improvement_rounded),
      ('Barbell', Icons.fitness_center_rounded),
      ('Dumbbell', Icons.fitness_center_rounded),
      ('Machine', Icons.precision_manufacturing_rounded),
      ('Cable', Icons.cable_rounded),
      ('Kettlebell', Icons.fitness_center_rounded),
      ('Resistance Band', Icons.horizontal_rule_rounded),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: equipment.map((e) {
        final name = e.$1;
        final icon = e.$2;
        final equipKey = name == 'All' ? null : name.toLowerCase();
        final isSelected = _selectedEquipment == equipKey;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedEquipment = isSelected ? null : equipKey;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 78,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected || (name == 'All' && _selectedEquipment == null)
                  ? AppColors.accent
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected || (name == 'All' && _selectedEquipment == null)
                    ? AppColors.accent
                    : AppColors.cardBorder,
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected || (name == 'All' && _selectedEquipment == null)
                      ? AppColors.textOnAccent
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isSelected || (name == 'All' && _selectedEquipment == null)
                        ? AppColors.textOnAccent
                        : AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipRow(
    List<String> options,
    String? selected,
    Function(String) onTap,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // "All" chip
        GestureDetector(
          onTap: () => onTap(selected ?? ''),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: selected == null ? AppColors.accent : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected == null ? AppColors.accent : AppColors.cardBorder,
                width: 0.5,
              ),
            ),
            child: Text(
              'All',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected == null
                    ? AppColors.textOnAccent
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
        ...options.map((option) {
          final isSelected = selected == option;
          return GestureDetector(
            onTap: () => onTap(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.cardBorder,
                  width: 0.5,
                ),
              ),
              child: Text(
                option,
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
        }),
      ],
    );
  }

  void _applyFilters() {
    final notifier = ref.read(filterProvider.notifier);
    notifier.setEquipment(_selectedEquipment);
    notifier.setDifficulty(_selectedDifficulty);
    notifier.setGoal(_selectedGoal);
    Navigator.of(context).pop();
  }
}
