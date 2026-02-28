// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthService {
//   final SupabaseClient _supabaseClient = Supabase.instance.client;

//   // Cek akun
//   Future<bool> checkNumber(String phone) async {
//     final bool data = await _supabaseClient.rpc(
//       'check_phone',
//       params: {'p_phone': phone},
//     );
//     return data;
//   }

//   // Tambah nomor
//   Future<void> register(String phone) async {
//     await _supabaseClient.auth.signInWithOtp(phone: phone);
//   }

//   // Verifikasi otp
//   Future<void> verifyOtp(String phone, String token) async {
//     await _supabaseClient.auth.verifyOTP(
//       phone: phone,
//       token: token,
//       type: OtpType.sms,d
//     );
//   }

//   // Logout
//   Future<void> logout() async {
//     await _supabaseClient.auth.signOut();
//   }
// }
