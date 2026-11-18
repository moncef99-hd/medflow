class DoctorProfile {
  final String specialty;
  final int experienceYears;
  final String licenseNumber;
  final String education;
  final String bio;
  final String clinicName;
  final String clinicAddress;
  final String clinicPhone;
  final double consultationFee;
  final List<String> services;
  final List<String> languages;
  final String availability;
  final String? photoPath;

  const DoctorProfile({
    this.specialty = '',
    this.experienceYears = 0,
    this.licenseNumber = '',
    this.education = '',
    this.bio = '',
    this.clinicName = '',
    this.clinicAddress = '',
    this.clinicPhone = '',
    this.consultationFee = 0,
    this.services = const [],
    this.languages = const ['Français', 'Arabe'],
    this.availability = '',
    this.photoPath,
  });

  DoctorProfile copyWith({
    String? specialty,
    int? experienceYears,
    String? licenseNumber,
    String? education,
    String? bio,
    String? clinicName,
    String? clinicAddress,
    String? clinicPhone,
    double? consultationFee,
    List<String>? services,
    List<String>? languages,
    String? availability,
    String? photoPath,
  }) {
    return DoctorProfile(
      specialty: specialty ?? this.specialty,
      experienceYears: experienceYears ?? this.experienceYears,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      education: education ?? this.education,
      bio: bio ?? this.bio,
      clinicName: clinicName ?? this.clinicName,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      clinicPhone: clinicPhone ?? this.clinicPhone,
      consultationFee: consultationFee ?? this.consultationFee,
      services: services ?? this.services,
      languages: languages ?? this.languages,
      availability: availability ?? this.availability,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toJson() => {
    'specialty': specialty,
    'experienceYears': experienceYears,
    'licenseNumber': licenseNumber,
    'education': education,
    'bio': bio,
    'clinicName': clinicName,
    'clinicAddress': clinicAddress,
    'clinicPhone': clinicPhone,
    'consultationFee': consultationFee,
    'services': services,
    'languages': languages,
    'availability': availability,
    'photoPath': photoPath,
  };

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      specialty: json['specialty'] as String? ?? '',
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      licenseNumber: json['licenseNumber'] as String? ?? '',
      education: json['education'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      clinicName: json['clinicName'] as String? ?? '',
      clinicAddress: json['clinicAddress'] as String? ?? '',
      clinicPhone: json['clinicPhone'] as String? ?? '',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0,
      services:
          (json['services'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const ['Français', 'Arabe'],
      availability: json['availability'] as String? ?? '',
      photoPath: json['photoPath'] as String?,
    );
  }
}
