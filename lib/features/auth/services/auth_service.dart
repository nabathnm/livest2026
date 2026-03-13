import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signInWithGoogle() async {
    const webClientId =
        '644958779222-1sm913p9bdno71a4bhma7n8mt9p1jkor.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) throw 'Autentikasi Google dibatalkan.';

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'Gagal mendapatkan token kredensial dari Google.';
    }

    return await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<AuthResponse> verifyOTP(String email, String otpCode) async {
    return await _supabase.auth.verifyOTP(
      email: email,
      token: otpCode,
      type: OtpType.signup,
    );
  }

  Future<void> resendOTP(String email) async {
    await _supabase.auth.resend(type: OtpType.signup, email: email);
  }

  Future<void> sendPasswordResetOTP(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<AuthResponse> verifyPasswordResetOTP({
    required String email,
    required String otpCode,
  }) async {
    return await _supabase.auth.verifyOTP(
      email: email,
      token: otpCode,
      type: OtpType.recovery,
    );
  }

  Future<UserResponse> updatePassword(String newPassword) async {
    return await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
