import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../providers/exercise_providers.dart';
import '../providers/favorites_provider.dart';
import '../providers/recent_provider.dart';
import '../providers/workout_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String _statusText = 'Initializing...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Step 1: Initialize exercise database
      setState(() {
        _statusText = 'Loading exercises...';
        _progress = 0.2;
      });
      final repo = ref.read(exerciseRepositoryProvider);
      await repo.initialize();

      // Step 2: Initialize favorites
      setState(() {
        _statusText = 'Loading favorites...';
        _progress = 0.5;
      });
      await ref.read(favoritesProvider.notifier).initialize();

      // Step 3: Initialize recent
      setState(() {
        _statusText = 'Loading recent...';
        _progress = 0.7;
      });
      await ref.read(recentProvider.notifier).initialize();

      // Step 4: Initialize workouts
      setState(() {
        _statusText = 'Loading workouts...';
        _progress = 0.9;
      });
      await ref.read(workoutProvider.notifier).initialize();

      // Done!
      setState(() {
        _statusText = 'Ready!';
        _progress = 1.0;
      });

      // Brief delay to show completion
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to home
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _statusText = 'Error: $e';
      });
      // Navigate anyway after a delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPure,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),

            // App Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.fitness_center_rounded,
                size: 48,
                color: AppColors.accent,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 600.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            // App Name
            const Text(
              'GymBro',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -1,
              ),
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 8),

            Text(
              'Your Fitness Companion',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                letterSpacing: 2,
                fontWeight: FontWeight.w300,
              ),
            )
                .animate(delay: 400.ms)
                .fadeIn(duration: 500.ms),

            const Spacer(flex: 2),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                children: [
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: AppColors.surfaceLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status text
                  Text(
                    _statusText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            )
                .animate(delay: 600.ms)
                .fadeIn(duration: 400.ms),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
