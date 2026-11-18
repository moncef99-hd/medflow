enum DoctorConsultationStatus { inProgress, completed }

class DoctorConsultation {
  final String id;
  final String appointmentId;
  final String patientName;
  final String patientPhone;
  final DateTime dateTime;
  final String reason;
  final String observations;
  final String report;
  final String recommendations;
  final DoctorConsultationStatus status;

  const DoctorConsultation({
    required this.id,
    required this.appointmentId,
    required this.patientName,
    required this.patientPhone,
    required this.dateTime,
    required this.reason,
    this.observations = '',
    this.report = '',
    this.recommendations = '',
    this.status = DoctorConsultationStatus.inProgress,
  });

  DoctorConsultation copyWith({
    String? reason,
    String? observations,
    String? report,
    String? recommendations,
    DoctorConsultationStatus? status,
  }) {
    return DoctorConsultation(
      id: id,
      appointmentId: appointmentId,
      patientName: patientName,
      patientPhone: patientPhone,
      dateTime: dateTime,
      reason: reason ?? this.reason,
      observations: observations ?? this.observations,
      report: report ?? this.report,
      recommendations: recommendations ?? this.recommendations,
      status: status ?? this.status,
    );
  }
}
