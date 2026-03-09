import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

/// Kartu pilihan satu jenis ternak (Sapi, Ayam, dll)
class AnimalCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimalCard({
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: LivestSizes.fontSizeSm,
                color: isSelected
                    ? LivestColors.primaryNormal
                    : LivestColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
