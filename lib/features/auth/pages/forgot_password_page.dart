import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/widgets/auth_footer_link.dart';
import 'package:livest/core/utils/widgets/auth_header.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/core/utils/widgets/otp_input.dart';
import 'package:livest/core/utils/widgets/password_requirements.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _step = 0;
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _hasMinLength = false;
  bool _hasNumber = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.sendPasswordResetOTP(_emailController.text.trim());
    if (ok && mounted) setState(() => _step = 1);
    if (!ok && mounted) _showError(auth);
  }

  Future<void> _verifyOtp(String code) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.verifyPasswordResetOTP(_emailController.text.trim(), code);
    if (ok && mounted) setState(() => _step = 2);
    if (!ok && mounted) _showError(auth);
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.updatePassword(_newPasswordController.text.trim());
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password berhasil diubah!"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
    if (!ok && mounted) _showError(auth);
  }

  void _showError(AuthProvider auth) {
    if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!), backgroundColor: const Color(0xFFE53935)),
      );
      auth.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = ["Lupa Password", "Verifikasi OTP", "Password Baru"];
    final subtitles = [
      "Masukkan email untuk menerima kode OTP",
      "Masukkan kode 6 digit yang dikirim ke email",
      "Buat password baru untuk akun Anda",
    ];
    final icons = [Icons.lock_reset, Icons.mark_email_read_outlined, Icons.lock_outline];

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: LivestColors.textPrimary),
              onPressed: () {
                if (_step > 0) {
                  setState(() => _step--);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: LivestSizes.lg),
              child: Column(
                children: [
                  const SizedBox(height: LivestSizes.lg),

                  // Header
                  AuthHeader(
                    title: titles[_step],
                    subtitle: subtitles[_step],
                    icon: icons[_step],
                  ),
                  const SizedBox(height: LivestSizes.lg),

                  // Step indicator
                  _buildStepBar(),
                  const SizedBox(height: LivestSizes.spaceBtwSections),

                  // Content
                  if (_step == 0) _emailStep(auth),
                  if (_step == 1) _otpStep(auth),
                  if (_step == 2) _passwordStep(auth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepBar() {
    return Row(
      children: List.generate(3, (i) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            decoration: BoxDecoration(
              color: i <= _step
                  ? LivestColors.primaryNormal
                  : LivestColors.primaryLightActive,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  Widget _emailStep(AuthProvider auth) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: "Email",
            hintText: "Masukkan email terdaftar",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || v.isEmpty) ? "Email tidak boleh kosong" : null,
          ),
          const SizedBox(height: LivestSizes.lg),
          CustomButton(text: "Kirim Kode OTP", isLoading: auth.isLoading, onPressed: _sendOtp),
        ],
      ),
    );
  }

  Widget _otpStep(AuthProvider auth) {
    return Column(
      children: [
        Text(
          _emailController.text.trim(),
          style: const TextStyle(fontWeight: FontWeight.w700, color: LivestColors.primaryNormal),
        ),
        const SizedBox(height: LivestSizes.lg),
        OtpInput(onCompleted: _verifyOtp),
        const SizedBox(height: LivestSizes.lg),
        if (auth.isLoading)
          const CircularProgressIndicator(color: LivestColors.primaryNormal),
        const SizedBox(height: LivestSizes.md),
        AuthFooterLink(
          text: "Tidak menerima kode? ",
          linkText: "Kirim Ulang",
          onTap: () async {
            if (auth.isLoading) return;
            final ok = await auth.sendPasswordResetOTP(_emailController.text.trim());
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok ? "Kode baru dikirim" : "Gagal"),
                  backgroundColor: ok ? Colors.green : const Color(0xFFE53935),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _passwordStep(AuthProvider auth) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: "Password Baru",
            hintText: "Masukkan password baru",
            controller: _newPasswordController,
            isPassword: true,
            onChanged: (val) {
              setState(() {
                _hasMinLength = val.length >= 8;
                _hasNumber = val.contains(RegExp(r'[0-9]'));
              });
            },
            validator: (v) =>
                (!_hasMinLength || !_hasNumber) ? "Password tidak memenuhi syarat" : null,
          ),
          const SizedBox(height: LivestSizes.spaceBtwInputFields),
          CustomTextField(
            label: "Konfirmasi Password",
            hintText: "Ulangi password baru",
            controller: _confirmPasswordController,
            isPassword: true,
            validator: (v) =>
                (v != _newPasswordController.text) ? "Password tidak cocok" : null,
          ),
          const SizedBox(height: LivestSizes.md),
          PasswordRequirements(hasMinLength: _hasMinLength, hasNumber: _hasNumber),
          const SizedBox(height: LivestSizes.lg),
          CustomButton(text: "Ubah Password", isLoading: auth.isLoading, onPressed: _updatePassword),
        ],
      ),
    );
  }
}
