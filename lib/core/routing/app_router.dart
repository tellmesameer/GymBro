import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/muscles/muscle_selector_screen.dart';
import '../../presentation/exercise_list/exercise_list_screen.dart';
import '../../presentation/exercise_details/exercise_detail_screen.dart';
import '../../presentation/filters/filter_screen.dart';
import '../../presentation/favorites/favorites_screen.dart';
import '../../presentation/workout/workout_list_screen.dart';
import '../../presentation/workout/workout_detail_screen.dart';
import '../../presentation/settings/profile_screen.dart';
import '../../presentation/recent/recent_exercises_screen.dart';
import '../widgets/bottom_nav_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // ── Splash ────────────────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Shell with Bottom Navigation ──────────────────────────────────────
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => BottomNavShell(child: child),
      routes: [
        // Home Tab
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),

        // Muscles Tab
        GoRoute(
          path: '/muscles',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MusclesSelectorScreen(),
          ),
        ),

        // Workouts Tab
        GoRoute(
          path: '/workouts',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WorkoutListScreen(),
          ),
        ),

        // Favorites Tab
        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FavoritesScreen(),
          ),
        ),

        // Profile Tab
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // ── Exercise List (outside shell for full-screen) ─────────────────────
    GoRoute(
      path: '/exercises/:bodyPart',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final bodyPart = state.pathParameters['bodyPart'] ?? 'chest';
        return ExerciseListScreen(bodyPart: bodyPart);
      },
    ),

    // ── Recent Exercises ──────────────────────────────────────────────────
    GoRoute(
      path: '/recent',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecentExercisesScreen(),
    ),

    // ── Exercise Detail ───────────────────────────────────────────────────
    GoRoute(
      path: '/exercise/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ExerciseDetailScreen(exerciseId: id);
      },
    ),

    // ── Filters (full-screen modal) ───────────────────────────────────────
    GoRoute(
      path: '/filters',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        final bodyPart = state.uri.queryParameters['bodyPart'];
        return CustomTransitionPage(
          child: FilterScreen(bodyPart: bodyPart),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        );
      },
    ),

    // ── Workout Detail ────────────────────────────────────────────────────
    GoRoute(
      path: '/workout/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return WorkoutDetailScreen(workoutId: id);
      },
    ),
  ],
);
