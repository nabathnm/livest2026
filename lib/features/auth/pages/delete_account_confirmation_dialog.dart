import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

class DeleteAccountConfirmationDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String cancelText;
  final String confirmText;

  const DeleteAccountConfirmationDialog({
    super.key,
    this.title = 'Yakin ingin menghapus akun?',
    this.subtitle = 'Tindakan ini tidak dapat dikembalikan!',
    this.cancelText = 'Kembali',
    this.confirmText = 'Hapus!',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LivestSizes.cardRadiusLg),
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        LivestSizes.lg,
        LivestSizes.xl,
        LivestSizes.lg,
        LivestSizes.lg,
      ),
      titlePadding: const EdgeInsets.only(
        top: LivestSizes.xl,
        left: LivestSizes.lg,
        right: LivestSizes.lg,
      ),
      backgroundColor: LivestColors.redLight,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: LivestSizes.fontSizeLg,
          color: LivestColors.redNormal,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: LivestSizes.fontSizeSm,
              color: LivestColors.redDark,
            ),
          ),
          const SizedBox(height: LivestSizes.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: LivestColors.redNormal, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(LivestSizes.buttonRadius * 2),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: LivestSizes.md),
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    cancelText,
                    style: const TextStyle(
                      color: LivestColors.redNormal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: LivestSizes.sm + 4),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LivestColors.redNormal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(LivestSizes.buttonRadius * 2),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: LivestSizes.md),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      color: LivestColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

