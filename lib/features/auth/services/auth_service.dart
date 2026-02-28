import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Login Email Biasa
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message); // Lempar error bersih ke UI
    }
  }

  // 2. Register Email Biasa
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // 3. Login Menggunakan Google
  Future<void> signInWithGoogle() async {
    try {
      // WAJIB DIGANTI: Web Client ID dari Google Cloud Console
      const webClientId = '644958779222-1sm913p9bdno71a4bhma7n8mt9p1jkor.apps.googleusercontent.com';
      
      final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);
      final googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) throw Exception('Autentikasi Google dibatalkan.');

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('Gagal mendapatkan token kredensial dari Google.');
      }

      // Kirim token ke Supabase untuk verifikasi dan pembuatan sesi
      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      throw Exception('Gagal Login Google: $e');
    }
  }

  // 4. Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}