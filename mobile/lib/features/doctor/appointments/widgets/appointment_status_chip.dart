import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../models/doctor_appointment.dart';

class AppointmentStatusChip extends StatelessWidget {
  final DoctorAppointmentStatus status;

  const AppointmentStatusChip({super.key, required this.status});

  String get _label {
    switch (status) {
      case DoctorAppointmentStatus.pending:
        return 'En attente';
      case DoctorAppointmentStatus.confirmed:
        return 'Confirmé';
      case DoctorAppointmentStatus.completed:
        return 'Terminé';
      case DoctorAppointmentStatus.cancelled:
        return 'Annulé';
    }
  }

  Color get _color {
    switch (status) {
      case DoctorAppointmentStatus.pending:
        return AppColors.warning;
      case DoctorAppointmentStatus.confirmed:
        return AppColors.success;
      case DoctorAppointmentStatus.completed:
        return AppColors.primary;
      case DoctorAppointmentStatus.cancelled:
        return AppColors.danger;
    }
  }

  IconData get _icon {
    switch (status) {
      case DoctorAppointmentStatus.pending:
        return Icons.schedule_rounded;
      case DoctorAppointmentStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case DoctorAppointmentStatus.completed:
        return Icons.task_alt_rounded;
      case DoctorAppointmentStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusChip(label: _label, color: _color, icon: _icon);
  }
}
