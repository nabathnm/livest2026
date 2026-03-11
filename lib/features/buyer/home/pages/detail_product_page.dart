import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/core/utils/widgets/livest_button.dart';
import 'package:livest/core/utils/widgets/livest_network_image.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/buyer/cart/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class DetailProductPage extends StatelessWidget {
  final ProductModel product;

  const DetailProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String userId = "4057b852-9814-4c12-b0bc-616ff0cf8077";
    final price = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(product.price ?? 0);

    final date = product.createdAt != null
        ? DateFormat('dd/MM/yyyy').format(product.createdAt!)
        : '-';

    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      appBar: LivestAppbar(name: "Detail Ternak"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            // Hero Image
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LivestNetworkImage(imageUrl: product.imageUrl),
                  SizedBox(height: 16),
                  Text(product.name ?? 'Product', style: LivestTypography.h3),
                  Text(
                    date,
                    style: LivestTypography.bodySm.copyWith(
                      color: LivestColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Text(
                    '$price,-',
                    style: LivestTypography.h3.copyWith(
                      color: LivestColors.primaryNormal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Animal type badge
                  if (product.type != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: LivestColors.primaryLightHover,
                      ),
                      child: Text(
                        product.type!,
                        style: LivestTypography.bodySm.copyWith(
                          color: LivestColors.primaryNormal,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  const Text(
                    'Deskripsi',
                    style: LivestTypography.bodyLgSemiBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description ?? 'Tidak ada deskripsi.',
                    style: LivestTypography.bodyMd.copyWith(
                      color: LivestColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Nomor kontak
                  const Text(
                    'Nomor yang dapat dihubungi',
                    style: LivestTypography.bodyLgSemiBold,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset("assets/images/icon/warning.png"),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Tekan tombol di bawah untuk menghubungi penjual (lewat WhatsApp)',
                          style: LivestTypography.bodySm.copyWith(
                            color: LivestColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    // onTap: _openWhatsApp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(42),
                        color: LivestColors.primaryLight,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/images/icon/kontak.png"),
                          SizedBox(width: 6),
                          Text(
                            'Hubungi Penjual',
                            style: LivestTypography.bodySm.copyWith(
                              color: LivestColors.primaryNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 82), // space for bottom buttons
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 112,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final isInCart = cartProvider.isInCart(product.id);

              return LivestButton(
                text: isInCart ? "Hapus dari keranjang" : "Tambah ke keranjang",
                onPressed: () async {
                  if (isInCart) {
                    await cartProvider.removeFromCart(userId, product);
                  } else {
                    await cartProvider.addToCart(userId, product);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
