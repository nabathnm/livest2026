import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/core/utils/widgets/custom_text_field_pill.dart';
import 'package:livest/core/utils/widgets/custom_confirmation_dialog.dart';
import 'package:livest/core/utils/widgets/custom_success_dialog.dart';
import 'package:flutter/services.dart';
import 'package:livest/core/utils/formatters/phone_number_formatter.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/auth/widgets/postsignup/location_dropdown.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialFarmName;
  final String initialFarmLocation;
  final String initialDescription;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialFarmName,
    required this.initialFarmLocation,
    required this.initialDescription,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _farmNameController;
  late TextEditingController _descController;
  String _farmLocation = '';

  static const List<String> _provinces = [
    'Jawa Timur',
    'Jawa Barat',
    'Jawa Tengah',
    'Banten',
    'DKI Jakarta',
    'Bali',
    'Sumatera Utara',
    'Sumatera Barat',
    'Kalimantan Timur',
    'Sulawesi Selatan',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _farmNameController = TextEditingController(text: widget.initialFarmName);
    _descController = TextEditingController(text: widget.initialDescription == '-' ? '' : widget.initialDescription);
    _farmLocation = widget.initialFarmLocation == '-' ? _provinces.first : widget.initialFarmLocation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _farmNameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final ext = pickedFile.path.split('.').last;
      
      if (!mounted) return;
      final provider = context.read<ProfileProvider>();
      
      final success = await provider.uploadProfilePicture(bytes, ext);
      if (success) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Foto Profil berhasil diperbarui")),
           );
        }
      } else {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(provider.errorMessage ?? "Gagal mengupload foto")),
           );
        }
      }
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Tampilkan Confirmation Dialog sebelum menyimpan
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: true, // User bisa tap di luar untuk batal
      builder: (BuildContext ctx) {
        return const CustomConfirmationDialog(
          title: "Yakin ingin menyimpan\nperubahan?",
          subtitle: "Perubahan dapat diubah kembali.",
        );
      },
    );

    if (confirm != true) return;

    if (!context.mounted) return;
    final provider = context.read<ProfileProvider>();
    final success = await provider.updateProfile(
      name: _nameController.text,
      email: _emailController.text, 
      phoneNumber: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
      farmName: _farmNameController.text,
      farmLocation: _farmLocation,
      description: _descController.text,
    );

    if (!mounted) return;

    if (success) {
      // Tampilkan Success Dialog
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return CustomSuccessDialog(
            title: "Perubahan berhasil!",
            onDismiss: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
          );
        },
      );
    } else {
      if (provider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: const Color(0xFFE53935),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ProfileProvider>().isLoading;

    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: AppBar(
        backgroundColor: LivestColors.baseWhite,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F4F0),
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black87),
              ),
            ),
          ),
        ),
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        titleSpacing: 16,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Consumer<ProfileProvider>(
                  builder: (context, provider, child) {
                    final avatarUrl = provider.avatarUrl;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFFE0E0E0),
                          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                          child: avatarUrl == null ? const Icon(Icons.person, size: 60, color: Colors.grey) : null,
                        ),
                        if (provider.isLoading)
                          const Positioned(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _pickImage,
                  child: const Text(
                    "Edit Foto Profil",
                    style: TextStyle(
                      color: LivestColors.primaryNormal,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: LivestColors.primaryNormal,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextFieldPill(
                  label: "Username",
                  controller: _nameController,
                  validator: (value) => value == null || value.trim().isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                const SizedBox(height: 16),
                CustomTextFieldPill(
                  label: "Deskripsi",
                  controller: _descController,
                  validator: (value) => value == null || value.trim().isEmpty ? "Deskripsi tidak boleh kosong" : null,
                ),
                const SizedBox(height: 16),
                CustomTextFieldPill(
                  label: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Email tidak boleh kosong";
                    if (!value.contains("@")) return "Format email tidak valid";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFieldPill(
                  label: "Nomor Telepon",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneNumberFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return "Nomor telepon tidak boleh kosong";
                    if (!RegExp(r'^(08|\+62)\d{7,12}$').hasMatch(value.replaceAll(RegExp(r'\D'), ''))) {
                      return 'Nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFieldPill(
                  label: "Nama Peternakan",
                  controller: _farmNameController,
                  validator: (value) => value == null || value.trim().isEmpty ? "Nama Peternakan tidak boleh kosong" : null,
                ),
                const SizedBox(height: 16),
                LocationDropdown(
                  value: _provinces.contains(_farmLocation) ? _farmLocation : null,
                  items: _provinces,
                  onChanged: (v) => setState(() => _farmLocation = v ?? ''),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LivestColors.primaryNormal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Simpan", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
