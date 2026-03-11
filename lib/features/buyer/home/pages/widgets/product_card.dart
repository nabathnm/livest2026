import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_image_placeholder.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: LivestColors.textWhite,
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                product.imageUrl ?? '',
                height: 174,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => LivestImagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? "Product",
                    style: LivestTypography.bodyMdSemiBold,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(product.price ?? 0)},-",
                    style: LivestTypography.bodyMdBold.copyWith(
                      color: LivestColors.primaryNormal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.farmName ?? "",
                    style: LivestTypography.captionSmSemibold,
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: LivestColors.primaryLight,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/icon/location.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          product.location ?? "PPPP",
                          style: LivestTypography.captionSmSemibold,
                        ),
                      ],
                    ),
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
