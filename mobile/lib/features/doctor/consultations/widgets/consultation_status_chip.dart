import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/doctor_consultation.dart';

class ConsultationStatusChip extends StatelessWidget {
  final DoctorConsultationStatus status;

  const ConsultationStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == DoctorConsultationStatus.completed;
    final color = isCompleted ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.pending_rounded,
            color: color,
            size: 13,
          ),
          const SizedBox(width: 5),
          Text(
            isCompleted ? 'Terminée' : 'En cours',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
