import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';
import '../../../core/constants/supabase_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login({required String email, required String password}) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.session == null) {
      throw AuthException('Login gagal');
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw AuthException('Register gagal');
    }
  }
}
