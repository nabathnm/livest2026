import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';

/// Wrapper layout untuk setiap step onboarding:
/// - Top bar (back arrow + progress bar)
/// - Scrollable content
/// - Pinned "Lanjut" button at bottom
class OnboardingStepLayout extends StatelessWidget {
  final int totalSegments;
  final int activeSegment;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final String buttonText;
  final bool isLoading;

  const OnboardingStepLayout({
    super.key,
    required this.totalSegments,
    required this.activeSegment,
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: LivestColors.textPrimary,
                  ),
                  onPressed: onBack,
                )
              else
                const SizedBox(width: 48),
              Expanded(
                child: SegmentedProgressBar(
                  totalSegments: totalSegments,
                  activeSegment: activeSegment,
                ),
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

/// Segmented progress bar untuk onboarding steps
class SegmentedProgressBar extends StatelessWidget {
  final int totalSegments;
  final int activeSegment; // 1-based, 0 if nothing active

  const SegmentedProgressBar({
    super.key,
    required this.totalSegments,
    required this.activeSegment,
  });

  @override
  Widget build(BuildContext context) {
    if (totalSegments <= 1) {
      return Container(
        height: 8,
        decoration: BoxDecoration(
          color: activeSegment == 1
              ? LivestColors.primaryNormal
              : const Color(0xFFEBEBEB),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return Row(
      children: List.generate(totalSegments, (index) {
        final isCompleted = index < activeSegment;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: index == totalSegments - 1 ? 0 : 8),
            height: 8,
            decoration: BoxDecoration(
              color: isCompleted
                  ? LivestColors.primaryNormal
                  : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}
