import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/core/utils/widgets/livest_button.dart';
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
  final String userId = "086df457-e9b9-4b17-92ea-5fdb349fa9c2";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MarketplaceProvider>().getMyProduct(userId);
    });
  }

  void _getProductCount() {
    final productProvider = context.read<MarketplaceProvider>();

    int totalProduct = productProvider.products.length;

    print(totalProduct);
  }

  void _navigateToAddForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductFormPage(mode: ProductFormMode.add, userId: userId),
      ),
    ).then((_) => context.read<MarketplaceProvider>().getMyProduct(userId));
  }

  void _navigateToEditForm(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormPage(
          mode: ProductFormMode.edit,
          userId: userId,
          existingProduct: product,
        ),
      ),
    ).then((_) => context.read<MarketplaceProvider>().getMyProduct(userId));
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
          crossAxisAlignment: .start,
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
                SizedBox(width: 16),
                Expanded(
                  child: StatsCard(title: "Hasil Penjualan", value: "0"),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  width: 1,
                  color: LivestColors.primaryLightActive,
                ),
              ),
              child: Column(
                spacing: 10,
                children: [
                  Text(
                    "Ternak yang pernah kamu jual",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: LivestColors.textHeading,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: LivestColors.primaryLightHover,
                    ),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      "Belum ada penjualan!",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: LivestColors.primaryNormal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Riwayat Penjualan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 24),
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
        mainAxisExtent: 258,
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
