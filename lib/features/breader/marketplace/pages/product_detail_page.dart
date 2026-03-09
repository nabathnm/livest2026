import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/core/utils/widgets/livest_button.dart';
import 'package:livest/core/utils/widgets/livest_confirm_dialog.dart';
import 'package:livest/core/utils/widgets/livest_network_image.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/pages/product_form_page.dart';
import 'package:livest/features/breader/marketplace/providers/marketplace_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final String userId;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.userId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductModel _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  // ── Actions ────────────────────────────────────────────────────────────

  void _goToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormPage(
          mode: ProductFormMode.edit,
          userId: widget.userId,
          existingProduct: _product,
        ),
      ),
    ).then((_) {
      // Refresh data after edit
      final provider = context.read<MarketplaceProvider>();
      final updated = provider.products.firstWhere(
        (p) => p.id == _product.id,
        orElse: () => _product,
      );
      setState(() => _product = updated);
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => LivestConfirmDialog(
        title: "Yakin ingin menghapus penjualan?",
        subtitle: "Tindakan ini tidak dapat dikembalikan!",
        confirmText: "Hapus!",
        variant: LivestDialogVariant.delete,
        onConfirm: () async {
          Navigator.pop(context);
          await context.read<MarketplaceProvider>().deleteProduct(_product.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmMarkAsSold() {
    if (_product.isSold == true) return;

    showDialog(
      context: context,
      builder: (_) => LivestConfirmDialog(
        title: "Yakin ingin menandai penjualan selesai?",
        subtitle: "Tindakan ini tidak dapat dikembalikan seperti semula",
        confirmText: "Tandai",
        variant: LivestDialogVariant.primary,
        onConfirm: () async {
          Navigator.pop(context);
          await context.read<MarketplaceProvider>().markAsSold(_product.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final phone = _product.phone?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
    if (phone.isEmpty) return;
    final normalized = phone.startsWith('0')
        ? '62${phone.substring(1)}'
        : phone;
    final uri = Uri.parse('https://wa.me/$normalized');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final price = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(_product.price ?? 0);

    final date = _product.createdAt != null
        ? DateFormat('dd/MM/yyyy').format(_product.createdAt!)
        : '-';

    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      appBar: LivestAppbar(
        name: "Detail Penjualan",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _confirmDelete,
              child: Image.asset('assets/images/icon/trash.png'),
            ),
          ),
        ],
      ),
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
                  LivestNetworkImage(imageUrl: _product.imageUrl),
                  SizedBox(height: 16),
                  Text(_product.name ?? 'Product', style: LivestTypography.h3),
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
                  if (_product.type != null)
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
                        _product.type!,
                        style: LivestTypography.bodySm.copyWith(
                          color: LivestColors.primaryNormal,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  const Text('Deskripsi', style: LivestTypography.bodyLg),
                  const SizedBox(height: 4),
                  Text(
                    _product.description ?? 'Tidak ada deskripsi.',
                    style: LivestTypography.bodyMd.copyWith(
                      color: LivestColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Nomor kontak
                  const Text(
                    'Nomor yang dapat dihubungi',
                    style: LivestTypography.bodyLg,
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
                    onTap: _openWhatsApp,
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
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      color: LivestColors.baseWhite,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: _product.isSold == true
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: LivestColors.greenLight,
              ),
              child: Text(
                textAlign: TextAlign.center,
                "Sudah ditandai terjual.",
                style: LivestTypography.bodyMdBold.copyWith(
                  color: LivestColors.greenNormal,
                ),
              ),
            )
          : Row(
              children: [
                // Tombol Ubah
                Expanded(
                  child: LivestButton(
                    variant: LivestButtonVariant.outline,
                    text: "Ubah",
                    onPressed: _goToEdit,
                  ),
                ),
                const SizedBox(width: 12),
                // Tombol Tandai Terjual
                Expanded(
                  flex: 2,
                  child: LivestButton(
                    text: "Tandai Terjual",
                    onPressed: _confirmMarkAsSold,
                  ),
                ),
              ],
            ),
    );
  }
}
