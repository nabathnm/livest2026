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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
              // ── Brown Header + Tabs ──
              SafeArea(
                bottom: false,
                child: AuthHeader(
                  subtitle: "Masuk dengan akun Livest.",
                  activeTab: 0,
                  onTabChanged: (tab) {
                    if (tab == 1) {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteGenerator.register,
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
                          hintText: "Masukkan email kamu",
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: LivestSizes.spaceBtwInputFields),

                        // Password
                        CustomTextField(
                          label: "Password",
                          hintText: "Masukkan password kamu",
                          controller: _password,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password tidak boleh kosong";
                            }
                            return null;
                          },
                        ),

                        // Lupa Password
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              RouteGenerator.forgotPassword,
                            ),
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              "Lupa Password?",
                              style: TextStyle(
                                color: LivestColors.primaryNormal,
                                fontSize: LivestSizes.fontSizeSm,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: LivestSizes.sm),

                        // Tombol Masuk
                        CustomButton(
                          text: "Masuk",
                          isLoading: authProvider.isLoading,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (!_formKey.currentState!.validate()) return;
                            authProvider.signInWithEmail(
                              _email.text.trim(),
                              _password.text.trim(),
                            );
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
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            authProvider.signInWithGoogle();
                          },
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
