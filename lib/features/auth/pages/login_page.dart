import 'package:flutter/material.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/features/auth/services/auth_service.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _execute(Future<void> Function() action) async {
    FocusScope.of(context).unfocus();
    if (_email.text.isEmpty && action != _authService.signInWithGoogle) return;

    setState(() => _isLoading = true);
    try {
      await action();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Livest",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              CustomTextField(
                label: "Email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Password",
                controller: _password,
                isPassword: true,
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: "Masuk",
                isLoading: _isLoading,
                onPressed: () => _execute(
                  () => _authService.signInWithEmail(
                    _email.text.trim(),
                    _password.text.trim(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Masuk dengan Google",
                variant: ButtonVariant.outlined,
                icon: Icons.g_mobiledata,
                isLoading: _isLoading,
                onPressed: () => _execute(_authService.signInWithGoogle),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: "Belum punya akun? Daftar sekarang.",
                variant: ButtonVariant.text,
                isLoading: _isLoading,
                onPressed: () =>
                    Navigator.pushNamed(context, RouteGenerator.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
