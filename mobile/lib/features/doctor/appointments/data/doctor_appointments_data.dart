import 'package:flutter/foundation.dart';

import '../models/doctor_appointment.dart';

class DoctorAppointmentsStore extends ChangeNotifier {
  DoctorAppointmentsStore._();

  static final DoctorAppointmentsStore instance =
      DoctorAppointmentsStore._();

  final List<DoctorAppointment> _appointments = [
    DoctorAppointment(
      id: 'D001',
      patientName: 'Ahmed Ben Ali',
      patientPhone: '22 123 456',
      dateTime: DateTime.now().add(const Duration(hours: 1)),
      reason: 'Consultation générale',
      status: DoctorAppointmentStatus.pending,
    ),
    DoctorAppointment(
      id: 'D002',
      patientName: 'Sarra Trabelsi',
      patientPhone: '55 234 567',
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      reason: 'Douleurs abdominales',
      status: DoctorAppointmentStatus.confirmed,
    ),
    DoctorAppointment(
      id: 'D003',
      patientName: 'Youssef Mansouri',
      patientPhone: '98 345 678',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      reason: 'Suivi médical',
      status: DoctorAppointmentStatus.pending,
    ),
    DoctorAppointment(
      id: 'D004',
      patientName: 'Mariem Gharbi',
      patientPhone: '21 456 789',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      reason: 'Contrôle de routine',
      status: DoctorAppointmentStatus.completed,
    ),
    DoctorAppointment(
      id: 'D005',
      patientName: 'Karim Saidi',
      patientPhone: '27 567 890',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      reason: 'Consultation dermatologique',
      status: DoctorAppointmentStatus.cancelled,
    ),
  ];

  List<DoctorAppointment> get appointments =>
      List.unmodifiable(_appointments);

  void updateAppointment(DoctorAppointment updatedAppointment) {
    final index = _appointments.indexWhere(
      (appointment) => appointment.id == updatedAppointment.id,
    );

    if (index == -1) return;

    _appointments[index] = updatedAppointment;
    notifyListeners();
  }
}