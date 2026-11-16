import '../../doctor_profile/models/doctor.dart';

enum AppointmentStatus { pending, confirmed, completed, cancelled }

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime dateTime;
  final String reason;
  final AppointmentStatus status;
  final String? familyMemberId;

  const Appointment({
    required this.id,
    required this.doctor,
    required this.dateTime,
    required this.reason,
    required this.status,
    this.familyMemberId,
  });

  Appointment copyWith({
    DateTime? dateTime,
    String? reason,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id,
      doctor: doctor,
      dateTime: dateTime ?? this.dateTime,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      familyMemberId: familyMemberId,
    );
  }
}
