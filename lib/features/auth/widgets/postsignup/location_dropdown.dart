import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

/// Dropdown pilihan lokasi/provinsi untuk profil peternakan.
class LocationDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final bool hasError;

  const LocationDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = 'Tekan untuk pilih lokasi',
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lokasi Peternakan',
          style: LivestTypography.bodySmMedium.copyWith(
            color: LivestColors.textPrimary,
          ),
        ),
        const SizedBox(height: LivestSizes.sm),
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(
            hint,
            style: LivestTypography.bodySm.copyWith(
              color: LivestColors.primaryLightActive,
            ),
          ),
          items: items
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFFF1EBE6),
          borderRadius: BorderRadius.circular(16),
          style: LivestTypography.bodySm.copyWith(
            color: LivestColors.textPrimary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: LivestColors.baseWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFE53935)
                    : LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFE53935)
                    : LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: const BorderSide(
                color: LivestColors.primaryNormal,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
