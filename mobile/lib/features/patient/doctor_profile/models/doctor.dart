class Doctor {
  final String id;
  final String fullName;
  final String specialty;
  final String? _imageUrl;

  /// Shared portrait URL used throughout the patient app.
  String? get imageUrl {
    if (_imageUrl != null && _imageUrl.isNotEmpty) {
      return _imageUrl;
    }

    return switch (fullName) {
      'Dr. Sami Ben Ali' =>
        'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=300&h=300&fit=crop&crop=face',
      'Dr. Amira Ben Salem' =>
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&h=300&fit=crop&crop=face',
      'Dr. Youssef Trabelsi' =>
        'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=300&h=300&fit=crop&crop=face',
      'Dr. Mariem Gharbi' =>
        'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=300&h=300&fit=crop&crop=face',
      'Dr. Karim Ben Amor' =>
        'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=300&h=300&fit=crop&crop=face',
      _ => null,
    };
  }

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
    String? imageUrl,
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
  }) : _imageUrl = imageUrl;
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
