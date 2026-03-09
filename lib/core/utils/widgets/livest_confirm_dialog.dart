import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_button.dart';

enum LivestDialogVariant { primary, delete }

class LivestConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmText;
  final VoidCallback onConfirm;
  final LivestDialogVariant variant;

  const LivestConfirmDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.confirmText,
    required this.onConfirm,
    this.variant = LivestDialogVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDelete = variant == LivestDialogVariant.delete;

    return AlertDialog(
      backgroundColor: isDelete
          ? LivestColors.redLight
          : LivestColors.primaryLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: LivestTypography.bodyLgBold.copyWith(
              color: isDelete
                  ? LivestColors.redNormal
                  : LivestColors.textHeading,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: LivestTypography.bodyMd.copyWith(
              color: isDelete
                  ? LivestColors.redNormal
                  : LivestColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: isDelete
                    ? LivestButton(
                        variant: LivestButtonVariant.deleteOutline,
                        size: LivestButtonSize.small,
                        text: "Kembali",
                        onPressed: () => Navigator.pop(context),
                      )
                    : LivestButton(
                        variant: LivestButtonVariant.outline,
                        size: LivestButtonSize.small,
                        text: "Kembali",
                        onPressed: () => Navigator.pop(context),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isDelete
                    ? LivestButton(
                        variant: LivestButtonVariant.delete,
                        size: LivestButtonSize.small,
                        text: confirmText,
                        onPressed: onConfirm,
                      )
                    : LivestButton(
                        size: LivestButtonSize.small,
                        text: confirmText,
                        onPressed: onConfirm,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
