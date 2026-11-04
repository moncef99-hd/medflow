class Doctor {
  final String id;
  final String fullName;
  final String specialty;
  final String? imageUrl;

  final String bio;
  final int experienceYears;

  final double rating;
  final int reviewCount;

  final String clinicName;
  final String address;
  final String city;
  final String phone;

  final double consultationFee;
  final String workingHours;

  final List<String> availableDays;
  final List<String> languages;
  final List<String> services;
  final List<DoctorReview> reviews;

  const Doctor({
    required this.id,
    required this.fullName,
    required this.specialty,
    this.imageUrl,
    required this.bio,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.clinicName,
    required this.address,
    required this.city,
    required this.phone,
    required this.consultationFee,
    required this.workingHours,
    required this.availableDays,
    required this.languages,
    required this.services,
    required this.reviews,
  });
}

class DoctorReview {
  final String patientName;
  final double rating;
  final String comment;
  final String date;

  const DoctorReview({
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
