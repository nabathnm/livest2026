import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field_pill.dart';
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

  String? _errorMessage;

  @override
  void dispose() {
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String val) {
    setState(() {
      _errorMessage = null;
      _hasMinLength = val.length >= 8;
      _hasNumber = val.contains(RegExp(r'[0-9]'));
    });
  }

  void _onSubmit(AuthProvider auth) async {
    FocusScope.of(context).unfocus();
    
    if (_newPassword.text.isEmpty || _confirmPassword.text.isEmpty) {
      setState(() => _errorMessage = "Lengkapi semua data!");
      return;
    }
    
    if (_newPassword.text != _confirmPassword.text) {
      setState(() => _errorMessage = "Konfirmasi Password tidak sesuai!");
      return;
    }
    
    if (!_hasMinLength || !_hasNumber) {
      setState(() => _errorMessage = "Password belum memenuhi syarat!");
      return;
    }

    setState(() => _errorMessage = null);

    final ok = await auth.updatePassword(_newPassword.text.trim());
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password berhasil diubah!"),
          backgroundColor: LivestColors.greenNormal,
        ),
      );
      Navigator.pop(context);
    } else if (context.mounted && auth.errorMessage != null) {
      setState(() => _errorMessage = auth.errorMessage);
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(LivestSizes.lg, LivestSizes.lg, LivestSizes.lg, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: LivestColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: LivestColors.textHeading,
                        ),
                      ),
                    ),
                  ),
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(LivestSizes.lg),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            "Ubah Password",
                            textAlign: TextAlign.center,
                            style: LivestTypography.displayMd.copyWith(
                              color: LivestColors.textHeading,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Masukkan password baru kamu.",
                            textAlign: TextAlign.center,
                            style: LivestTypography.bodySm.copyWith(
                              color: LivestColors.textSecondary,
                            ),
                          ),
                          
                          const SizedBox(height: 48),
                          Text(
                            "Password Baru",
                            style: LivestTypography.bodySmMedium.copyWith(
                              color: LivestColors.textHeading,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFieldPill(
                            label: "",
                            hintText: "Masukkan password baru",
                            controller: _newPassword,
                            isPassword: true,
                            hasError: _errorMessage != null,
                            onChanged: _onPasswordChanged,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Ulangi Password Baru",
                            style: LivestTypography.bodySmMedium.copyWith(
                              color: LivestColors.textHeading,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFieldPill(
                            label: "",
                            hintText: "Ketik ulang password baru",
                            controller: _confirmPassword,
                            isPassword: true,
                            hasError: _errorMessage != null,
                            onChanged: (_) {
                              if (_errorMessage != null) {
                                setState(() => _errorMessage = null);
                              }
                            },
                          ),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: LivestColors.redLight,
                                borderRadius: BorderRadius.circular(LivestSizes.inputFieldRadius),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _errorMessage!,
                                style: LivestTypography.buttonSm.copyWith(
                                  color: LivestColors.redNormal,
                                ),
                              ),
                            ),
                          ],

                        ],
                      ),
                    ),
                  ),
                ),

                // Konfirmasi Button
                Padding(
                  padding: const EdgeInsets.all(LivestSizes.lg),
                  child: CustomButton(
                    text: "Konfirmasi",
                    isLoading: auth.isLoading,
                    onPressed: () => _onSubmit(auth),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
