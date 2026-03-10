import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class ProfileSettingButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileSettingButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(LivestSizes.borderRadiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: LivestSizes.md, vertical: LivestSizes.md),
        decoration: BoxDecoration(
          color: LivestColors.primaryLight, // Light background for settings button
          borderRadius: BorderRadius.circular(LivestSizes.borderRadiusLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: LivestColors.textPrimary,
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, size: 18, color: LivestColors.textPrimary),
          ],
        ),
      ),
    );
  }
}
