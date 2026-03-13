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
import 'package:livest/features/auth/providers/profile_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _formError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    FocusScope.of(context).unfocus();
    setState(() => _formError = null);

    if (_email.text.isEmpty || _password.text.isEmpty) {
      setState(() => _formError = "Lengkapi semua data.");
      return;
    }

    final success = await authProvider.signInWithEmail(
      _email.text.trim(),
      _password.text.trim(),
    );

    if (success && mounted) {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.fetchProfile();
      final role = profileProvider.role;

      if (!mounted) return;

      if (role == null) {
        Navigator.pushReplacementNamed(context, RouteGenerator.rolePage);
      } else if (role == 'peternak') {
        Navigator.pushReplacementNamed(context, RouteGenerator.breaderHome);
      } else if (role == 'pembeli') {
        Navigator.pushReplacementNamed(context, RouteGenerator.buyerHome);
      }
    } else {
      setState(() => _formError = "Email / Password tidak sesuai.");
    }
  }

  Future<void> _handleGoogleLogin(AuthProvider authProvider) async {
    FocusScope.of(context).unfocus();
    final success = await authProvider.signInWithGoogle();

    if (success && mounted) {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.fetchProfile();
      final role = profileProvider.role;

      if (!mounted) return;

      if (role == null) {
        Navigator.pushReplacementNamed(context, RouteGenerator.rolePage);
      } else if (role == 'peternak') {
        Navigator.pushReplacementNamed(context, RouteGenerator.breaderHome);
      } else if (role == 'pembeli') {
        Navigator.pushReplacementNamed(context, RouteGenerator.buyerHome);
      }
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
                subtitle: "Masuk dengan akun Livest.",
                activeTab: 0,
                onTabChanged: (tab) {
                  if (tab == 1) {
                    Navigator.pushReplacementNamed(context, RouteGenerator.register);
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
                          hintText: "Masukkan email kamu",
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: LivestSizes.spaceBtwInputFields),
                        CustomTextField(
                          label: "Password",
                          hintText: "Masukkan password kamu",
                          controller: _password,
                          isPassword: true,
                        ),
                        const SizedBox(height: 8),
                        if (_formError != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(context, RouteGenerator.forgotPassword),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Lupa Password?",
                              style: LivestTypography.buttonSm.copyWith(
                                color: LivestColors.primaryNormal,
                                decoration: TextDecoration.underline,
                                decorationColor: LivestColors.primaryNormal,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: LivestSizes.lg),
                        CustomButton(
                          text: "Masuk",
                          isLoading: authProvider.isLoading,
                          onPressed: () => _handleLogin(authProvider),
                        ),
                        const SizedBox(height: LivestSizes.lg),
                        const DividerWithText(),
                        const SizedBox(height: LivestSizes.lg),
                        CustomButton(
                          text: "Masuk dengan Google",
                          variant: ButtonVariant.google,
                          imagePath: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                          isLoading: authProvider.isLoading,
                          onPressed: () => _handleGoogleLogin(authProvider),
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
