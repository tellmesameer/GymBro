import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Profile Avatar ──────────────────────────────────────────
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 40,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Fitness Enthusiast',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Keep pushing your limits! 💪',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // ── Settings Sections ───────────────────────────────────────
            _SettingsSection(
              title: 'Preferences',
              items: [
                _SettingsItem(
                  icon: Icons.dark_mode_rounded,
                  label: 'Theme',
                  trailing: 'Dark',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.straighten_rounded,
                  label: 'Units',
                  trailing: 'Metric (kg)',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  trailing: 'English',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            _SettingsSection(
              title: 'Data',
              items: [
                _SettingsItem(
                  icon: Icons.backup_rounded,
                  label: 'Backup & Restore',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.delete_sweep_rounded,
                  label: 'Clear Cache',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            _SettingsSection(
              title: 'About',
              items: [
                _SettingsItem(
                  icon: Icons.info_outline_rounded,
                  label: 'App Version',
                  trailing: '1.0.0',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.article_outlined,
                  label: 'Licenses',
                  onTap: () {},
                ),
                _SettingsItem(
                  icon: Icons.star_outline_rounded,
                  label: 'Rate App',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ── Footer ──────────────────────────────────────────────────
            Text(
              'GymBro v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Exercise data by exercises-dataset',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary.withValues(alpha: 0.3),
              ),
            ),

            const SizedBox(height: 100),
          ].animate(interval: 50.ms).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 0.5),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  if (index > 0)
                    const Divider(
                      height: 0,
                      indent: 52,
                      color: AppColors.cardBorder,
                    ),
                  item,
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
