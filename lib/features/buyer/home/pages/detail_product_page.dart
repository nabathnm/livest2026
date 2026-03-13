import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/core/utils/widgets/livest_button.dart';
import 'package:livest/core/utils/widgets/livest_network_image.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/buyer/cart/providers/cart_provider.dart';
import 'package:livest/features/buyer/home/pages/seller_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailProductPage extends StatelessWidget {
  final ProductModel product;

  const DetailProductPage({super.key, required this.product});

  Future<void> _openWhatsApp(BuildContext context) async {
    final raw = product.phone?.trim() ?? '';

    if (raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor penjual tidak tersedia')),
      );
      return;
    }

    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final normalized = digits.startsWith('0')
        ? '62${digits.substring(1)}'
        : digits.startsWith('62')
        ? digits
        : '62$digits';

    final uri = Uri.parse('https://wa.me/$normalized');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String userId = context.read<ProfileProvider>().id ?? '';

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
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LivestNetworkImage(imageUrl: product.imageUrl),
                  const SizedBox(height: 16),
                  Text(product.name ?? 'Product', style: LivestTypography.h3),
                  Text(
                    date,
                    style: LivestTypography.bodySm.copyWith(
                      color: LivestColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$price,-',
                    style: LivestTypography.h3.copyWith(
                      color: LivestColors.primaryNormal,
                    ),
                  ),
                  const SizedBox(height: 16),
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

                  const SizedBox(height: 24),
                  if (product.userId != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SellerProfilePage(sellerId: product.userId!),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          // Avatar placeholder
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: LivestColors.primaryLightHover,
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: LivestColors.primaryNormal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.breaderName ?? 'Nama Peternak',
                                  style: LivestTypography.bodyMdBold,
                                ),
                                if (product.farmName != null)
                                  Text(
                                    product.farmName!,
                                    style: LivestTypography.bodySm.copyWith(
                                      color: LivestColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── END SELLER PROFILE BUTTON ──
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
                    onTap: () => _openWhatsApp(context),
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
                          const SizedBox(width: 6),
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
                  const SizedBox(height: 82),
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
              final isInCart = cartProvider.isInCart(product.id!);

              return LivestButton(
                text: isInCart ? "Hapus dari keranjang" : "Tambah ke keranjang",
                onPressed: userId.isEmpty
                    ? null
                    : () async {
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
