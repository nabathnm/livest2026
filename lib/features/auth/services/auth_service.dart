import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      const webClientId =
          '644958779222-1sm913p9bdno71a4bhma7n8mt9p1jkor.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) throw Exception('Autentikasi Google dibatalkan.');

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Gagal mendapatkan token kredensial dari Google.');
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      throw Exception('Gagal Login Google: $e');
    }
  }

  Future<void> verifyOTP(String email, String otpCode) async {
    try {
      await _supabase.auth.verifyOTP(
        email: email,
        token: otpCode,
        type: OtpType.signup,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> resendOTP(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> sendPasswordResetOTP(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> verifyPasswordResetOTP({
    required String email,
    required String otpCode,
  }) async {
    try {
      await _supabase.auth.verifyOTP(
        email: email,
        token: otpCode,
        type: OtpType.recovery,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
