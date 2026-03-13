import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/auth_footer_link.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field_pill.dart';
import 'package:livest/core/utils/widgets/otp_input.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  final String email;
  const ForgotPasswordOtpPage({super.key, required this.email});

  @override
  State<ForgotPasswordOtpPage> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  int _step = 0; 
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _hasMinLength = false;
  bool _hasNumber = false;
  String? _formError;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp(String code) async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.verifyPasswordResetOTP(widget.email, code);
    if (ok && mounted) {
      setState(() {
        _formError = null;
        _step = 1;
      });
    } else if (!ok && mounted) {
      String finalError = "Kode OTP tidak sesuai!";
      if (auth.errorMessage?.toLowerCase().contains("expired") ?? false) {
        finalError = "Kode OTP kadaluwarsa, kirim ulang OTP.";
      }
      setState(() => _formError = finalError);
      auth.clearError();
    }
  }

  void _showConfirmUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFF1EBE6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Yakin ingin mengubah\npassword?",
                  textAlign: TextAlign.center,
                  style: LivestTypography.bodyLgBold.copyWith(
                    color: LivestColors.textHeading,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Perubahan dapat diubah kembali.",
                  textAlign: TextAlign.center,
                  style: LivestTypography.bodySm.copyWith(
                    color: LivestColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: LivestColors.primaryNormal,
                            ),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Kembali",
                            style: LivestTypography.buttonLg.copyWith(
                              color: LivestColors.primaryNormal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context); 
                          await _executeUpdatePassword();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: LivestColors.primaryNormal,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Simpan",
                            style: LivestTypography.buttonLg.copyWith(
                              color: LivestColors.baseWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFF1EBE6),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: LivestColors.baseWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: LivestColors.textHeading, width: 2),
                ),
                child: const Icon(
                  Icons.check,
                  color: LivestColors.textHeading,
                  size: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Ganti Password Berhasil!\nLogin dengan password baru!",
                textAlign: TextAlign.center,
                style: LivestTypography.bodyLgBold.copyWith(
                  color: LivestColors.textHeading,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteGenerator.login,
                    (route) => false,
                  );
                },
                child: Text(
                  "Tekan untuk lewati",
                  style: LivestTypography.bodySm.copyWith(
                    color: LivestColors.primaryNormal,
                    decoration: TextDecoration.underline,
                    decorationColor: LivestColors.primaryNormal,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _executeUpdatePassword() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.updatePassword(_newPasswordController.text.trim());

    if (ok && mounted) {
      _showSuccessUpdateDialog();
    } else if (!ok && mounted) {
      setState(
        () => _formError = auth.errorMessage ?? "Gagal mereset password",
      );
      auth.clearError();
    }
  }

  void _onUbahPasswordPressed() {
    setState(() => _formError = null);
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _formError = "Password tidak cocok");
      return;
    }

    if (!_hasMinLength || !_hasNumber) {
      setState(() => _formError = "Password belum memenuhi syarat");
      return;
    }

    _showConfirmUpdateDialog();
  }

  void _showResendPopup() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(top: 60, left: 16, right: 16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              decoration: BoxDecoration(
                color: const Color(0xFFF1EBE6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: LivestColors.textHeading,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "OTP telah dikirimkan ulang.\nCek kembali email anda",
                    textAlign: TextAlign.center,
                    style: LivestTypography.bodySmMedium.copyWith(
                      color: LivestColors.textHeading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LivestSizes.lg,
                LivestSizes.lg,
                LivestSizes.lg,
                0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (_step == 1) {
                      setState(() => _step = 0);
                    } else {
                      Navigator.pop(context);
                    }
                  },
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
                child: _step == 0
                    ? _buildOtpScreen()
                    : _buildNewPasswordScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpScreen() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Column(
          children: [
            const SizedBox(height: 32),
            Text(
              "Verifikasi OTP",
              style: LivestTypography.displayMd.copyWith(
                color: LivestColors.textHeading,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: LivestSizes.sm),
            Text(
              "Masukkan kode 6 digit yang telah dikirim\nke ${widget.email}",
              style: LivestTypography.bodySm.copyWith(
                color: LivestColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            OtpInput(
              onCompleted: _verifyOtp,
              onChanged: (_) => setState(() => _formError = null),
            ),

            const SizedBox(height: LivestSizes.lg),

            if (_formError != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: LivestColors.redLight,
                  borderRadius: BorderRadius.circular(
                    LivestSizes.inputFieldRadius,
                  ),
                ),
                child: Text(
                  _formError!,
                  textAlign: TextAlign.center,
                  style: LivestTypography.buttonSm.copyWith(
                    color: LivestColors.redNormal,
                  ),
                ),
              ),
              const SizedBox(height: LivestSizes.lg),
            ],

            if (auth.isLoading)
              const CircularProgressIndicator(
                color: LivestColors.primaryNormal,
              ),
            const SizedBox(height: LivestSizes.md),

            AuthFooterLink(
              text: "Tidak menerima kode? ",
              linkText: "Kirim Ulang",
              onTap: () async {
                if (auth.isLoading) return;
                setState(() => _formError = null);
                final ok = await auth.sendPasswordResetOTP(widget.email);
                if (mounted) {
                  if (ok) {
                    _showResendPopup();
                  } else {
                    setState(() => _formError = "Gagal mengirim ulang");
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewPasswordScreen() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            "Password Baru",
            style: LivestTypography.displayMd.copyWith(
              color: LivestColors.textHeading,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LivestSizes.sm),
          Text(
            "Buat password baru yang kuat untuk\nmengamankan akun Anda.",
            style: LivestTypography.bodySm.copyWith(
              color: LivestColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Password Baru",
              style: LivestTypography.bodySmMedium.copyWith(
                color: LivestColors.textHeading,
              ),
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFieldPill(
            label: "",
            hintText: "Masukkan password baru",
            prefixIcon: const Icon(
              Icons.person_outline,
              color: LivestColors.textSecondary,
              size: 20,
            ),
            controller: _newPasswordController,
            isPassword: true,
            validator: (v) => null, 
            onChanged: (val) {
              setState(() {
                _hasMinLength = val.length >= 8;
                _hasNumber = val.contains(RegExp(r'\d'));
                if (_formError != null) _formError = null;
              });
            },
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Konfirmasi Password",
              style: LivestTypography.bodySmMedium.copyWith(
                color: LivestColors.textHeading,
              ),
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFieldPill(
            label: "",
            hintText: "Ulangi password baru",
            prefixIcon: const Icon(
              Icons.person_outline,
              color: LivestColors.textSecondary,
              size: 20,
            ),
            controller: _confirmPasswordController,
            isPassword: true,
            validator: (v) => null,
            onChanged: (_) => setState(() => _formError = null),
          ),

          if (_newPasswordController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: LivestSizes.spaceBtwInputFields,
              ),
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

          const SizedBox(height: LivestSizes.lg),

          if (_formError != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                bottom: LivestSizes.spaceBtwInputFields,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: LivestColors.redLight,
                borderRadius: BorderRadius.circular(
                  LivestSizes.inputFieldRadius,
                ),
              ),
              child: Text(
                _formError!,
                textAlign: TextAlign.center,
                style: LivestTypography.buttonSm.copyWith(
                  color: LivestColors.redNormal,
                ),
              ),
            ),

          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return CustomButton(
                text: "Ubah Password",
                isLoading: auth.isLoading,
                onPressed: _onUbahPasswordPressed,
              );
            },
          ),
        ],
      ),
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
