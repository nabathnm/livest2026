import 'package:flutter/material.dart';
import 'package:livest/features/auth/pages/otp_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool isFilled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Register Page"),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(label: Text("email")),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(label: Text("password")),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(label: Text("phone")),
            ),
            ElevatedButton(
              onPressed: () {
                final phone = _phoneController.text.trim();

                if (phone.isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtpPage()),
                );
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
