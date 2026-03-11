import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

enum LivestButtonVariant { primary, secondary, outline, delete, deleteOutline }

enum LivestButtonSize { small, medium, large }

class LivestButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  final LivestButtonVariant variant;
  final LivestButtonSize size;

  final IconData? icon;
  final bool fullWidth;

  const LivestButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = LivestButtonVariant.primary,
    this.size = LivestButtonSize.medium,
    this.icon,
    this.fullWidth = true,
  });

  double get _height {
    switch (size) {
      case LivestButtonSize.small:
        return 40;
      case LivestButtonSize.medium:
        return 48;
      case LivestButtonSize.large:
        return 56;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case LivestButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12);
      case LivestButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16);
      case LivestButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20);
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case LivestButtonSize.small:
        return LivestTypography.bodySmSemiBold;
      case LivestButtonSize.medium:
        return LivestTypography.bodyMdSemiBold;
      case LivestButtonSize.large:
        return LivestTypography.bodyLgBold;
    }
  }

  ButtonStyle _buttonStyle() {
    switch (variant) {
      case LivestButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: LivestColors.primaryNormal,
          foregroundColor: LivestColors.baseWhite,
          elevation: 0,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        );

      case LivestButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: LivestColors.primaryLight,
          foregroundColor: LivestColors.primaryNormal,
          elevation: 0,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        );

      case LivestButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: LivestColors.primaryNormal,
          padding: _padding,
          side: const BorderSide(color: LivestColors.primaryNormal, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        );

      case LivestButtonVariant.delete:
        return ElevatedButton.styleFrom(
          backgroundColor: LivestColors.redNormal,
          foregroundColor: LivestColors.textWhite,
          elevation: 0,
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        );

      case LivestButtonVariant.deleteOutline:
        return OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: LivestColors.redNormal,
          backgroundColor: Colors.transparent,
          padding: _padding,
          side: const BorderSide(color: LivestColors.redNormal, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        );
    }
  }

  Widget _child() {
    final textWidget = Text(text, style: _textStyle);

    if (icon == null) return textWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), textWidget],
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = variant == LivestButtonVariant.outline
        ? OutlinedButton(
            onPressed: onPressed,
            style: _buttonStyle(),
            child: _child(),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: _buttonStyle(),
            child: _child(),
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _height,
      child: button,
    );
  }
}
