import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class ProductDetailModel {
  final String id;
  final String name;
  final String imagePath;
  final List<String> imageGallery;
  final String price;
  final String unit;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final String sellerName;
  final String sellerLocation;
  final String sellerAvatar;
  final bool sellerVerified;
  final String description;
  final List<String> labels;
  final String weight;
  final String age;
  final String breed;
  final int stock;

  const ProductDetailModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.imageGallery,
    required this.price,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.sellerName,
    required this.sellerLocation,
    required this.sellerAvatar,
    required this.sellerVerified,
    required this.description,
    required this.labels,
    required this.weight,
    required this.age,
    required this.breed,
    required this.stock,
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────

final sampleProduct = ProductDetailModel(
  id: '1',
  name: 'Sapi Limosin Jantan',
  imagePath: 'assets/images/products/sapi.png',
  imageGallery: [
    'assets/images/products/sapi.png',
    'assets/images/products/sapi2.png',
    'assets/images/products/sapi3.png',
  ],
  price: 'Rp 18.500.000',
  unit: 'per ekor',
  rating: 4.8,
  reviewCount: 124,
  soldCount: 320,
  sellerName: 'Peternakan Pak Budi',
  sellerLocation: 'Malang, Jawa Timur',
  sellerAvatar: 'assets/images/sellers/budi.png',
  sellerVerified: true,
  description:
      'Sapi Limosin jantan dengan bobot ideal untuk kebutuhan kurban maupun konsumsi. '
      'Dipelihara secara higienis dengan pakan berkualitas tinggi. '
      'Sehat, tidak cacat, dan siap kirim ke seluruh Jawa Timur.',
  labels: ['Kurban', 'Segar', 'Premium', 'Halal'],
  weight: '450 kg',
  age: '3 Tahun',
  breed: 'Limosin',
  stock: 5,
);

// ─── Detail Product Page ──────────────────────────────────────────────────────

class DetailProduct extends StatefulWidget {
  final ProductDetailModel product;

  const DetailProduct({super.key, required this.product});

  // Convenience constructor with sample data for development
  factory DetailProduct.sample() => DetailProduct(product: sampleProduct);

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  int _selectedImageIndex = 0;
  int _quantity = 1;
  bool _isFavorite = false;
  bool _descriptionExpanded = false;

  ProductDetailModel get p => widget.product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: Stack(
        children: [
          // ── Scrollable content ──
          CustomScrollView(
            slivers: [
              // ── App bar with image gallery ──
              _buildSliverAppBar(context),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // ── Image thumbnails ──
                    _buildImageThumbnails(),
                    const SizedBox(height: 16),

                    // ── Product info card ──
                    _buildProductInfoCard(),
                    const SizedBox(height: 12),

                    // ── Spec card ──
                    _buildSpecCard(),
                    const SizedBox(height: 12),

                    // ── Seller card ──
                    _buildSellerCard(),
                    const SizedBox(height: 12),

                    // ── Description card ──
                    _buildDescriptionCard(),

                    // Bottom padding for the sticky footer
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ],
          ),

          // ── Sticky bottom bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  // ── Sliver App Bar ──────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: const Icon(Icons.arrow_back_rounded, size: 20),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _isFavorite = !_isFavorite),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
              ],
            ),
            child: Icon(
              _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: 20,
              color: _isFavorite ? Colors.redAccent : Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: Icon(
            Icons.share_rounded,
            size: 20,
            color: Colors.grey.shade600,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          p.imageGallery.isNotEmpty
              ? p.imageGallery[_selectedImageIndex]
              : p.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: LivestColors.primaryNormal.withOpacity(0.1),
            child: Icon(
              Icons.image_outlined,
              size: 80,
              color: LivestColors.primaryNormal,
            ),
          ),
        ),
      ),
    );
  }

  // ── Image Thumbnails ────────────────────────────────────────────────────────

  Widget _buildImageThumbnails() {
    if (p.imageGallery.length <= 1) return const SizedBox.shrink();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        spacing: 8,
        children: List.generate(p.imageGallery.length, (index) {
          final isActive = _selectedImageIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedImageIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive
                      ? LivestColors.primaryNormal
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  p.imageGallery[index],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: LivestColors.primaryNormal.withOpacity(0.1),
                    child: Icon(
                      Icons.image_outlined,
                      color: LivestColors.primaryNormal,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Product Info Card ───────────────────────────────────────────────────────

  Widget _buildProductInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          // Name + stock
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: p.stock > 0
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  p.stock > 0 ? 'Stok: ${p.stock}' : 'Habis',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: p.stock > 0
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 6,
            children: [
              Text(
                p.price,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: LivestColors.primaryNormal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  p.unit,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),

          // Stats row
          Row(
            spacing: 16,
            children: [
              _StatChip(
                icon: Icons.star_rounded,
                iconColor: Colors.amber,
                label: '${p.rating} (${p.reviewCount} ulasan)',
              ),
              _StatChip(
                icon: Icons.shopping_bag_outlined,
                iconColor: LivestColors.primaryNormal,
                label: '${p.soldCount} terjual',
              ),
            ],
          ),

          // Labels
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: p.labels.map((label) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: LivestColors.primaryNormal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: LivestColors.primaryNormal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Spec Card ───────────────────────────────────────────────────────────────

  Widget _buildSpecCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          const Text(
            'Spesifikasi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _SpecTile(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Berat',
                  value: p.weight,
                ),
              ),
              Expanded(
                child: _SpecTile(
                  icon: Icons.cake_outlined,
                  label: 'Umur',
                  value: p.age,
                ),
              ),
              Expanded(
                child: _SpecTile(
                  icon: Icons.pets_outlined,
                  label: 'Ras',
                  value: p.breed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Seller Card ─────────────────────────────────────────────────────────────

  Widget _buildSellerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: LivestColors.primaryNormal.withOpacity(0.15),
            backgroundImage: AssetImage(p.sellerAvatar),
            onBackgroundImageError: (_, __) {},
            child: Icon(
              Icons.person_rounded,
              color: LivestColors.primaryNormal,
              size: 24,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    Text(
                      p.sellerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (p.sellerVerified)
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: LivestColors.primaryNormal,
                      ),
                  ],
                ),
                Row(
                  spacing: 4,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Colors.grey.shade400,
                    ),
                    Text(
                      p.sellerLocation,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // TODO: navigate to seller profile
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: LivestColors.primaryNormal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: Text(
              'Toko',
              style: TextStyle(
                color: LivestColors.primaryNormal,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Description Card ────────────────────────────────────────────────────────

  Widget _buildDescriptionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const Text(
            'Deskripsi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          Text(
            p.description,
            maxLines: _descriptionExpanded ? null : 3,
            overflow: _descriptionExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
          GestureDetector(
            onTap: () =>
                setState(() => _descriptionExpanded = !_descriptionExpanded),
            child: Text(
              _descriptionExpanded ? 'Sembunyikan' : 'Selengkapnya',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: LivestColors.primaryNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ──────────────────────────────────────────────────────────────

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        spacing: 12,
        children: [
          // Quantity selector
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _QtyButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _QtyButton(
                  icon: Icons.add_rounded,
                  onTap: () {
                    if (_quantity < p.stock) setState(() => _quantity++);
                  },
                ),
              ],
            ),
          ),

          // Chat button
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(color: LivestColors.primaryNormal),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: open chat with seller
              },
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: LivestColors.primaryNormal,
                size: 20,
              ),
            ),
          ),

          // Buy button
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: p.stock > 0
                    ? () {
                        // TODO: handle buy now
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LivestColors.primaryNormal,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Beli Sekarang',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Icon(icon, size: 14, color: iconColor),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _SpecTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: LivestColors.primaryNormal.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: LivestColors.primaryNormal),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, size: 18, color: LivestColors.primaryNormal),
      ),
    );
  }
}
