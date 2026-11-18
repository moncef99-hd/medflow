import 'package:flutter/foundation.dart';

import '../../appointments/data/doctor_appointments_data.dart';
import '../../appointments/models/doctor_appointment.dart';
import '../models/doctor_consultation.dart';

class DoctorConsultationsStore extends ChangeNotifier {
  DoctorConsultationsStore._();

  static final DoctorConsultationsStore instance = DoctorConsultationsStore._();

  final List<DoctorConsultation> _consultations = [];

  List<DoctorConsultation> get consultations =>
      List.unmodifiable(_consultations);

  List<DoctorConsultation> get inProgressConsultations => _consultations
      .where((item) => item.status == DoctorConsultationStatus.inProgress)
      .toList();

  List<DoctorConsultation> get completedConsultations => _consultations
      .where((item) => item.status == DoctorConsultationStatus.completed)
      .toList();

  bool hasConsultationFor(String appointmentId) {
    return _consultations.any(
      (item) =>
          item.appointmentId == appointmentId &&
          item.status == DoctorConsultationStatus.inProgress,
    );
  }

  List<DoctorAppointment> get availableAppointments {
    return DoctorAppointmentsStore.instance.appointments
        .where(
          (appointment) =>
              appointment.status == DoctorAppointmentStatus.confirmed &&
              !hasConsultationFor(appointment.id),
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  DoctorConsultation? startConsultation(DoctorAppointment appointment) {
    if (hasConsultationFor(appointment.id)) return null;

    final consultation = DoctorConsultation(
      id: 'C${DateTime.now().microsecondsSinceEpoch}',
      appointmentId: appointment.id,
      patientName: appointment.patientName,
      patientPhone: appointment.patientPhone,
      dateTime: DateTime.now(),
      reason: appointment.reason,
    );

    _consultations.insert(0, consultation);
    notifyListeners();

    return consultation;
  }

  void updateConsultation(DoctorConsultation updated) {
    final index = _consultations.indexWhere((item) => item.id == updated.id);

    if (index == -1) return;

    _consultations[index] = updated;
    notifyListeners();
  }

  void completeConsultation(DoctorConsultation consultation) {
    updateConsultation(
      consultation.copyWith(status: DoctorConsultationStatus.completed),
    );
  }

  DoctorConsultation? findById(String id) {
    for (final consultation in _consultations) {
      if (consultation.id == id) return consultation;
    }
    return null;
  }
}
