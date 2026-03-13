import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/breader/marketplace/providers/marketplace_provider.dart';
import 'package:livest/features/buyer/home/pages/widgets/product_card.dart';
import 'package:livest/features/buyer/home/pages/detail_product_page.dart';
import 'package:provider/provider.dart';

class SellerProfilePage extends StatefulWidget {
  final String sellerId;

  const SellerProfilePage({super.key, required this.sellerId});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchSellerProfile(widget.sellerId);
      context.read<MarketplaceProvider>().getMyProduct(widget.sellerId);
    });
  }

  @override
  void dispose() {
    // Bersihkan seller profile saat halaman ditutup
    context.read<ProfileProvider>().clearSellerProfile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      appBar: LivestAppbar(name: "Profile Penjual"),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          if (profileProvider.isLoadingSellerProfile) {
            return const Center(
              child: CircularProgressIndicator(
                color: LivestColors.primaryNormal,
              ),
            );
          }

          final seller = profileProvider.sellerProfile;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Seller Info ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: LivestColors.primaryLightHover,
                      backgroundImage: seller?.avatarUrl != null
                          ? NetworkImage(seller!.avatarUrl!)
                          : null,
                      child: seller?.avatarUrl == null
                          ? const Icon(
                              Icons.person,
                              size: 32,
                              color: LivestColors.primaryNormal,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (seller?.farmName != null &&
                              seller!.farmName!.isNotEmpty) ...[
                            Text(
                              seller.farmName!,
                              style: LivestTypography.bodyLgBold.copyWith(),
                            ),
                          ],
                          if (seller?.farmLocation != null &&
                              seller!.farmLocation!.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: LivestColors.greenDark,
                              ),
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min, // supaya tidak full width
                                children: [
                                  Image.asset(
                                    "assets/images/icon/sellerlocation.png",
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      seller.farmLocation!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: LivestTypography.bodySmSemiBold
                                          .copyWith(
                                            color: LivestColors.textWhite,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Text("Deskripsi", style: LivestTypography.bodyLgSemiBold),
                if (seller?.description != null &&
                    seller!.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    seller.description!,
                    style: LivestTypography.bodySmMedium,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 32),

                // ── Produk Grid ──
                Text(
                  'Ternak yang dijual',
                  style: LivestTypography.bodyLgSemiBold,
                ),
                const SizedBox(height: 16),
                _buildProductGrid(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(
                color: LivestColors.primaryNormal,
              ),
            ),
          );
        }

        // ✅ Filter hanya produk yang belum terjual
        final activeProducts = provider.products
            .where((p) => p.isSold == false)
            .toList();

        if (activeProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Belum ada produk tersedia',
                style: LivestTypography.bodyMd.copyWith(
                  color: LivestColors.textSecondary,
                ),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activeProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 314,
          ),
          itemBuilder: (context, index) {
            final product = activeProducts[index];
            return ProductCard(
              product: product,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailProductPage(product: product),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
