import 'package:flutter/material.dart';
import 'package:livest/features/auth/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  String? phone;
  String? token;
  bool? isAvaible;

  // bool _isLoading = false;
  // bool _isError = false;

  // Cek
  Future<void> cekNomor(String phone) async {
    final tersedia = await _authService.checkNumber(phone);

    // Jika avaible maka kirim otp kemudian ke home
    // Jika tidak avaible kirim otp dan isi username
    // if (tersedia) {
    //   Navigator.push(context, route)
    // } else {
    //   Navigator.push(context, route)
    // }
  }
}
