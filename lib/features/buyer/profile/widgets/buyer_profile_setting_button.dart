import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class BuyerProfileSettingButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;

  const BuyerProfileSettingButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.backgroundColor = LivestColors.primaryLightActive,
    this.textColor = LivestColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(LivestSizes.cardRadiusMd),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(LivestSizes.cardRadiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: LivestSizes.sm),
            Text(
              title,
              style: LivestTypography.bodyMdSemiBold.copyWith(color: textColor),
            ),
            if (title != 'Keluar dari akun') ...[
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, color: textColor, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
