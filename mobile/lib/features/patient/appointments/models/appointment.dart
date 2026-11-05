
import '../../doctor_profile/models/doctor.dart';

enum AppointmentStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime dateTime;
  final String reason;
  final AppointmentStatus status;

  // Null means the appointment belongs to the main patient.
  final String? familyMemberId;

  const Appointment({
    required this.id,
    required this.doctor,
    required this.dateTime,
    required this.reason,
    required this.status,
    this.familyMemberId,
  });
}
