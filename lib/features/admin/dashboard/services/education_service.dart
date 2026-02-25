import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class EducationService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Tambah
  Future<void> uploadEducation(String title, String desc) async {
    await _supabaseClient.from('educations').insert({
      'title': title,
      'desc': desc,
    });
  }

  // Tambah Gambar
  Future<String> uploadImage(File file, String UserId) async {
    final fileExt = file.path.split('.').last;
    final filePath = 'avatars/$UserId.$fileExt';

    await _supabaseClient.storage
        .from('educationImage')
        .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

    final publicUrl = _supabaseClient.storage
        .from('educationImage')
        .getPublicUrl(filePath);

    return publicUrl;
  }

  // Edit

  // Hapus
}
