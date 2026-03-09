import 'package:livest/core/data/models/profile_model.dart';
import 'package:livest/core/services/base_supabase_service.dart';

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
    return await fetchById(userId);
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
  }) async {
    final Map<String, dynamic> data = {
      'id': userId,
      'full_name': fullName,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (farmName != null) data['farm_name'] = farmName;
    if (farmLocation != null) data['farm_location'] = farmLocation;

    await upsert(data);
  }
}
