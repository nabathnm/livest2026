import 'package:flutter/material.dart';
import 'package:livest/core/config/supabase_config.dart';
import 'package:livest/core/routes/route_generator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // PERBAIKAN: Tunggu sampai widget selesai di-build, baru jalankan fungsi navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndRoute();
    });
  }

  Future<void> _checkAuthAndRoute() async {
    // Beri sedikit jeda buatan agar user sempat melihat logo/loading screen
    // (Opsional, tapi bagus untuk UX)
    await Future.delayed(const Duration(milliseconds: 500));

    final session = SupabaseConfig.client.auth.currentSession;

    // 1. Jika belum login (session kosong), tendang ke halaman Login
    if (session == null) {
      if (mounted)
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      return;
    }

    try {
      // 2. Ambil profil user dari database
      final profile = await SupabaseConfig.client
          .from('profiles')
          .select('role')
          .eq('id', session.user.id)
          .maybeSingle();

      if (!mounted) return;

      // 3. Logika Pemisahan Rute
      if (profile == null || profile['role'] == null) {
        // Jika profil kosong (baru daftar), paksa ke Onboarding
        Navigator.pushReplacementNamed(context, RouteGenerator.onboarding);
      } else if (profile['role'] == 'peternak') {
        // Jika peternak, lempar ke Dashboard Peternak
        Navigator.pushReplacementNamed(context, RouteGenerator.breaderHome);
      } else if (profile['role'] == 'pembeli') {
        // Jika pembeli, lempar ke Dashboard Pembeli
        Navigator.pushReplacementNamed(context, RouteGenerator.buyerHome);
      } else {
        // Fallback keamanan
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
      }
    } catch (e) {
      // Jika error (misal koneksi mati), kembalikan ke login
      if (mounted)
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.amber)),
    );
  }
}
