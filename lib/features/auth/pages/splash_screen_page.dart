import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/config/supabase_config.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/livest.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  String? _targetRoute;
  bool _animationDone = false;
  bool _authCheckDone = false;

  @override
  void initState() {
    super.initState();
    _startAnimationTimer();
    _waitForSupabaseThenCheck();
  }

  void _startAnimationTimer() {
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _animationDone = true;
        _tryNavigate();
      }
    });
  }

  Future<void> _waitForSupabaseThenCheck() async {
    await Livest.supabaseReady.future;
    if (!mounted) return;
    await _checkAuthAndProfile();
  }

  Future<void> _checkAuthAndProfile() async {
    try {
      final session = SupabaseConfig.client.auth.currentSession;

      if (session == null) {
        _targetRoute = RouteGenerator.login;
      } else {
        final user = SupabaseConfig.client.auth.currentUser;
        if (user != null && user.emailConfirmedAt == null) {
          _targetRoute = RouteGenerator.login;
          return;
        }

        final profileProvider = context.read<ProfileProvider>();
        await profileProvider.fetchProfile();

        final role = profileProvider.role;

        if (role == null) {
          _targetRoute = RouteGenerator.rolePage;
        } else if (role == 'peternak') {
          _targetRoute = RouteGenerator.breaderHome;
        } else if (role == 'pembeli') {
          _targetRoute = RouteGenerator.buyerHome;
        } else {
          _targetRoute = RouteGenerator.login;
        }
      }
    } catch (e) {
      _targetRoute = RouteGenerator.login;
    }

    if (mounted) {
      _authCheckDone = true;
      _tryNavigate();
    }
  }

  void _tryNavigate() {
    if (_animationDone && _authCheckDone && _targetRoute != null && mounted) {
      Navigator.pushReplacementNamed(context, _targetRoute!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff998573),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                  height: 42,
                  width: 42,
                  decoration: const BoxDecoration(
                    color: LivestColors.primaryNormal,
                    shape: BoxShape.circle,
                  ),
                )
                .animate(delay: 200.ms)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(30, 30),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
            Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: LivestColors.baseWhite,
                    shape: BoxShape.circle,
                  ),
                )
                .animate(delay: 2000.ms)
                .scale(
                  delay: 5000.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(25, 25),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .scale(
                  delay: 300.ms,
                  begin: const Offset(1, 1),
                  end: const Offset(8, 8),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .animate(delay: 300.ms)
                .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(25, 25),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png')
                    .animate(delay: 1100.ms)
                    .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: -0.50,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    )
                    .scale(
                      delay: 1000.ms,
                      begin: const Offset(1, 1),
                      end: const Offset(-20, -20),
                      curve: Curves.easeOut,
                    ),
                const SizedBox(height: 4),
                const Text(
                      "Livest",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: LivestColors.primaryNormal,
                      ),
                    )
                    .animate(delay: 1100.ms)
                    .fadeIn(duration: 500.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.50,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    )
                    .scale(
                      delay: 1000.ms,
                      begin: const Offset(1, 1),
                      end: const Offset(-20, -20),
                      curve: Curves.easeOut,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
