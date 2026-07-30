import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Horizontally scrollable muscle/body part chip for the home screen
class MuscleChip extends StatelessWidget {
  final String bodyPart;
  final VoidCallback onTap;

  const MuscleChip({
    super.key,
    required this.bodyPart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        AppConstants.bodyPartDisplayNames[bodyPart] ?? bodyPart;
    final svgIcon = AppConstants.bodyPartSvgIcons[bodyPart];
    final iconData = AppConstants.bodyPartIcons[bodyPart] ??
        const IconData(0xe2cc, fontFamily: 'MaterialIcons');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: svgIcon != null
                    ? SvgPicture.asset(
                        svgIcon,
                        width: 26,
                        height: 26,
                        colorFilter: const ColorFilter.mode(
                          AppColors.accent,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(
                        iconData,
                        size: 22,
                        color: AppColors.accent,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
