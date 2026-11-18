enum PatientFollowUpStatus { newPatient, followed, inactive }

enum MedicalAlertLevel { none, information, warning, critical }

class DoctorPatient {
  final String id;
  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String phone;
  final String? email;
  final String? imageUrl;
  final String? address;

  final String? bloodGroup;
  final List<String> allergies;
  final List<String> chronicConditions;

  final DateTime? lastConsultationAt;
  final DateTime? nextAppointmentAt;

  final PatientFollowUpStatus status;
  final MedicalAlertLevel alertLevel;
  final String? alertMessage;

  const DoctorPatient({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.phone,
    this.email,
    this.imageUrl,
    this.address,
    this.bloodGroup,
    this.allergies = const [],
    this.chronicConditions = const [],
    this.lastConsultationAt,
    this.nextAppointmentAt,
    this.status = PatientFollowUpStatus.followed,
    this.alertLevel = MedicalAlertLevel.none,
    this.alertMessage,
  });

  int get age {
    final today = DateTime.now();

    var result = today.year - dateOfBirth.year;

    final birthdayNotReached =
        today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day);

    if (birthdayNotReached) {
      result--;
    }

    return result;
  }

  bool get hasMedicalAlert => alertLevel != MedicalAlertLevel.none;

  bool get hasAllergies => allergies.isNotEmpty;

  bool get hasChronicConditions => chronicConditions.isNotEmpty;
}
