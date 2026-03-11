import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class CartCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CartCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  String _formatPrice(num price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: LivestColors.textWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ──
            SizedBox(
              width: double.infinity,
              height: 176,
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(),
                    )
                  : _imageFallback(),
            ),

            // ── Product Info ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    product.name ?? 'Produk',
                    style: LivestTypography.bodyMdMedium.copyWith(
                      color: LivestColors.baseBlack,
                    ),
                  ),
                  // Price
                  Text(
                    'Rp ${_formatPrice(product.price ?? 0)},-',
                    style: LivestTypography.bodyMdBold.copyWith(
                      color: LivestColors.primaryNormal,
                    ),
                  ),
                  // Description
                  if (product.description != null &&
                      product.description!.isNotEmpty)
                    Text(
                      product.description!,
                      style: LivestTypography.caption.copyWith(
                        color: LivestColors.baseBlack,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // ── Footer Row: location + delete ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EDE8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/icon/location.png"),
                            const SizedBox(width: 4),
                            Text(
                              product.location ?? 'Jawa Timur',
                              style: LivestTypography.captionSmSemibold
                                  .copyWith(
                                    color: LivestColors.primaryNormal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Delete button
                      GestureDetector(
                        onTap: onDelete,
                        child: Image.asset("assets/images/icon/trash.png"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: const Color(0xFFF0EDE8),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }
}
