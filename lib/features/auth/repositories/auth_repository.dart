import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:livest/features/auth/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _authService.signInWithEmail(email, password);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      final response = await _authService.signUpWithEmail(email, password);
      return response.session == null;
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      await _authService.signUpWithGoogle();
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> verifyOTP(String email, String otpCode) async {
    try {
      await _authService.verifyOTP(email, otpCode);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> resendOTP(String email) async {
    try {
      await _authService.resendOTP(email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> sendPasswordResetOTP(String email) async {
    try {
      await _authService.sendPasswordResetOTP(email);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> verifyPasswordResetOTP({
    required String email,
    required String otpCode,
  }) async {
    try {
      await _authService.verifyPasswordResetOTP(email: email, otpCode: otpCode);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _authService.updatePassword(newPassword);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw e.toString();
    }
  }
}
