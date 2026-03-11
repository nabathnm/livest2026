import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';
import 'package:livest/core/routes/route_generator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _step = 0;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() => _emailError = null);
    if (!_formKey.currentState!.validate()) return;
    
    // Custom email validation for the "Email invalid" UI
    final email = _emailController.text.trim();
    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(email)) {
      setState(() => _emailError = "Email invalid");
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.sendPasswordResetOTP(email);
    if (ok && mounted) {
      setState(() => _step = 1);
    } else if (!ok && mounted) {
      // Mock error if failed for any reason
      setState(() => _emailError = auth.errorMessage ?? "Gagal mengirim OTP");
    }
  }

  void _onBackPress() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
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
                // Top Custom Back Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(LivestSizes.lg, LivestSizes.lg, LivestSizes.lg, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: _onBackPress,
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
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(LivestSizes.lg),
                    child: _step == 0 ? _buildEmailForm(auth) : _buildSuccessScreen(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailForm(AuthProvider auth) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            "Lupa Password?",
            style: LivestTypography.displayMd,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LivestSizes.sm),
          Text(
            "Masukkan email yang terdaftar dengan akun\nkamu dan kode OTP akan dikirimkan.",
            style: LivestTypography.bodySm.copyWith(
              color: LivestColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Custom Input Field with explicit error state matching screenshot
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email",
                style: LivestTypography.bodySmMedium.copyWith(
                  color: LivestColors.textPrimary,
                ),
              ),
              const SizedBox(height: LivestSizes.sm),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                   if (_emailError != null) setState(() => _emailError = null);
                },
                decoration: InputDecoration(
                  hintText: "Masukkan email",
                  hintStyle: LivestTypography.bodySm.copyWith(
                    color: LivestColors.primaryLightActive,
                  ),
                  filled: true,
                  fillColor: LivestColors.baseWhite,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: LivestSizes.md,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: _emailError != null ? LivestColors.redNormal : LivestColors.primaryLightActive,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: _emailError != null ? LivestColors.redNormal : LivestColors.primaryNormal,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0),
                    borderSide: BorderSide(
                      color: _emailError != null ? LivestColors.redNormal : LivestColors.primaryNormal,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _emailError!,
                      style: LivestTypography.textSm.copyWith(
                        color: LivestColors.redNormal,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Spacer pushes button to a reasonable distance, screenshot shows it lower
          const SizedBox(height: 200),
          
          CustomButton(
            text: "Konfirmasi",
            isLoading: auth.isLoading,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (_emailController.text.isEmpty) {
                 setState(() => _emailError = "Email invalid");
                 return;
              }
              _sendOtp();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Image.asset(
          'assets/images/login/sapiberjubah.png',
          height: 180,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 32),
        Text(
          "OTP berhasil dikirimkan",
          style: LivestTypography.h2.copyWith(
            color: LivestColors.textHeading,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Tekan tombol dibawah untuk verifikasi OTP",
          style: LivestTypography.bodySm.copyWith(
            color: LivestColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 120),
        
        CustomButton(
          text: "Lanjut Verifikasi OTP",
          onPressed: () {
            Navigator.pushReplacementNamed(
              context, 
              RouteGenerator.forgotPasswordOtp,
              arguments: _emailController.text.trim(),
            );
          },
        ),
      ],
    );
  }
}
