import 'package:flutter/material.dart';
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
        child: Column(
          spacing: 4,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? "Product",
                  style: LivestTypography.bodyMdSemiBold,
                ),
                Text(
                  "Rp ${product.price ?? 0}",
                  style: LivestTypography.bodySmSemiBold,
                ),
                Text(
                  product.location ?? "",
                  style: LivestTypography.captionSmSemibold,
                ),
                Text(
                  product.location ?? "",
                  style: LivestTypography.captionSmSemibold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
