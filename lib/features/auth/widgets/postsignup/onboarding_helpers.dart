import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

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
        style: LivestTypography.captionSmSemibold.copyWith(
          color: const Color(0xFFE53935),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Header standar untuk setiap step 
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
          style: LivestTypography.displayMd.copyWith(
            color: LivestColors.textPrimary,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: LivestTypography.bodySm.copyWith(
            color: LivestColors.textSecondary,
          ),
          textAlign: textAlign,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
