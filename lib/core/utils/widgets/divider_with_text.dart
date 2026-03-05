import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

/// Divider horizontal dengan teks di tengah.
/// Sesuai component set: garis — teks — garis.
class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, this.text = "atau"});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: LivestColors.primaryLightActive),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LivestSizes.md),
          child: Text(
            text,
            style: const TextStyle(
              color: LivestColors.textSecondary,
              fontSize: LivestSizes.fontSizeSm,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: LivestColors.primaryLightActive),
        ),
      ],
    );
  }
}
