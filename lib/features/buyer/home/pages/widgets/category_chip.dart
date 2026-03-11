import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.title,
    this.backgroundColor = LivestColors.primaryLightHover,
    this.textColor = LivestColors.primaryNormal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(),
          borderRadius: BorderRadius.circular(90),
          color: backgroundColor,
        ),
        child: Text(
          title,
          style: LivestTypography.bodySmMedium.copyWith(color: textColor),
        ),
      ),
    );
  }
}
