import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/widgets/custom_confirmation_dialog.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/core/utils/widgets/custom_text_field_pill.dart';
import 'package:flutter/services.dart';
import 'package:livest/core/utils/formatters/phone_number_formatter.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialPreferences;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialPreferences,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _preferencesController;
  
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _preferencesController = TextEditingController(text: widget.initialPreferences);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _confirmSave() {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (ctx) => const CustomConfirmationDialog(
        title: "Yakin ingin menyimpan\\nperubahan?",
        subtitle: "Segala perubahan akan disimpan.",
        confirmText: "Simpan",
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _submit();
      }
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProfileProvider>();
    
    if (_imageFile != null) {
      final bytes = await _imageFile!.readAsBytes();
      final extension = _imageFile!.path.split('.').last;
      await provider.uploadProfilePicture(bytes, extension);
    }
    
    final success = await provider.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
      preferences: _preferencesController.text.isNotEmpty ? _preferencesController.text : null,
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted && provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: const Color(0xFFE53935),
        ),
      );
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
        automaticallyImplyLeading: false,
        titleSpacing: LivestSizes.lg,
        title: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: LivestColors.primaryLightActive,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: LivestColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: LivestSizes.md),
            const Text(
              "Edit Profile",
              style: TextStyle(
                color: LivestColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFE0E0E0),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (context.read<ProfileProvider>().avatarUrl != null
                            ? NetworkImage(context.read<ProfileProvider>().avatarUrl!) as ImageProvider
                            : null),
                    child: _imageFile == null && context.read<ProfileProvider>().avatarUrl == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
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
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextFieldPill(
                  label: "Username",
                  controller: _nameController,
                  validator: (value) => value == null || value.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                const SizedBox(height: 16),
                CustomTextFieldPill(
                  label: "Email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email tidak boleh kosong";
                    if (!value.contains("@")) return "Email tidak valid";
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
                  label: "Preferensi Ternak",
                  controller: _preferencesController,
                  hintText: "Contoh: Sapi, ayam",
                  validator: (value) => value == null || value.isEmpty ? "Preferensi tidak boleh kosong" : null,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _confirmSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LivestColors.primaryNormal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
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
