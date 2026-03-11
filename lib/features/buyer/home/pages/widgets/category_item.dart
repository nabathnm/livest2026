import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class CategoryItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String price;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 110,
        width: 102,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath),
            Text(title, style: LivestTypography.bodyMdMedium),
            const SizedBox(height: 8),
            Container(
              alignment: .center,
              width: 102,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: LivestColors.greenLight,
              ),
              child: Row(
                spacing: 8,
                mainAxisAlignment: .center,
                children: [
                  Image.asset('assets/images/icon/harganaik.png'),
                  Text(price, style: LivestTypography.bodySm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
