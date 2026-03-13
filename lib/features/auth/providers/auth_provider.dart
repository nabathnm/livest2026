import 'package:flutter/material.dart';
import 'package:livest/features/auth/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

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

  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<List<bool>> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final requiresOtp = await _authRepository.signUpWithEmail(email, password);
      _setLoading(false);
      return [true, requiresOtp];
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return [false, false];
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.signInWithGoogle();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String otpCode) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.verifyOTP(email, otpCode);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resendOTP(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.resendOTP(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetOTP(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.sendPasswordResetOTP(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyPasswordResetOTP(String email, String otpCode) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.verifyPasswordResetOTP(email: email, otpCode: otpCode);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.updatePassword(newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }
}
