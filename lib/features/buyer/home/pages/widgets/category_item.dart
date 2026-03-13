import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class CategoryItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String price;
  final String icon;
  final Color bgColor;
  final Color txColor;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.price,
    required this.icon,
    required this.bgColor,
    required this.txColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(color: LivestColors.primaryLight, width: 1),
          ),
          borderRadius: BorderRadius.circular(24),
          color: LivestColors.baseBackground,
        ),
        width: 102,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Image.asset(iconPath),
            Text(title, style: LivestTypography.bodyMdMedium),
            const SizedBox(height: 8),
            Container(
              alignment: Alignment.center, // ✅ Fix: .center → Alignment.center
              width: 102,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: bgColor,
              ),
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment
                    .center, // ✅ Fix: .center → MainAxisAlignment.center
                children: [
                  Image.asset(icon),
                  Text(
                    price,
                    style: LivestTypography.bodySm.copyWith(color: txColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
