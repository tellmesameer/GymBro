import 'package:flutter/material.dart';

/// GymBro color palette — OLED-optimized dark theme with lime accent
class AppColors {
  AppColors._();

  // ── Brand Accent ──────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF9FEA2E);
  static const Color accentDark = Color(0xFF7BC41E);
  static const Color accentLight = Color(0xFFB8F05A);

  // ── Backgrounds (OLED optimized) ──────────────────────────────────────────
  static const Color background = Color(0xFF0A0A0A);
  static const Color backgroundPure = Color(0xFF000000);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceLight = Color(0xFF1C1C1E);
  static const Color surfaceElevated = Color(0xFF242426);
  static const Color surfaceHighlight = Color(0xFF2C2C2E);

  // ── Card ──────────────────────────────────────────────────────────────────
  static const Color card = Color(0xFF1A1A1C);
  static const Color cardBorder = Color(0xFF2A2A2C);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color textTertiary = Color(0xFF6B6B6B);
  static const Color textOnAccent = Color(0xFF0A0A0A);

  // ── Muscle Highlights ─────────────────────────────────────────────────────
  static const Color muscleDefault = Color(0xFF2A4A1A);
  static const Color muscleHighlight = Color(0xFF9FEA2E);
  static const Color muscleHover = Color(0xFF4A7A2A);
  static const Color muscleOutline = Color(0xFF3A5A2A);
  static const Color bodyOutline = Color(0xFF555555);
  static const Color bodyFill = Color(0xFF1A2A10);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF4757);
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);

  // ── Difficulty ────────────────────────────────────────────────────────────
  static const Color beginner = Color(0xFF2ED573);
  static const Color intermediate = Color(0xFFFFA502);
  static const Color advanced = Color(0xFFFF4757);

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  static const Color navActive = accent;
  static const Color navInactive = Color(0xFF6B6B6B);
  static const Color navBackground = Color(0xFF0F0F0F);

  // ── Shimmer / Loading ─────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFF1C1C1E);
  static const Color shimmerHighlight = Color(0xFF2C2C2E);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF9FEA2E), Color(0xFF6BC41E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2A10), Color(0xFF0A0A0A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x88000000),
      Color(0xDD000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
