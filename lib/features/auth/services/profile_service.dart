import 'package:livest/core/data/models/profile_model.dart';
import 'package:livest/core/services/base_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service untuk operasi CRUD profil user di Supabase.
/// Extends BaseSupabaseService untuk memanfaatkan shared CRUD logic.
class ProfileService extends BaseSupabaseService<ProfileModel> {
  @override
  String get tableName => 'profiles';

  @override
  ProfileModel fromJson(Map<String, dynamic> json) {
    return ProfileModel.fromJson(json);
  }

  /// Fetch profil berdasarkan user ID
  Future<ProfileModel?> fetchByUserId(String userId) async {
    print('DEBUG SERVICE: querying profiles where id = $userId');

    final data = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    print('DEBUG SERVICE: raw data = $data');

    return data != null ? ProfileModel.fromJson(data) : null;
  }

  /// Simpan/update profil (upsert)
  Future<void> saveProfile(ProfileModel profile) async {
    await upsert(profile.toJson());
  }

  /// Simpan data onboarding baru
  Future<void> submitOnboarding({
    required String userId,
    required String nama,
    required String role,
    required String phoneNumber,
    String? farmName,
    String? farmLocation,
    String? animalTypes,
    String? preferences,
    String? description,
  }) async {
    await upsert({
      'id': userId,
      'full_name': nama,
      'role': role,
      'phone_number': phoneNumber,
      'farm_name': role == 'peternak' ? farmName : null,
      'farm_location': role == 'peternak' ? farmLocation : null,
      'animal_types': role == 'peternak' ? animalTypes : null,
      'preferences': role == 'pembeli' ? preferences : null,
      'description': description,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Update data profil secara keseluruhan
  Future<void> updateProfileData({
    required String userId,
    required String fullName,
    String? phoneNumber,
    String? farmName,
    String? farmLocation,
    String? description,
    String? preferences,
  }) async {
    final Map<String, dynamic> data = {
      'id': userId,
      'full_name': fullName,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (farmName != null) data['farm_name'] = farmName;
    if (farmLocation != null) data['farm_location'] = farmLocation;
    if (description != null) data['description'] = description;
    if (preferences != null) data['preferences'] = preferences;

    await upsert(data);
  }

  /// Soft delete profile (menandai akun sebagai terhapus)
  Future<void> softDeleteProfile(String userId) async {
    await client
        .from(tableName)
        .update({
          'is_deleted': true,
          'deleted_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  /// Upload gambar profile ke Supabase Storage
  Future<String> uploadAvatar(
    String userId,
    Object fileBytes,
    String extension,
  ) async {
    // Note: Assuming fileBytes is Uint8List for cross-platform compatibility
    final filePath = '$userId/avatar.$extension';

    // Upload ke bucket "avatars"
    await client.storage
        .from('avatars')
        .uploadBinary(
          filePath,
          fileBytes as dynamic,
          fileOptions: const FileOptions(upsert: true),
        );

    // Dapatkan public URL
    return client.storage.from('avatars').getPublicUrl(filePath);
  }
}
