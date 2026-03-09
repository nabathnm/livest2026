import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
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
  final GlobalKey<OtpInputState> _otpKey = GlobalKey<OtpInputState>();

  String get _maskedEmail {
    final parts = widget.email.split('@');
    if (parts.length != 2 || parts[0].length < 3) return widget.email;
    final name = parts[0];
    final masked = '${name.substring(0, 3)}${'*' * (name.length - 3)}';
    return '$masked@${parts[1]}';
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

                  // Title
                  const AuthHeader(
                    title: "Verifikasi OTP",
                    subtitle: "",
                    showTabs: false,
                  ),

                  // Subtitle dengan masked email
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: LivestSizes.fontSizeSm,
                        color: LivestColors.textSecondary,
                        fontFamily: 'PlusJakartaSans',
                      ),
                      children: [
                        const TextSpan(
                            text: "Kami mengirimkan 4 digit kode ke\n"),
                        TextSpan(
                          text: _maskedEmail,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
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

                  // OTP Input + Timer
                  OtpInput(
                    key: _otpKey,
                    length: 8,
                    onCompleted: (code) {
                      setState(() => _otpCode = code);
                    },
                    onChanged: (code) {
                      setState(() => _otpCode = code);
                    },
                  ),
                  const SizedBox(height: LivestSizes.md),

                  // Kirim ulang OTP
                  GestureDetector(
                    onTap: () async {
                      if (authProvider.isLoading) return;
                      final ok = await authProvider.resendOTP(widget.email);
                      _otpKey.currentState?.restartTimer();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? "OTP telah dikirimkan ulang.\nCek kembali email anda"
                                  : "Gagal mengirim ulang OTP",
                            ),
                            backgroundColor:
                                ok ? Colors.green : const Color(0xFFE53935),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Kirim ulang OTP",
                      style: TextStyle(
                        color: LivestColors.textSecondary,
                        fontSize: LivestSizes.fontSizeSm,
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
                      onPressed: _otpCode.length == 4
                          ? () async {
                              final ok = await authProvider.verifyOTP(
                                widget.email,
                                _otpCode,
                              );
                              if (ok && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Email berhasil diverifikasi!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteGenerator.rolePage,
                                  (route) => false,
                                );
                              } else if (mounted &&
                                  authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(authProvider.errorMessage!),
                                    backgroundColor:
                                        const Color(0xFFE53935),
                                  ),
                                );
                                authProvider.clearError();
                              }
                            }
                          : null,
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
