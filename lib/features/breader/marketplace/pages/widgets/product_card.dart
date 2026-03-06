import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'image_placeholder.dart';
import '../helpers/price_formatter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              // _buildCategoryBadge(),
              // const SizedBox(height: 6),
              _buildName(),
              const SizedBox(height: 2),
              // _buildDescription(),
              _buildPrice(),
              // const SizedBox(height: 6),
              // _buildLocationAndActions(),
              ElevatedButton(onPressed: () {}, child: Text("Tandai Terjual")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: product.imageUrl != null
          ? Image.network(
              product.imageUrl!,
              height: 128,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ImagePlaceholder(),
            )
          : const ImagePlaceholder(),
    );
  }

  // Widget _buildCategoryBadge() {
  //   if (product.type == null || product.type!.isEmpty) {
  //     return const SizedBox.shrink();
  //   }
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //     decoration: BoxDecoration(
  //       color: Colors.green[50],
  //       borderRadius: BorderRadius.circular(6),
  //     ),
  //     child: Text(
  //       product.type!,
  //       style: TextStyle(
  //         fontSize: 10,
  //         color: Colors.green[700],
  //         fontWeight: FontWeight.w600,
  //       ),
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //   );
  // }

  Widget _buildName() {
    return Text(
      product.name ?? "Produk",
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      product.description ?? "",
      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPrice() {
    return Text(
      formatPrice(product.price),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: LivestColors.primaryNormal,
      ),
    );
  }

  Widget _buildLocationAndActions() {
    return Row(
      children: [
        Icon(Icons.location_on, size: 11, color: Colors.grey[400]),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            product.location ?? "",
            style: TextStyle(fontSize: 10, color: Colors.grey[400]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildActionButton(
          onTap: onEdit,
          icon: Icons.edit_outlined,
          color: Colors.blue,
        ),
        const SizedBox(width: 6),
        _buildActionButton(
          onTap: onDelete,
          icon: Icons.delete_outline,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required MaterialColor color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color[50],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: color[600]),
      ),
    );
  }
}
