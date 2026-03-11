import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class BuyerProfileInfoField extends StatelessWidget {
  final String label;
  final String value;

  const BuyerProfileInfoField({
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
          style: LivestTypography.bodySmMedium.copyWith(
            color: LivestColors.textPrimary,
          ),
        ),
        const SizedBox(height: LivestSizes.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: LivestSizes.md,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: LivestColors.baseWhite,
            borderRadius: BorderRadius.circular(90), // Pill Shape
            border: Border.all(
              color: LivestColors.primaryLightActive,
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: LivestTypography.bodySm.copyWith(
              color: LivestColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
