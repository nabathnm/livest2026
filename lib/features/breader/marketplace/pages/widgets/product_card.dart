import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/pages/marketplace_page.dart';
import 'package:livest/features/breader/marketplace/pages/product_detail_page.dart';
import 'package:livest/features/breader/marketplace/providers/marketplace_provider.dart';
import 'package:provider/provider.dart';
import 'image_placeholder.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  Future<void> _goToDetail(BuildContext context, ProductModel product) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductDetailPage(product: product, userId: product.userId),
      ),
    ).then((_) => context.read<MarketplaceProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToDetail(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: LivestColors.neutralLightActive,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    _buildImage(),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          _buildName(),
                          SizedBox(height: 4),
                          Text(
                            style: LivestTypography.caption.copyWith(
                              color: LivestColors.textSecondary,
                            ),
                            product.createdAt != null
                                ? DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(product.createdAt!)
                                : "Tanggal tidak tersedia",
                          ),
                          SizedBox(height: 4),
                          _buildPrice(),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: product.isSold == true
                            ? LivestColors.greenLightHover
                            : LivestColors.primaryLightHover,
                      ),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            product.isSold == true
                                ? 'assets/images/icon/checkgreen.png'
                                : 'assets/images/icon/checkyellow.png',
                          ),
                          Text(
                            style: LivestTypography.bodySm.copyWith(
                              color: LivestColors.primaryNormal,
                            ),
                            product.isSold == true
                                ? "Terjual"
                                : "Tandai Terjual",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: product.imageUrl != null
          ? Image.network(
              product.imageUrl!,
              height: 128,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("IMAGE ERROR: $error");
                return const ImagePlaceholder();
              },
            )
          : const ImagePlaceholder(),
    );
  }

  Widget _buildName() {
    return Text(
      product.name ?? "Produk",
      style: LivestTypography.bodyMd,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPrice() {
    final price = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(product.price ?? 0);
    return Text(
      ('$price,-'),
      style: LivestTypography.bodySmBold.copyWith(
        color: LivestColors.primaryNormal,
      ),
    );
  }
}
