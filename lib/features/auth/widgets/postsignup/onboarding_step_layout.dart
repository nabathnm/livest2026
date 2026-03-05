import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';

/// Wrapper layout untuk setiap step onboarding:
/// - Top bar (back arrow + progress bar)
/// - Scrollable content
/// - Pinned "Lanjut" button at bottom
class OnboardingStepLayout extends StatelessWidget {
  final double progress;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final String buttonText;
  final bool isLoading;

  const OnboardingStepLayout({
    super.key,
    required this.progress,
    required this.child,
    required this.onNext,
    this.onBack,
    this.buttonText = 'Lanjut',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top bar
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: LivestColors.textPrimary),
                  onPressed: onBack,
                )
              else
                const SizedBox(width: 48),
              Expanded(
                child: OnboardingProgressBar(progress: progress),
              ),
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: child,
          ),
        ),

        // Pinned button
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: CustomButton(
            text: buttonText,
            isLoading: isLoading,
            onPressed: onNext,
          ),
        ),
      ],
    );
  }
}

/// Progress bar linear untuk onboarding steps
class OnboardingProgressBar extends StatelessWidget {
  final double progress;

  const OnboardingProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 8,
        backgroundColor: LivestColors.primaryLightActive,
        valueColor: const AlwaysStoppedAnimation<Color>(
          LivestColors.primaryNormal,
        ),
      ),
    );
  }
}
