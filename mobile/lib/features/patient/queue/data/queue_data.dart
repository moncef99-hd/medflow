import 'package:flutter/material.dart';

import '../../appointments/data/appointments_data.dart';
import '../../appointments/models/appointment.dart';
import '../models/queue_ticket.dart';

class QueueStore extends ChangeNotifier {
  QueueStore._() : _tickets = _createDemoTickets();

  static final QueueStore instance = QueueStore._();

  final List<QueueTicket> _tickets;

  static List<QueueTicket> _createDemoTickets() {
    final confirmedAppointments = AppointmentsStore.instance.appointments
        .where((appointment) =>
            appointment.status == AppointmentStatus.confirmed)
        .toList();

    return List.generate(confirmedAppointments.length, (index) {
      return QueueTicket(
        id: 'Q${index + 1}',
        ticketNumber: 'A${24 + index}',
        appointment: confirmedAppointments[index],
        position: index + 1,
        estimatedWaitMinutes: (index + 1) * 10,
        status: QueueStatus.waiting,
      );
    });
  }

  List<QueueTicket> get tickets => List.unmodifiable(_tickets);

  QueueTicket? getTicketForAppointment(String appointmentId) {
    for (final ticket in _tickets) {
      if (ticket.appointment.id == appointmentId) {
        return ticket;
      }
    }
    return null;
  }

  void updateStatus(String ticketId, QueueStatus newStatus) {
    final index = _tickets.indexWhere((ticket) => ticket.id == ticketId);

    if (index == -1) return;

    final oldTicket = _tickets[index];

    _tickets[index] = QueueTicket(
      id: oldTicket.id,
      ticketNumber: oldTicket.ticketNumber,
      appointment: oldTicket.appointment,
      position: oldTicket.position,
      estimatedWaitMinutes: oldTicket.estimatedWaitMinutes,
      status: newStatus,
    );

    notifyListeners();
  }
}
