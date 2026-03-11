import 'package:flutter/material.dart';
import 'package:livest/core/config/supabase_config.dart';
import 'package:livest/core/data/models/profile_model.dart';
import 'package:livest/features/auth/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get fullName => _profile?.fullName;
  String? get role => _profile?.role;
  String? get phoneNumber => _profile?.phoneNumber;
  String? get farmName => _profile?.farmName;
  String? get farmLocation => _profile?.farmLocation;
  String? get animalTypes => _profile?.animalTypes;
  String? get preferences => _profile?.preferences;
  String? get description => _profile?.description;
  String? get avatarUrl => _profile?.avatarUrl;

  String? get email => SupabaseConfig.client.auth.currentUser?.email;

  Map<String, dynamic>? get profileData {
    final data = _profile?.toJson();
    if (data != null) {
      data['email'] = email;
    }
    return data;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Fetch profil user dari Supabase via ProfileService
  Future<void> fetchProfile() async {
    final user = SupabaseConfig.client.auth.currentUser;
    if (user == null) return;

    _setLoading(true);
    try {
      _profile = await _profileService.fetchByUserId(user.id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  /// Submit data onboarding via ProfileService
  Future<bool> submitOnboardingData({
    required String nama,
    required String role,
    required String phoneNumber,
    String? farmName,
    String? farmLocation,
    String? animalTypes,
    String? preferences,
    String? description,
  }) async {
    _setLoading(true);
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) throw Exception("Sesi hilang. Silakan login ulang.");

      await _profileService.submitOnboarding(
        userId: user.id,
        nama: nama,
        role: role,
        phoneNumber: phoneNumber,
        farmName: farmName,
        farmLocation: farmLocation,
        animalTypes: animalTypes,
        preferences: preferences,
        description: description,
      );

      // Refresh dari server untuk data terbaru
      _profile = await _profileService.fetchByUserId(user.id);

      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Update profil via ProfileService
  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phoneNumber,
    String? farmName,
    String? farmLocation,
    String? description,
    String? preferences,
  }) async {
    _setLoading(true);
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) throw Exception("Sesi hilang.");

      await _profileService.updateProfileData(
        userId: user.id,
        fullName: name,
        phoneNumber: phoneNumber,
        farmName: farmName,
        farmLocation: farmLocation,
        description: description,
        preferences: preferences,
      );

      // Refresh profile dari server
      _profile = await _profileService.fetchByUserId(user.id);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Soft Delete Akun (update profil ke status terhapus, tanpa hapus user di Auth Supabase)
  Future<bool> softDeleteAccount() async {
    _setLoading(true);
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) throw Exception("Sesi hilang.");

      await _profileService.softDeleteProfile(user.id);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Upload/Update Foto Profil
  Future<bool> uploadProfilePicture(dynamic fileBytes, String extension) async {
    _setLoading(true);
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      if (user == null) throw Exception("Sesi hilang.");
      
      // Upload ke storage
      final avatarUrl = await _profileService.uploadAvatar(user.id, fileBytes, extension);
      
      // Simpan URL ke database profiles
      await _profileService.upsert({
        'id': user.id,
        'avatar_url': avatarUrl,
      });
      
      // Refresh profile data untuk merefleksikan perubahan UI
      await fetchProfile();
      
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }
  /// Reset profile data (saat logout)
  void clearProfile() {
    _profile = null;
    _errorMessage = null;
    notifyListeners();
  }
}
