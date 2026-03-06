import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/providers/test_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ProductFormMode { add, edit }

class ProductFormPage extends StatefulWidget {
  final ProductFormMode mode;
  final ProductModel? existingProduct;
  final String userId;

  const ProductFormPage({
    super.key,
    required this.mode,
    required this.userId,
    this.existingProduct,
  }) : assert(
         mode == ProductFormMode.add || existingProduct != null,
         'existingProduct wajib diisi saat mode edit',
       );

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();

  String? _selectedType;
  static const List<String> _livestockTypes = [
    'Ayam',
    'Bebek',
    'Sapi',
    'Kambing',
  ];

  File? _imageFile;
  bool _isSubmitting = false;
  final ImagePicker _picker = ImagePicker();

  bool get isEdit => widget.mode == ProductFormMode.edit;

  // ─── Init & Dispose ───────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    if (isEdit) _fillControllers(widget.existingProduct!);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _fillControllers(ProductModel product) {
    nameController.text = product.name ?? "";
    descriptionController.text = product.description ?? "";
    priceController.text = product.price?.toString() ?? "";
    locationController.text = product.location ?? "";

    // Cocokkan nilai type dari produk ke pilihan yang tersedia (case-insensitive)
    final existingType = product.type ?? "";
    _selectedType = _livestockTypes.firstWhere(
      (t) => t.toLowerCase() == existingType.toLowerCase(),
      orElse: () => "",
    );
    if (_selectedType!.isEmpty) _selectedType = null;
  }

  // ─── Image Picker ─────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  /// Upload gambar ke Supabase Storage, kembalikan public URL.
  /// Lempar exception jika gagal agar bisa di-catch oleh caller.
  Future<String> _uploadImage(File imageFile) async {
    final supabase = Supabase.instance.client;
    final fileName =
        '${widget.userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storagePath = 'products/$fileName';

    await supabase.storage.from('productImages').upload(storagePath, imageFile);

    return supabase.storage.from('productImages').getPublicUrl(storagePath);
  }

  // ─── Build Product ────────────────────────────────────────────────────────

  ProductModel _buildProduct({required String? imageUrl}) {
    final old = widget.existingProduct;
    return ProductModel(
      id: old?.id ?? 0,
      userId: old?.userId ?? widget.userId,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      price: int.tryParse(priceController.text) ?? 0,
      isSold: old?.isSold ?? false,
      type: _selectedType ?? "",
      // Prioritas: gambar baru → gambar lama → null
      imageUrl: imageUrl ?? old?.imageUrl,
      location: locationController.text.trim(),
    );
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  void _onSubmit() {
    if (isEdit) {
      _confirmUpdate();
    } else {
      _submitAdd();
    }
  }

  Future<void> _submitAdd() async {
    setState(() => _isSubmitting = true);
    try {
      // Upload gambar dulu jika ada, lalu sisipkan URL ke produk
      final imageUrl = _imageFile != null
          ? await _uploadImage(_imageFile!)
          : null;
      final product = _buildProduct(imageUrl: imageUrl);
      await context.read<TestProvider>().createProduct(product);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) _showErrorSnackbar('Gagal menyimpan produk: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _confirmUpdate() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi Update"),
        content: const Text("Apakah kamu yakin ingin menyimpan perubahan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // tutup dialog dulu
              await _submitUpdate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Ya, Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _submitUpdate() async {
    setState(() => _isSubmitting = true);
    try {
      // Jika user memilih gambar baru → upload; jika tidak → pakai URL lama
      final imageUrl = _imageFile != null
          ? await _uploadImage(_imageFile!)
          : null;
      final updated = _buildProduct(imageUrl: imageUrl);
      await context.read<TestProvider>().updateProduct(updated);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) _showErrorSnackbar('Gagal memperbarui produk: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: LivestColors.baseWhite,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        titleSpacing: 16,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LivestColors.primaryLight,
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/images/icon/back.png', width: 24),
            ),
          ),
        ),
        title: Text(
          isEdit ? "Edit Produk" : "Tambah Penjualan",
          style: const TextStyle(
            color: LivestColors.baseBlack,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                _buildSectionLabel("Judul"),
                _buildTextField(nameController, "Masukkan judul"),
                _buildSectionLabel("Jenis Ternak"),
                _buildTypeSelector(),
                _buildSectionLabel("Harga"),
                _buildTextField(
                  priceController,
                  "Harga (Rp)",
                  keyboardType: TextInputType.number,
                ),
                _buildSectionLabel("Nomor yang dapat dihubungi"),
                _buildTextField(locationController, "Masukkan kontak"),
                _buildSectionLabel("Deskripsi"),
                _buildTextField(
                  descriptionController,
                  "Deskripsi",
                  maxLines: 4,
                ),
                _buildSectionLabel("Tambah Foto"),
                _buildImagePicker(),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: CustomButton(
                    text: isEdit ? "Simpan Perubahan" : "Tambah Penjualan",
                    onPressed: _isSubmitting ? null : _onSubmit,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Overlay loading saat upload + submit berlangsung
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 14,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    Text(
                      "Menyimpan produk...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    // Tentukan gambar yang ditampilkan sebagai preview:
    // gambar baru (File) → gambar lama dari URL → kosong
    final existingUrl = widget.existingProduct?.imageUrl;
    final hasNewImage = _imageFile != null;
    final hasOldImage = existingUrl != null && existingUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        // Preview gambar
        if (hasNewImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _imageFile!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else if (hasOldImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              existingUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imagePlaceholder(),
            ),
          ),

        // Tombol pilih / ganti gambar
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: LivestColors.primaryLightHover,
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 20, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                const Icon(Icons.add_photo_alternate_outlined, size: 20),
                Text(hasNewImage || hasOldImage ? "Ganti Foto" : "Tambah Foto"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 36, color: Colors.grey[400]),
          const SizedBox(height: 4),
          Text(
            "Gagal memuat gambar",
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: LivestColors.primaryNormal,
      ),
      dropdownColor: LivestColors.baseWhite,
      style: const TextStyle(color: LivestColors.textPrimary, fontSize: 16),
      hint: Text(
        "Pilih jenis ternak",
        style: TextStyle(
          color: LivestColors.baseBlack.withOpacity(0.4),
          fontSize: 16,
        ),
      ),
      items: _livestockTypes.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => _selectedType = value),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        filled: true,
        fillColor: LivestColors.baseWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: LivestColors.primaryLightActive,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: LivestColors.primaryLightActive,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
            color: LivestColors.primaryNormal,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: LivestColors.baseBlack,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        hintStyle: TextStyle(
          color: LivestColors.baseBlack.withOpacity(0.4),
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines == 1 ? 32 : 24),
          borderSide: const BorderSide(
            color: LivestColors.primaryLightActive,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines == 1 ? 32 : 24),
          borderSide: const BorderSide(
            color: LivestColors.primaryLightActive,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines == 1 ? 32 : 24),
          borderSide: const BorderSide(
            color: LivestColors.primaryNormal,
            width: 2,
          ),
        ),
      ),
    );
  }
}
