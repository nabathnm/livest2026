import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: LivestSizes.fontSizeSm,
            fontWeight: FontWeight.w500,
            color: LivestColors.textPrimary,
          ),
        ),
        const SizedBox(height: LivestSizes.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: LivestColors.baseWhite,
            border: Border.all(color: LivestColors.primaryLightActive, width: 1),
            borderRadius: BorderRadius.circular(90),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: LivestSizes.fontSizeSm,
              color: LivestColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
