class ProfileModel {
  final String id;
  final String? fullName;
  final String? role; // 'peternak' atau 'pembeli'
  final String? farmName;
  final String? farmLocation;
  final String? animalTypes;
  final String? preferences;
  final String? email;
  final String? phoneNumber;
  final DateTime? updatedAt;

  ProfileModel({
    required this.id,
    this.fullName,
    this.role,
    this.farmName,
    this.farmLocation,
    this.animalTypes,
    this.preferences,
    this.email,
    this.phoneNumber,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'],
      role: json['role'],
      farmName: json['farm_name'],
      farmLocation: json['farm_location'],
      animalTypes: json['animal_types'],
      preferences: json['preferences'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role': role,
      'farm_name': farmName,
      'farm_location': farmLocation,
      'animal_types': animalTypes,
      'preferences': preferences,
      'email': email,
      'phone_number': phoneNumber,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isPeternak => role == 'peternak';
  bool get isPembeli => role == 'pembeli';
  bool get hasCompletedOnboarding => role != null;
}
