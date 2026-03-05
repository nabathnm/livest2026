import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';


class AuthFooterLink extends StatelessWidget {
  final String text;
  final String linkText;

  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: LivestColors.textSecondary,
            fontSize: LivestSizes.fontSizeSm,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: LivestColors.primaryNormal,
              fontSize: LivestSizes.fontSizeSm,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
