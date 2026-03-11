import 'package:flutter/material.dart';
import 'package:livest/features/auth/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Login dengan email & password
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Register dengan email & password
  Future<List<bool>> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final requiresOtp = await _authService.signUpWithEmail(email, password);
      _setLoading(false);
      return [true, requiresOtp];
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return [false, false];
    }
  }

  /// Login dengan Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.signInWithGoogle();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Verifikasi kode OTP
  Future<bool> verifyOTP(String email, String otpCode) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.verifyOTP(email, otpCode);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Kirim ulang kode OTP
  Future<bool> resendOTP(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.resendOTP(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Kirim OTP reset password
  Future<bool> sendPasswordResetOTP(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.sendPasswordResetOTP(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Verifikasi OTP reset password
  Future<bool> verifyPasswordResetOTP(String email, String otpCode) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.verifyPasswordResetOTP(email: email, otpCode: otpCode);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Update password (setelah OTP verified)
  Future<bool> updatePassword(String newPassword) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authService.updatePassword(newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Logout
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }
}
