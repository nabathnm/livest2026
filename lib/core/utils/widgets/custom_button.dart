import 'package:flutter/material.dart';

// Enum untuk menentukan varian desain tombol sesuai gambar UI/UX
enum ButtonVariant { primary, secondary, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final double? width;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.width = double.infinity,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6D4C41);
    const Color secondaryColor = Color(0xFFEFEBE9);

    Color backgroundColor;
    Color textColor;
    BorderSide borderSide;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = primaryColor;
        textColor = Colors.white;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.secondary:
        backgroundColor = secondaryColor;
        textColor = primaryColor;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.outlined:
        backgroundColor = Colors.transparent;
        textColor = primaryColor;
        borderSide = const BorderSide(color: primaryColor, width: 2);
        break;
      case ButtonVariant.text:
        backgroundColor = Colors.transparent;
        textColor = primaryColor;
        borderSide = BorderSide.none;
        break;
    }

    final bool isDisabled = onPressed == null || isLoading;
    if (isDisabled && variant != ButtonVariant.text) {
      backgroundColor = Colors.grey[300]!;
      textColor = Colors.grey[600]!;
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
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: borderSide,
          ),
        ),
        child: buttonContent,
      ),
    );
  }
}
