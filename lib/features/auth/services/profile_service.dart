import 'package:livest/core/data/models/profile_model.dart';
import 'package:livest/core/services/base_supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class ProfileService extends BaseSupabaseService<ProfileModel> {
  @override
  String get tableName => 'profiles';

  @override
  ProfileModel fromJson(Map<String, dynamic> json) {
    return ProfileModel.fromJson(json);
  }
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
  Future<void> saveProfile(ProfileModel profile) async {
    await upsert(profile.toJson());
  }
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
  Future<void> updateProfileData({
    required String userId,
    required String fullName,
    String? phoneNumber,
    String? farmName,
    String? farmLocation,
    String? description,
    String? preferences,
    String? email,
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
    if (email != null) data['email'] = email;

    await upsert(data);
  }
  Future<void> softDeleteProfile(String userId) async {
    await client
        .from(tableName)
        .update({
          'is_deleted': true,
          'deleted_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }
  Future<String> uploadAvatar(
    String userId,
    Object fileBytes,
    String extension,
  ) async {
    final filePath = '$userId/avatar.$extension';
    await client.storage
        .from('avatar')
        .uploadBinary(
          filePath,
          fileBytes as dynamic,
          fileOptions: const FileOptions(upsert: true),
        );  
    return client.storage.from('avatar').getPublicUrl(filePath);
  }
}
