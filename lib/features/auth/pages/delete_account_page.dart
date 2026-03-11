import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/features/auth/providers/auth_provider.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSuccess = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submitDelete() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    
    // Asumsikan di sini kita melakukan re-autentikasi dan mencoba hapus user
    // Karena Supabase secara default butuh Admin API/RPC, kita simulasikan
    final email = profileProvider.profileData?['email'];
    if (email != null) {
      final success = await authProvider.signInWithEmail(email, _passwordController.text);
      if (success) {
        // Melakukan Soft Delete melalui Profile Provider
        final deleteSuccess = await profileProvider.softDeleteAccount();
        
        if (deleteSuccess) {
          await authProvider.signOut();
          profileProvider.clearProfile();

          if (mounted) {
            setState(() {
              _isSuccess = true;
              _isLoading = false;
            });
          }
        } else {
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(profileProvider.errorMessage ?? "Gagal menghapus akun"),
                backgroundColor: const Color(0xFFE53935),
              ),
            );
          }
        }
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Password tidak sesuai!"),
              backgroundColor: Color(0xFFE53935),
            ),
          );
        }
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return _buildSuccessView();
    }

    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: AppBar(
        backgroundColor: LivestColors.baseWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: LivestColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Hapus Akun",
          style: TextStyle(
            color: LivestColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                "Akun akan terhapus selamanya jika Anda menghapus akun. Masukkan password kamu untuk konfirmasi sebelum menghapus akun.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: LivestColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: "Password",
                controller: _passwordController,
                isPassword: true,
                hintText: "Masukkan password",
                prefixIcon: const SizedBox.shrink(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lengkapi password dahulu";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F), // Red color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Hapus Akun", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // MOCKED IMAGE USING ICON FOR NOW
              const Icon(Icons.sentiment_dissatisfied, size: 100, color: LivestColors.primaryNormal),
              const SizedBox(height: 32),
              const Text(
                "Penghapusan akun berhasil!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: LivestColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Datamu telah dihapus. Terima kasih telah menjadi bagian dari Livest. Sampai jumpa lagi di lain waktu.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: LivestColors.textPrimary,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.login, (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LivestColors.primaryNormal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("Selesai", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
