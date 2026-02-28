import 'package:flutter/material.dart';
import 'package:livest/features/auth/pages/splash_page.dart';
import 'package:livest/features/auth/pages/login_page.dart';
import 'package:livest/features/auth/pages/register_page.dart';
import 'package:livest/features/onboarding/pages/onboarding_page.dart';
import 'package:livest/features/user/main_page.dart'; 

class RouteGenerator {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  
  // Rute terpisah berdasarkan role
  static const String peternakHome = '/peternak-home';
  static const String pembeliHome = '/pembeli-home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash: return MaterialPageRoute(builder: (_) => const SplashPage());
      case login: return MaterialPageRoute(builder: (_) => const LoginPage());
      case register: return MaterialPageRoute(builder: (_) => const RegisterPage());
      case onboarding: return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case peternakHome: return MaterialPageRoute(builder: (_) => const MainPage()); 
      case pembeliHome: return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text("Halaman Pembeli")))); 
      default: return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Route Not Found'))));
    }
  }
}