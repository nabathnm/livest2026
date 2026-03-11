import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/core/utils/widgets/livest_button.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/pages/product_form_page.dart';
import 'package:livest/features/breader/marketplace/pages/widgets/stats_card.dart';
import 'package:livest/features/breader/marketplace/providers/marketplace_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/product_card.dart';
import 'widgets/empty_product_view.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String get _userId => context.read<ProfileProvider>().id ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = context.read<ProfileProvider>().id;
      if (id != null && id.isNotEmpty) {
        context.read<MarketplaceProvider>().getMyProduct(id);
      }
    });
  }

  void _navigateToAddForm() {
    if (_userId.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductFormPage(mode: ProductFormMode.add, userId: _userId),
      ),
    ).then((_) {
      if (_userId.isNotEmpty) {
        context.read<MarketplaceProvider>().getMyProduct(_userId);
      }
    });
  }

  void _navigateToEditForm(ProductModel product) {
    if (_userId.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormPage(
          mode: ProductFormMode.edit,
          userId: _userId,
          existingProduct: product,
        ),
      ),
    ).then((_) {
      if (_userId.isNotEmpty) {
        context.read<MarketplaceProvider>().getMyProduct(_userId);
      }
    });
  }

  void _confirmDelete(int productId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah kamu yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<MarketplaceProvider>().deleteProduct(
                productId,
              );
              if (mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      appBar: LivestAppbar(name: "Pasar"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: "Total Produk",
                    value: context
                        .watch<MarketplaceProvider>()
                        .productCount
                        .toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    title: "Hasil Penjualan",
                    value: context
                        .watch<MarketplaceProvider>()
                        .gettotalSoldPrice
                        .toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 1,
                  color: LivestColors.primaryLightActive,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Ternak yang pernah kamu jual",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: LivestColors.textHeading,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Builder(
                    builder: (context) {
                      final types = context
                          .watch<MarketplaceProvider>()
                          .productTypes;

                      if (types.isEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: LivestColors.primaryLightHover,
                          ),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: const Text(
                            "Belum ada penjualan!",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: LivestColors.primaryNormal,
                            ),
                          ),
                        );
                      }

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: types.map((type) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: LivestColors.primaryLightHover,
                            ),
                            child: Text(
                              type,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: LivestColors.primaryNormal,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Riwayat Penjualan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<MarketplaceProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: LivestColors.primaryNormal,
                      ),
                    );
                  }
                  if (provider.products.isEmpty) {
                    return const EmptyProductView();
                  }
                  return _buildProductGrid(provider.products);
                },
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
          child: LivestButton(
            text: "Tambah Penjualan",
            onPressed: _navigateToAddForm,
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 260,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onEdit: () => _navigateToEditForm(product),
          onDelete: () => _confirmDelete(product.id),
        );
      },
    );
  }
}
