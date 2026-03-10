import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class CustomSuccessDialog extends StatelessWidget {
  final String title;
  final String dismissText;
  final VoidCallback onDismiss;

  const CustomSuccessDialog({
    super.key,
    required this.title,
    this.dismissText = "Tekan untuk lewati",
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(LivestSizes.cardRadiusLg)),
      contentPadding: const EdgeInsets.all(LivestSizes.xl),
      backgroundColor: LivestColors.primaryLight, 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: LivestColors.textHeading,
            size: 48,
          ),
          const SizedBox(height: LivestSizes.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: LivestSizes.fontSizeLg + 2,
              color: LivestColors.textHeading,
            ),
          ),
          const SizedBox(height: LivestSizes.lg),
          GestureDetector(
            onTap: onDismiss,
            child: Text(
              dismissText,
              style: const TextStyle(
                fontSize: LivestSizes.fontSizeSm, 
                color: LivestColors.primaryNormal,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
