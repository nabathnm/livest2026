import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class SuggestedQuestionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SuggestedQuestionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: LivestColors.primaryLight, // f2eeea mapped color
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: LivestColors.textHeading,
              fontSize: LivestSizes.fontSizeSm,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
