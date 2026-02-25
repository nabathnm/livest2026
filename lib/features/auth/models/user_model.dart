import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String? email;
  final String? phone;

  UserModel({required this.id, this.email, this.phone});

  factory UserModel.fromSupabase(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      phone: user.userMetadata?['phone'],
    );
  }
}
