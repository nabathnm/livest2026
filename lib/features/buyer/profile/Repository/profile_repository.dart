import 'package:livest/core/data/models/profile_model.dart';
import 'package:livest/features/auth/services/profile_service.dart';
class BuyerProfileRepository {
  final ProfileService _service;
  BuyerProfileRepository(this._service);

  Future<ProfileModel?> fetchProfile(String userId) async {
    return _service.fetchByUserId(userId);
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    String? phoneNumber,
    String? preferences,
  }) async {
    return _service.updateProfileData(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      preferences: preferences,
    );
  }
}

