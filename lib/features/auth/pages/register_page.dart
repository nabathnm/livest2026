import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
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
              SafeArea(
                bottom: false,
                child: AuthHeader(
                  subtitle: "Daftar untuk mengakses Livest",
                  activeTab: 1,
                  onTabChanged: (tab) {
                    if (tab == 0) {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteGenerator.login,
                      );
                    }
                  },
                ),
              ),

              // ── Form Body ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(LivestSizes.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email
                        CustomTextField(
                          label: "Email",
                          hintText: "Masukkan email",
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                              return "Email tidak valid!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: LivestSizes.spaceBtwInputFields),

                        // Password
                        CustomTextField(
                          label: "Password",
                          hintText: "Masukkan password",
                          controller: _password,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            if (value.length < 8) {
                              return "Minimal 8 karakter";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: LivestSizes.spaceBtwInputFields),

                        // Ulangi Password
                        CustomTextField(
                          label: "Ulangi Password",
                          hintText: "Ulangi Password",
                          controller: _confirmPassword,
                          isPassword: true,
                          validator: (value) {
                            if (value != _password.text) {
                              return "Konfirmasi password tidak sesuai!";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: LivestSizes.lg),

                        CustomButton(
                          text: "Masuk",
                          isLoading: authProvider.isLoading,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (!_formKey.currentState!.validate()) return;
                            final success = await authProvider.signUpWithEmail(
                              _email.text.trim(),
                              _password.text.trim(),
                            );
                            if (success && mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteGenerator.rolePage,
                                (route) => false,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: LivestSizes.lg),

                        // Divider
                        const DividerWithText(),
                        const SizedBox(height: LivestSizes.lg),

                        // Google
                        CustomButton(
                          text: "Masuk dengan Google",
                          variant: ButtonVariant.outlined,
                          icon: Icons.g_mobiledata,
                          isLoading: authProvider.isLoading,
                          onPressed: () => authProvider.signInWithGoogle(),
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
}
