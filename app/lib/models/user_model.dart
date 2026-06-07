class UserModel {
  final String id;
  final String fullName;
  final String? email;
  final String phoneNumber;
  final bool? isVerified;
  final String? bloodType;
  final String? allergies;
  final String? medicalConditions;
  final String preferredLanguage;
  final String darkMode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    this.email,
    required this.phoneNumber,
    this.isVerified,
    this.bloodType,
    this.allergies,
    this.medicalConditions,
    this.preferredLanguage = 'en',
    this.darkMode = 'light',
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ??
          json['fullName'] as String? ??
          '',
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String? ??
          json['phoneNumber'] as String? ??
          '',
      isVerified: json['is_phone_verified'] as bool? ??
          json['isVerified'] as bool?,
      bloodType: json['blood_group'] as String? ??
          json['bloodType'] as String?,
      allergies: json['allergies'] as String?,
      medicalConditions: json['medical_conditions'] as String? ??
          json['medicalConditions'] as String?,
      preferredLanguage: json['preferred_language'] as String? ??
          json['preferredLanguage'] as String? ??
          'en',
      darkMode: json['dark_mode'] as String? ??
          json['darkMode'] as String? ??
          'light',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'is_phone_verified': isVerified,
      'blood_group': bloodType,
      'allergies': allergies,
      'medical_conditions': medicalConditions,
      'preferred_language': preferredLanguage,
      'dark_mode': darkMode,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Whether the user has completed their essential medical profile.
  /// A fresh user has no blood type set.
  bool get isProfileComplete =>
      bloodType != null && bloodType!.isNotEmpty;

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? isVerified,
    String? bloodType,
    String? allergies,
    String? medicalConditions,
    String? preferredLanguage,
    String? darkMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      darkMode: darkMode ?? this.darkMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
