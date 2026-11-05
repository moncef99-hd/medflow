
import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../../doctor_profile/data/doctors_data.dart';

class AppointmentsStore extends ChangeNotifier {
  AppointmentsStore._();

  static final AppointmentsStore instance = AppointmentsStore._();

  final List<Appointment> _appointments = [
    Appointment(
      id: 'A001',
      doctor: demoDoctors[0],
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 2)),
      reason: 'Consultation de suivi',
      status: AppointmentStatus.confirmed,
      familyMemberId: 'F001',
    ),
    Appointment(
      id: 'A002',
      doctor: demoDoctors[1],
      dateTime: DateTime.now().add(const Duration(days: 4, hours: 3)),
      reason: 'Consultation dermatologique',
      status: AppointmentStatus.pending,
      familyMemberId: 'F002',
    ),
    Appointment(
      id: 'A003',
      doctor: demoDoctors[2],
      dateTime: DateTime.now().add(const Duration(days: 7, hours: 1)),
      reason: 'Consultation pediatrique',
      status: AppointmentStatus.confirmed,
      familyMemberId: 'F002',
    ),
    Appointment(
      id: 'A004',
      doctor: demoDoctors[3],
      dateTime: DateTime.now().subtract(const Duration(days: 5)),
      reason: 'Consultation de suivi',
      status: AppointmentStatus.completed,
      familyMemberId: 'F001',
    ),
    Appointment(
      id: 'A005',
      doctor: demoDoctors[0],
      dateTime: DateTime.now().subtract(const Duration(days: 12)),
      reason: 'Bilan cardiovasculaire',
      status: AppointmentStatus.cancelled,
    ),
  ];

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  List<Appointment> appointmentsForFamilyMember(String memberId) {
    return _appointments
        .where((appointment) => appointment.familyMemberId == memberId)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }
}
