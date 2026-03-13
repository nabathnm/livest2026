import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

enum ButtonVariant { primary, secondary, outlined, text, google }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final double? width;
  final IconData? icon;
  final String? imagePath;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.width = double.infinity,
    this.icon,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    const Color secondaryColor = Color(0xFFEFEBE9);
    Color backgroundColor;
    Color textColor;
    BorderSide borderSide;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = LivestColors.primaryNormal;
        textColor = LivestColors.baseWhite;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.secondary:
        backgroundColor = secondaryColor;
        textColor = LivestColors.primaryNormal;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        textColor = LivestColors.primaryNormal;
        borderSide = const BorderSide(
          color: LivestColors.primaryLightActive,
          width: 1.5,
        );
        break;
      case ButtonVariant.text:
        backgroundColor = Colors.transparent;
        textColor = LivestColors.primaryNormal;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.google:
        backgroundColor = LivestColors.primaryLight;
        textColor = LivestColors.textHeading;
        borderSide = BorderSide.none;
        break;
    }

    final bool isDisabled = onPressed == null || isLoading;
    if (isDisabled && variant != ButtonVariant.text) {
      backgroundColor = LivestColors.primaryLightActive;
      textColor = LivestColors.textSecondary;
      borderSide = BorderSide.none;
    }

    final Widget buttonContent = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: textColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor, size: 20),
                const SizedBox(width: 8),
              ] else if (imagePath != null) ...[
                if (imagePath!.startsWith('http'))
                  Image.network(imagePath!, height: 24, width: 24)
                else
                  Image.asset(imagePath!, height: 24, width: 24),
                const SizedBox(width: 12),
              ],
              Text(
                text,
                style: LivestTypography.buttonMd.copyWith(color: textColor),
              ),
            ],
          );

    if (variant == ButtonVariant.text) {
      return SizedBox(
        width: width,
        child: TextButton(
          onPressed: isDisabled ? null : onPressed,
          child: buttonContent,
        ),
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LivestSizes.buttonRadius),
            side: borderSide,
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}
