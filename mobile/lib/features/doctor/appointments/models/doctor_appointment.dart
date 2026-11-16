enum DoctorAppointmentStatus { pending, confirmed, completed, cancelled }

class DoctorAppointment {
  final String id;
  final String patientName;
  final String patientPhone;
  final DateTime dateTime;
  final String reason;
  final DoctorAppointmentStatus status;
  final String? notes;

  const DoctorAppointment({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.dateTime,
    required this.reason,
    required this.status,
    this.notes,
  });

  DoctorAppointment copyWith({
    String? patientName,
    String? patientPhone,
    DateTime? dateTime,
    String? reason,
    DoctorAppointmentStatus? status,
    String? notes,
  }) {
    return DoctorAppointment(
      id: id,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      dateTime: dateTime ?? this.dateTime,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
