import 'package:flutter/material.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';
import 'package:livest/core/utils/widgets/custom_text_field.dart';
import 'package:livest/features/auth/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _isLoading = false;
  bool _hasMinLength = false;
  bool _hasNumber = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _executeRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.signUpWithEmail(
        _email.text.trim(),
        _password.text.trim(),
      );
      if (mounted)
        Navigator.pushReplacementNamed(context, RouteGenerator.login);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Logika Signup Google
  void _executeGoogleSignup() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              CustomTextField(
                label: "Email",
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Email tidak boleh kosong";
                  if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value))
                    return "Email invalid!";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Buat password baru",
                controller: _password,
                isPassword: true,
                onChanged: (val) {
                  setState(() {
                    _hasMinLength = val.length >= 8;
                    _hasNumber = val.contains(RegExp(r'[0-9]'));
                  });
                },
                validator: (value) => (!_hasMinLength || !_hasNumber)
                    ? "Password tidak memenuhi syarat"
                    : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Konfirmasi password",
                controller: _confirmPassword,
                isPassword: true,
                validator: (value) => (value != _password.text)
                    ? "Konfirmasi password tidak sesuai!"
                    : null,
              ),
              const SizedBox(height: 24),

              const Text(
                "Password harus memenuhi:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildIndicatorRow("Panjang minimal 8 karakter", _hasMinLength),
              const SizedBox(height: 4),
              _buildIndicatorRow("Terdapat minimal 1 angka", _hasNumber),
              const SizedBox(height: 32),
              CustomButton(
                text: "Sign Up",
                isLoading: _isLoading,
                onPressed: _executeRegister,
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: "Signup with Google",
                variant: ButtonVariant.text,
                icon: Icons.g_mobiledata,
                isLoading: _isLoading,
                onPressed: _executeGoogleSignup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isValid ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: isValid ? Colors.black : Colors.grey),
        ),
      ],
    );
  }
}
