import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class PasswordRequirements extends StatelessWidget {
  final bool hasMinLength;
  final bool hasNumber;

  const PasswordRequirements({
    super.key,
    required this.hasMinLength,
    required this.hasNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LivestSizes.md),
      decoration: BoxDecoration(
        color: LivestColors.primaryLight,
        borderRadius: BorderRadius.circular(LivestSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password harus memenuhi:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: LivestSizes.fontSizeSm,
              color: LivestColors.textPrimary,
            ),
          ),
          const SizedBox(height: LivestSizes.sm),
          _RequirementRow(
            text: "Minimal 8 karakter",
            isMet: hasMinLength,
          ),
          const SizedBox(height: LivestSizes.xs),
          _RequirementRow(
            text: "Mengandung minimal 1 angka",
            isMet: hasNumber,
          ),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  final bool isMet;

  const _RequirementRow({required this.text, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isMet ? Colors.green : LivestColors.textSecondary,
          size: 16,
        ),
        const SizedBox(width: LivestSizes.sm),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color:
                isMet ? LivestColors.textPrimary : LivestColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
