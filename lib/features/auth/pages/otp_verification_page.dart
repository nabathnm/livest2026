import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/core/utils/widgets/auth_header.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/otp_input.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({super.key, required this.email});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String _otpCode = '';
  String? _otpError;
  final GlobalKey<OtpInputState> _otpKey = GlobalKey<OtpInputState>();

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2 || parts[0].length < 3) return widget.email;
    final name = parts[0];
    final masked = '${name.substring(0, 3)}${'*' * (name.length - 3)}';
    return '$masked@${parts[1]}';
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                child: const Icon(Icons.check, color: LivestColors.textHeading, size: 20),
              ),
              const SizedBox(height: 16),
              Text(
                "Verifikasi Berhasil!",
                style: LivestTypography.bodyLgBold.copyWith(color: LivestColors.textHeading),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.rolePage, (route) => false);
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
                  const Icon(Icons.info_outline, color: LivestColors.textHeading),
                  const SizedBox(height: 12),
                  Text(
                    "OTP telah dikirimkan ulang.\nCek kembali email anda",
                    textAlign: TextAlign.center,
                    style: LivestTypography.bodySmMedium.copyWith(
                      color: LivestColors.textHeading,
                    ),
                  )
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: LivestColors.baseWhite,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: LivestColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: LivestSizes.lg),
              child: Column(
                children: [
                  const SizedBox(height: LivestSizes.md),
                  const AuthHeader(
                    title: "Verifikasi OTP",
                    subtitle: "",
                    showTabs: false,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: LivestTypography.bodySm.copyWith(
                        color: LivestColors.textSecondary,
                        fontFamily: 'PlusJakartaSans',
                      ),
                      children: [
                        const TextSpan(
                            text: "Kami mengirimkan 6 digit kode ke\n"),
                        TextSpan(
                          text: _maskedEmail,
                          style: LivestTypography.bodySmBold.copyWith(
                            color: LivestColors.primaryNormal,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ".\nMasukkan kode tersebut untuk melanjutkan.",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: LivestSizes.spaceBtwSections),
                  OtpInput(
                    key: _otpKey,
                    length: 6,
                    onCompleted: (code) {
                      setState(() {
                        _otpCode = code;
                        _otpError = null;
                      });
                    },
                    onChanged: (code) {
                      setState(() {
                        _otpCode = code;
                        _otpError = null;
                      });
                    },
                  ),
                  const SizedBox(height: LivestSizes.lg),
                  
                  if (_otpError != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: LivestColors.redLight,
                        borderRadius: BorderRadius.circular(LivestSizes.inputFieldRadius),
                      ),
                      child: Text(
                        _otpError!,
                        textAlign: TextAlign.center,
                        style: LivestTypography.buttonSm.copyWith(
                          color: LivestColors.redNormal,
                        ),
                      ),
                    ),
                    const SizedBox(height: LivestSizes.lg),
                  ],

                  // Kirim ulang OTP
                  GestureDetector(
                    onTap: () async {
                      if (authProvider.isLoading) return;
                      setState(() => _otpError = null);
                      final ok = await authProvider.resendOTP(widget.email);
                      _otpKey.currentState?.restartTimer();
                      if (mounted) {
                        if (ok) {
                          _showResendPopup();
                        } else {
                          setState(() => _otpError = "Gagal mengirim ulang OTP");
                        }
                      }
                    },
                    child: Text(
                      "Kirim ulang OTP",
                      style: LivestTypography.bodySm.copyWith(
                        color: LivestColors.textSecondary,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Tombol Konfirmasi Kode
                  Padding(
                    padding: const EdgeInsets.only(bottom: LivestSizes.xl),
                    child: CustomButton(
                      text: "Konfirmasi Kode",
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_otpCode.length < 6) {
                          setState(() => _otpError = "Lengkapi kode OTP dahulu!");
                          return;
                        }
                        
                        setState(() => _otpError = null);
                        final ok = await authProvider.verifyOTP(
                          widget.email,
                          _otpCode,
                        );
                        if (ok && mounted) {
                          _showSuccessDialog();
                        } else if (mounted) {
                          String finalError = "Kode OTP tidak sesuai!";
                          if (authProvider.errorMessage?.toLowerCase().contains("expired") ?? false) {
                            finalError = "Kode OTP kadaluwarsa, kirim ulang OTP.";
                          }
                          setState(() => _otpError = finalError);
                          authProvider.clearError();
                        }
                      },
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
}
