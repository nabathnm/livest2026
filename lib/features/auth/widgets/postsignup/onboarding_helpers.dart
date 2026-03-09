import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

/// Error message box dengan background merah muda sesuai design.
class OnboardingErrorBox extends StatelessWidget {
  final String message;

  const OnboardingErrorBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFE53935),
          fontSize: LivestSizes.fontSizeSm,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Header standar untuk setiap step (judul + subtitle)
class OnboardingStepHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextAlign textAlign;

  const OnboardingStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: LivestColors.textPrimary,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: LivestSizes.fontSizeSm,
            color: LivestColors.textSecondary,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
