import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/pages/product_form_page.dart';
import 'package:livest/features/breader/marketplace/providers/test_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/product_card.dart';
import 'widgets/empty_product_view.dart';

class TestApiPage extends StatefulWidget {
  const TestApiPage({super.key});

  @override
  State<TestApiPage> createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  final String userId = "086df457-e9b9-4b17-92ea-5fdb349fa9c2";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TestProvider>().getMyProduct(userId);
    });
  }

  void _navigateToAddForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductFormPage(mode: ProductFormMode.add, userId: userId),
      ),
    ).then((_) => context.read<TestProvider>().getMyProduct(userId));
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
    ).then((_) => context.read<TestProvider>().getMyProduct(userId));
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
              await context.read<TestProvider>().deleteProduct(productId);
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
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Column(children: [Text("Total Produk"), Text("10")]),
                ),
                Container(
                  child: Column(children: [Text("Total Terjual"), Text("10")]),
                ),
              ],
            ),
            Column(
              children: [
                Text("Kategori Penjualan"),
                Text(
                  "Sapi",
                  style: TextStyle(backgroundColor: LivestColors.primaryLight),
                ),
              ],
            ),
            CustomButton(
              text: "Tambah Penjualan",
              onPressed: _navigateToAddForm,
            ),
            Text("Riwayat Penjualan"),
            Expanded(
              child: Consumer<TestProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  if (provider.products.isEmpty)
                    return const EmptyProductView();
                  return _buildProductGrid(provider.products);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: LivestColors.baseWhite,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: const Text(
        "Produk Saya",
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20,
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
        mainAxisExtent: 252,
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
