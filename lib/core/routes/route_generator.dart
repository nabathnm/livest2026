import 'package:flutter/material.dart';
import 'package:livest/features/auth/pages/onboarding_page.dart';
import 'package:livest/features/auth/pages/splash_page.dart';
import 'package:livest/features/auth/pages/login_page.dart';
import 'package:livest/features/auth/pages/register_page.dart';
import 'package:livest/features/breader/breader_main_page.dart';
import 'package:livest/features/buyer/buyer_main_page.dart';

class RouteGenerator {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';

  static const String breaderHome = '/peternak-home';
  static const String buyerHome = '/pembeli-home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case breaderHome:
        return MaterialPageRoute(builder: (_) => const BreaderMainPage());
      case buyerHome:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: BuyerMainPage()),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route Not Found'))),
        );
    }
  }
}
