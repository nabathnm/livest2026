import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/auth_header.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/core/utils/widgets/divider_with_text.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _hasMinLength = false;
  bool _hasNumber = false;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _password.addListener(_validatePasswordRules);
  }

  void _validatePasswordRules() {
    final value = _password.text;
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasNumber = RegExp(r'\d').hasMatch(value);
      _formError = null;
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _handleRegister(AuthProvider authProvider) async {
    FocusScope.of(context).unfocus();
    setState(() => _formError = null);

    if (_email.text.isEmpty || _password.text.isEmpty || _confirmPassword.text.isEmpty) {
      setState(() => _formError = "Lengkapi semua data!");
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_password.text != _confirmPassword.text) {
      setState(() => _formError = "Konfirmasi password tidak sesuai!");
      return;
    }

    final result = await authProvider.signUpWithEmail(
      _email.text.trim(),
      _password.text.trim(),
    );
    final success = result[0];
    final requiresOtp = result[1];

    if (success && mounted) {
      if (requiresOtp) {
        Navigator.pushReplacementNamed(
          context,
          RouteGenerator.otpVerification,
          arguments: _email.text.trim(),
        );
      } else {
        Navigator.pushReplacementNamed(context, RouteGenerator.rolePage);
      }
    }
  }

  Future<void> _handleGoogleSignUp(AuthProvider authProvider) async {
    final success = await authProvider.signUpWithGoogle();
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, RouteGenerator.rolePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.errorMessage!),
                backgroundColor: const Color(0xFFE53935),
              ),
            );
            authProvider.clearError();
          });
        }

        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          body: Column(
            children: [
              AuthHeader(
                subtitle: "Daftar untuk mengakses Livest",
                activeTab: 1,
                onTabChanged: (tab) {
                  if (tab == 0) {
                    Navigator.pushReplacementNamed(context, RouteGenerator.login);
                  }
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(LivestSizes.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: "Email",
                          hintText: "Masukkan email",
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Email tidak boleh kosong";
                            if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) return "Email tidak valid!";
                            return null;
                          },
                        ),
                        const SizedBox(height: LivestSizes.spaceBtwInputFields),
                        CustomTextField(
                          label: "Password",
                          hintText: "Masukkan password",
                          controller: _password,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Password tidak boleh kosong";
                            if (value.length < 8) return "Minimal 8 karakter";
                            return null;
                          },
                        ),
                        const SizedBox(height: LivestSizes.spaceBtwInputFields),
                        CustomTextField(
                          label: "Ulangi Password",
                          hintText: "Ulangi Password",
                          controller: _confirmPassword,
                          isPassword: true,
                          validator: (value) {
                            if (value != _password.text) return "Konfirmasi password tidak sesuai!";
                            return null;
                          },
                        ),
                        const SizedBox(height: LivestSizes.lg),
                        if (_password.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: LivestSizes.spaceBtwInputFields),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(LivestSizes.md),
                              decoration: BoxDecoration(
                                color: LivestColors.primaryLight,
                                borderRadius: BorderRadius.circular(LivestSizes.cardRadiusLg),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Password harus memenuhi",
                                    style: LivestTypography.captionSmSemibold.copyWith(
                                      color: LivestColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildValidationRow("Minimal 1 angka", _hasNumber),
                                  const SizedBox(height: 4),
                                  _buildValidationRow("Minimal 8 karakter", _hasMinLength),
                                ],
                              ),
                            ),
                          ),
                        if (_formError != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: LivestSizes.spaceBtwInputFields),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: LivestColors.redLight,
                              borderRadius: BorderRadius.circular(LivestSizes.inputFieldRadius),
                            ),
                            child: Text(
                              _formError!,
                              textAlign: TextAlign.center,
                              style: LivestTypography.buttonSm.copyWith(
                                color: LivestColors.redNormal,
                              ),
                            ),
                          ),
                        CustomButton(
                          text: "Daftar",
                          isLoading: authProvider.isEmailLoading,
                          onPressed: () => _handleRegister(authProvider),
                        ),
                        const SizedBox(height: LivestSizes.lg),
                        const DividerWithText(),
                        const SizedBox(height: LivestSizes.lg),
                        CustomButton(
                          text: "Daftar dengan Google",
                          variant: ButtonVariant.google,
                          imagePath: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                          isLoading: authProvider.isGoogleLoading,
                          onPressed: () => _handleGoogleSignUp(authProvider),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildValidationRow(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: isValid ? LivestColors.greenNormal : LivestColors.redNormal,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: LivestTypography.textSm.copyWith(
            color: isValid ? LivestColors.greenNormal : LivestColors.redNormal,
          ),
        ),
      ],
    );
  }
}

