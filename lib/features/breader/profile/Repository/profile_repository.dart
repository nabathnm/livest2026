import 'package:livest/core/data/models/profile_model.dart';
import 'package:livest/features/auth/services/profile_service.dart';

/// Repository untuk operasi profil Peternak.
class BreaderProfileRepository {
  final ProfileService _service;
  BreaderProfileRepository(this._service);

  Future<ProfileModel?> fetchProfile(String userId) async {
    return _service.fetchByUserId(userId);
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    String? phoneNumber,
    String? farmName,
    String? farmLocation,
    String? description,
  }) async {
    return _service.updateProfileData(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      farmName: farmName,
      farmLocation: farmLocation,
      description: description,
    );
  }
}

