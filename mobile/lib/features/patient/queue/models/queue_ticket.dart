import '../../appointments/models/appointment.dart';

enum QueueStatus {
  waiting,
  called,
  inConsultation,
  completed,
}

class QueueTicket {
  final String id;
  final String ticketNumber;
  final Appointment appointment;
  final int position;
  final int estimatedWaitMinutes;
  final QueueStatus status;

  const QueueTicket({
    required this.id,
    required this.ticketNumber,
    required this.appointment,
    required this.position,
    required this.estimatedWaitMinutes,
    required this.status,
  });
}
