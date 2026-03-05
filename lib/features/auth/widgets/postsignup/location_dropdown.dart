import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

/// Dropdown pilihan lokasi/provinsi untuk profil peternakan.
class LocationDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;

  const LocationDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = 'Tekan untuk pilih lokasi',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokasi Peternakan',
          style: TextStyle(
            fontSize: LivestSizes.fontSizeSm,
            fontWeight: FontWeight.w500,
            color: LivestColors.textPrimary,
          ),
        ),
        const SizedBox(height: LivestSizes.sm),
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: Text(
            hint,
            style: const TextStyle(
              color: LivestColors.primaryLightActive,
              fontSize: LivestSizes.fontSizeSm,
            ),
          ),
          items: items
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: onChanged,
          style: const TextStyle(
            color: LivestColors.textPrimary,
            fontSize: LivestSizes.fontSizeSm,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: LivestColors.baseWhite,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: const BorderSide(
                color: LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
              borderSide: const BorderSide(
                color: LivestColors.primaryLightActive,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(LivestSizes.inputFieldRadius),
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
