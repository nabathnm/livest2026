import 'package:flutter/material.dart';
import 'package:livest/core/utils/widgets/auth_header.dart';
import 'package:livest/core/utils/widgets/password_requirements.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _hasMinLength = false;
  bool _hasNumber = false;

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: LivestColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: LivestSizes.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: LivestSizes.lg),

                    // Header
                    const AuthHeader(
                      title: "Ubah Password",
                      subtitle: "Buat password baru untuk akun Anda",
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: LivestSizes.spaceBtwSections),

                    // Password Baru
                    CustomTextField(
                      label: "Password Baru",
                      hintText: "Masukkan password baru",
                      controller: _newPassword,
                      isPassword: true,
                      onChanged: (val) {
                        setState(() {
                          _hasMinLength = val.length >= 8;
                          _hasNumber = val.contains(RegExp(r'[0-9]'));
                        });
                      },
                      validator: (v) => (!_hasMinLength || !_hasNumber)
                          ? "Password tidak memenuhi syarat"
                          : null,
                    ),
                    const SizedBox(height: LivestSizes.spaceBtwInputFields),

                    // Konfirmasi
                    CustomTextField(
                      label: "Konfirmasi Password",
                      hintText: "Ulangi password baru",
                      controller: _confirmPassword,
                      isPassword: true,
                      validator: (v) => (v != _newPassword.text)
                          ? "Password tidak cocok"
                          : null,
                    ),
                    const SizedBox(height: LivestSizes.md),

                    // Requirements
                    PasswordRequirements(
                      hasMinLength: _hasMinLength,
                      hasNumber: _hasNumber,
                    ),
                    const SizedBox(height: LivestSizes.lg),

                    // Button
                    CustomButton(
                      text: "Ubah Password",
                      isLoading: auth.isLoading,
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        final ok = await auth.updatePassword(
                          _newPassword.text.trim(),
                        );
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password berhasil diubah!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        } else if (context.mounted &&
                            auth.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(auth.errorMessage!),
                              backgroundColor: const Color(0xFFE53935),
                            ),
                          );
                          auth.clearError();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
