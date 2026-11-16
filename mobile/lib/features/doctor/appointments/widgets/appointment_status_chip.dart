import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/doctor_appointment.dart';

class AppointmentStatusChip extends StatelessWidget {
  final DoctorAppointmentStatus status;

  const AppointmentStatusChip({
    super.key,
    required this.status,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}