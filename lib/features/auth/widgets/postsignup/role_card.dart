import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

/// Kartu pilihan role (Peternak / Pembeli Ternak)
class RoleCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? LivestColors.primaryLight
              : LivestColors.baseWhite,
          border: Border.all(
            color: isSelected
                ? LivestColors.primaryNormal
                : LivestColors.primaryLightActive,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 100, fit: BoxFit.contain),
            const SizedBox(height: 12),
            Text(
              label,
              style: LivestTypography.bodySmMedium.copyWith(
                color: isSelected
                    ? LivestColors.primaryNormal
                    : LivestColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
