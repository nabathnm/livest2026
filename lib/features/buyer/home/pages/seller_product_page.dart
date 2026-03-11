// import 'package:flutter/material.dart';
// import 'package:livest/core/utils/constants/livest_colors.dart';
// import 'package:livest/core/utils/constants/livest_typography.dart';
// import 'package:livest/features/buyer/home/pages/detail_product_page.dart';
// import 'package:livest/features/buyer/home/provider/buyer_marketplace_provider.dart';
// import 'package:provider/provider.dart';

// class SellerProfilePage extends StatefulWidget {
//   final String? sellerId;
//   final String sellerName;

//   const SellerProfilePage({super.key, this.sellerId, required this.sellerName});

//   @override
//   State<SellerProfilePage> createState() => _SellerProfilePageState();
// }

// class _SellerProfilePageState extends State<SellerProfilePage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       context.read<BuyerMarketplaceProvider>().getProductsBySeller(
//         widget.sellerId,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: LivestColors.baseWhite,
//       appBar: AppBar(
//         backgroundColor: LivestColors.baseWhite,
//         elevation: 0,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.black,
//             size: 20,
//           ),
//         ),
//         title: Text('Profile Penjual', style: LivestTypography.bodyLgBold),
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Seller Header ──
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 36,
//                     backgroundColor: LivestColors.baseBackground,
//                     child: const Icon(
//                       Icons.person,
//                       size: 36,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.sellerName,
//                         style: LivestTypography.bodyLgBold,
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.location_on_rounded,
//                             size: 14,
//                             color: Color(0xFF4CAF50),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             'Jawa Timur',
//                             style: LivestTypography.bodySm.copyWith(
//                               color: const Color(0xFF4CAF50),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 20),
//               const Divider(color: Color(0xFFF0EDE8)),
//               const SizedBox(height: 16),

//               // ── Description ──
//               Text('Deskripsi', style: LivestTypography.bodyLgBold),
//               const SizedBox(height: 8),
//               Text(
//                 '${widget.sellerName} adalah sebuah peternakan skala kecil yang berlokasi di Jawa Timur, Indonesia.',
//                 style: LivestTypography.bodyMd.copyWith(
//                   color: LivestColors.textSecondary,
//                   height: 1.5,
//                 ),
//               ),

//               const SizedBox(height: 20),
//               const Divider(color: Color(0xFFF0EDE8)),
//               const SizedBox(height: 16),

//               // ── Products ──
//               Text('Ternak yang dijual', style: LivestTypography.bodyLgBold),
//               const SizedBox(height: 16),

//               Consumer<BuyerMarketplaceProvider>(
//                 builder: (context, provider, _) {
//                   if (provider.isLoadingSellerProducts) {
//                     return const Center(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 32),
//                         child: CircularProgressIndicator(
//                           color: LivestColors.primaryNormal,
//                         ),
//                       ),
//                     );
//                   }

//                   final sellerProducts = provider.sellerProducts;

//                   if (sellerProducts.isEmpty) {
//                     return Center(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 32),
//                         child: Text(
//                           'Belum ada produk',
//                           style: LivestTypography.bodyMd.copyWith(
//                             color: LivestColors.textSecondary,
//                           ),
//                         ),
//                       ),
//                     );
//                   }

//                   return ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: sellerProducts.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 16),
//                     itemBuilder: (context, index) {
//                       final product = sellerProducts[index];
//                       return _SellerProductCard(product: product);
//                     },
//                   );
//                 },
//               ),

//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SellerProductCard extends StatelessWidget {
//   final dynamic product;

//   const _SellerProductCard({required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => DetailProductPage(product: product),
//           ),
//         );
//       },
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Image ──
//             SizedBox(
//               width: double.infinity,
//               height: 180,
//               child: product.imageUrl != null
//                   ? Image.network(
//                       product.imageUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         color: LivestColors.baseBackground,
//                         child: const Icon(
//                           Icons.image_not_supported,
//                           size: 40,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     )
//                   : Container(
//                       color: LivestColors.baseBackground,
//                       child: const Icon(
//                         Icons.image_not_supported,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                     ),
//             ),

//             // ── Badges & Info ──
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(color: Color(0xFFF8F5F0)),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Badges
//                   Row(
//                     children: [
//                       _Badge(
//                         label: 'Terverifikasi',
//                         color: const Color(0xFF4CAF50),
//                         icon: Icons.verified_rounded,
//                       ),
//                       const SizedBox(width: 8),
//                       _Badge(
//                         label: 'Jawa Timur',
//                         color: const Color(0xFF4CAF50),
//                         icon: Icons.location_on_rounded,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(product.name ?? '-', style: LivestTypography.bodyMdBold),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.description ?? '-',
//                     style: LivestTypography.bodySm.copyWith(
//                       color: LivestColors.textSecondary,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Badge extends StatelessWidget {
//   final String label;
//   final Color color;
//   final IconData icon;

//   const _Badge({required this.label, required this.color, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: color),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: color,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
