import 'package:flutter/material.dart';
import 'package:livest/features/auth/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;
  String? _errorMessage;

  bool get isEmailLoading => _isEmailLoading;
  bool get isGoogleLoading => _isGoogleLoading;
  bool get isLoading => _isEmailLoading || _isGoogleLoading;
  String? get errorMessage => _errorMessage;

  void _setEmailLoading(bool value) {
    _isEmailLoading = value;
    notifyListeners();
  }

  void _setGoogleLoading(bool value) {
    _isGoogleLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _setEmailLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.signInWithEmail(email, password);
      _setEmailLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setEmailLoading(false);
      return false;
    }
  }

  Future<List<bool>> signUpWithEmail(String email, String password) async {
    _setEmailLoading(true);
    _errorMessage = null;
    try {
      final requiresOtp = await _authRepository.signUpWithEmail(email, password);
      _setEmailLoading(false);
      return [true, requiresOtp];
    } catch (e) {
      _errorMessage = e.toString();
      _setEmailLoading(false);
      return [false, false];
    }
  }

  Future<bool> signInWithGoogle() async {
    _setGoogleLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.signInWithGoogle();
      _setGoogleLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setGoogleLoading(false);
      return false;
    }
  }

  Future<bool> signUpWithGoogle() async {
    _setGoogleLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.signUpWithGoogle();
      _setGoogleLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setGoogleLoading(false);
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String otpCode) async {
    _setEmailLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.verifyOTP(email, otpCode);
      _setEmailLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setEmailLoading(false);
      return false;
    }
  }

  Future<bool> resendOTP(String email) async {
    _setEmailLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.resendOTP(email);
      _setEmailLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setEmailLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetOTP(String email) async {
    _setEmailLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.sendPasswordResetOTP(email);
      _setEmailLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setEmailLoading(false);
      return false;
    }
  }

  Future<bool> verifyPasswordResetOTP(String email, String otpCode) async {
    _setEmailLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.verifyPasswordResetOTP(email: email, otpCode: otpCode);
      _setEmailLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setEmailLoading(false);
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    _setEmailLoading(true);
    _errorMessage = null;
    try {
      await _authRepository.updatePassword(newPassword);
      _setEmailLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setEmailLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    _setEmailLoading(true);
    try {
      await _authRepository.signOut();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setEmailLoading(false);
  }
}
