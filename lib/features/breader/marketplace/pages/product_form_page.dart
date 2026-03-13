import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/livest_appbar.dart';
import 'package:livest/core/utils/widgets/livest_button.dart';
import 'package:livest/core/utils/widgets/livest_confirm_dialog.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:livest/features/breader/marketplace/providers/marketplace_provider.dart';
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
  String get _location => context.read<ProfileProvider>().farmLocation ?? '';
  String get _farmName => context.read<ProfileProvider>().farmName ?? '';
  String get _breaderName => context.read<ProfileProvider>().fullName ?? '';
  // String get _userId => context.read<ProfileProvider>().id ?? '';

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();

  String? _selectedType;
  static const List<String> _livestockTypes = [
    'Ayam',
    'Bebek',
    'Sapi',
    'Kambing',
  ];

  File? _imageFile;
  bool _isSubmitting = false;
  bool _hasTriedSubmit = false;
  final ImagePicker _picker = ImagePicker();

  bool get isEdit => widget.mode == ProductFormMode.edit;

  // ─── Validation ───────────────────────────────────────────────────────────

  bool get _nameValid => nameController.text.trim().isNotEmpty;
  bool get _typeValid => _selectedType != null && _selectedType!.isNotEmpty;
  bool get _priceValid {
    final val = int.tryParse(priceController.text.trim());
    return val != null && val > 0;
  }

  // FIX: was incorrectly using priceController instead of phoneController
  bool get _phoneValid => phoneController.text.trim().isNotEmpty;

  bool get _descriptionValid => descriptionController.text.trim().isNotEmpty;
  bool get _imageValid {
    final hasNew = _imageFile != null;
    final hasOld = (widget.existingProduct?.imageUrl ?? '').isNotEmpty;
    return hasNew || hasOld;
  }

  bool get _formValid =>
      _nameValid &&
      _typeValid &&
      _priceValid &&
      _phoneValid &&
      _descriptionValid &&
      _imageValid;

  // ─── Init & Dispose ───────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // FIX: fill controllers when in edit mode
    if (isEdit && widget.existingProduct != null) {
      _fillControllers(widget.existingProduct!);
    }
    // listen to controllers so validation updates reactively
    nameController.addListener(_rebuild);
    priceController.addListener(_rebuild);
    phoneController.addListener(_rebuild);
    descriptionController.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _fillControllers(ProductModel product) {
    nameController.text = product.name ?? '';
    descriptionController.text = product.description ?? '';
    priceController.text = product.price?.toString() ?? '';
    phoneController.text = product.phone ?? '';

    final existingType = product.type ?? '';
    _selectedType = _livestockTypes.firstWhere(
      (t) => t.toLowerCase() == existingType.toLowerCase(),
      orElse: () => '',
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
      type: _selectedType ?? '',
      // FIX: prefer newly uploaded imageUrl, fallback to existing
      imageUrl: imageUrl ?? old?.imageUrl ?? '',
      phone: phoneController.text.trim(),
      location: _location,
      farmName: _farmName,
      breaderName: _breaderName,
    );
  }

  void _onSubmit() {
    setState(() => _hasTriedSubmit = true);
    if (!_formValid) return;

    if (isEdit) {
      _confirmUpdate();
    } else {
      _confirmAdd();
    }
  }

  void _confirmAdd() {
    showDialog(
      context: context,
      builder: (_) => LivestConfirmDialog(
        title: "Yakin ingin menambah penjualan?",
        subtitle: "Penjualan dapat diubah kembali setelah ditambah.",
        confirmText: "Tambah",
        variant: LivestDialogVariant.primary,
        onConfirm: () async {
          Navigator.pop(context);
          await _submitAdd();
        },
      ),
    );
  }

  Future<void> _submitAdd() async {
    setState(() => _isSubmitting = true);
    try {
      final imageUrl = _imageFile != null
          ? await _uploadImage(_imageFile!)
          : null;
      final product = _buildProduct(imageUrl: imageUrl);
      await context.read<MarketplaceProvider>().createProduct(product);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _confirmUpdate() {
    showDialog(
      context: context,
      builder: (_) => LivestConfirmDialog(
        title: "Yakin ingin menyimpan perubahan?",
        subtitle: "Segala perubahan akan disimpan.",
        confirmText: "Simpan",
        variant: LivestDialogVariant.primary,
        onConfirm: () async {
          Navigator.pop(context);
          await _submitUpdate();
        },
      ),
    );
  }

  Future<void> _submitUpdate() async {
    setState(() => _isSubmitting = true);
    try {
      final imageUrl = _imageFile != null
          ? await _uploadImage(_imageFile!)
          : null;
      final updated = _buildProduct(imageUrl: imageUrl);
      await context.read<MarketplaceProvider>().updateProduct(updated);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: isEdit
          ? LivestAppbar(name: 'Edit Penjualan')
          : LivestAppbar(name: 'Tambah Penjualan'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(
                  label: 'Judul',
                  isValid: _nameValid,
                  child: _buildTextField(nameController, 'Masukkan judul'),
                ),
                const SizedBox(height: 24),
                _buildField(
                  label: 'Jenis Ternak',
                  isValid: _typeValid,
                  child: _buildTypeSelector(),
                ),
                const SizedBox(height: 24),
                _buildField(
                  label: 'Harga',
                  isValid: _priceValid,
                  child: _buildTextField(
                    priceController,
                    'Masukkan harga',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(
                  label: 'Nomor yang dapat dihubungi',
                  isValid: _phoneValid,
                  child: _buildTextField(
                    phoneController,
                    'Masukkan kontak',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(
                  label: 'Deskripsi',
                  isValid: _descriptionValid,
                  child: _buildTextField(
                    descriptionController,
                    'Jelaskan ternakmu (usia, berat, jenis kelamin, dan lainnya)',
                    maxLines: 4,
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(
                  label: 'Tambah Foto',
                  isValid: _imageValid,
                  child: _buildImagePicker(),
                ),
                const SizedBox(height: 24),
                if (_hasTriedSubmit && !_formValid) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Silahkan lengkapi semua data!',
                      style: LivestTypography.bodyMd.copyWith(
                        color: LivestColors.redNormalHover,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 64),
                LivestButton(
                  text: isEdit ? 'Simpan Perubahan' : 'Tambah Penjualan',
                  onPressed: _isSubmitting ? null : _onSubmit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: LivestColors.primaryNormal,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Menyimpan produk...',
                      style: const TextStyle(color: LivestColors.primaryNormal),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Field wrapper ────────────────────────────────────────────────────────

  Widget _buildField({
    required String label,
    required bool isValid,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LivestTypography.bodyMd),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _buildImagePicker() {
    final existingUrl = widget.existingProduct?.imageUrl;
    final hasNewImage = _imageFile != null;
    final hasOldImage = existingUrl != null && existingUrl.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasNewImage)
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(
              _imageFile!,
              height: 100,
              width: 172,
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
        if (hasNewImage || hasOldImage) const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: LivestColors.primaryLightHover,
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/icon/add.png'),
                const SizedBox(width: 6),
                Text(
                  hasNewImage || hasOldImage ? 'Ganti Foto' : 'Tambah Foto',
                  style: LivestTypography.bodySm.copyWith(
                    color: LivestColors.primaryNormal,
                  ),
                ),
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
            'Gagal memuat gambar',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    final showError = _hasTriedSubmit && !_typeValid;
    return DropdownButtonFormField<String>(
      value: _selectedType,
      icon: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Image.asset('assets/images/icon/dropdown.png'),
      ),
      dropdownColor: LivestColors.baseWhite,
      style: const TextStyle(color: LivestColors.textPrimary, fontSize: 16),
      hint: Text(
        'Pilih jenis ternak yang ingin dijual',
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
        border: _dropdownBorder(showError: showError, focused: false),
        enabledBorder: _dropdownBorder(showError: showError, focused: false),
        focusedBorder: _dropdownBorder(showError: showError, focused: true),
      ),
    );
  }

  OutlineInputBorder _dropdownBorder({
    required bool showError,
    required bool focused,
  }) {
    final color = showError
        ? Colors.red
        : focused
        ? LivestColors.primaryNormal
        : LivestColors.primaryLightActive;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(32),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    bool isFieldValid() {
      if (controller == nameController) return _nameValid;
      if (controller == priceController) return _priceValid;
      if (controller == phoneController) return _phoneValid;
      if (controller == descriptionController) return _descriptionValid;
      return true;
    }

    final showError = _hasTriedSubmit && !isFieldValid();
    final radius = BorderRadius.circular(maxLines == 1 ? 32 : 24);

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        hintStyle: TextStyle(
          color: LivestColors.baseBlack.withOpacity(0.4),
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: showError ? Colors.red : LivestColors.primaryLightActive,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: showError ? Colors.red : LivestColors.primaryLightActive,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(
            color: showError ? Colors.red : LivestColors.primaryNormal,
            width: 2,
          ),
        ),
      ),
    );
  }
}
