import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/queue_ticket.dart';

class QueueStatusBadge extends StatelessWidget {
  final QueueStatus status;

  const QueueStatusBadge({super.key, required this.status});

  String get label {
    switch (status) {
      case QueueStatus.waiting:
        return 'En attente';
      case QueueStatus.called:
        return 'Appelé';
      case QueueStatus.inConsultation:
        return 'En consultation';
      case QueueStatus.completed:
        return 'Terminé';
    }
  }

  Color get color {
    switch (status) {
      case QueueStatus.waiting:
        return AppColors.warning;
      case QueueStatus.called:
        return AppColors.primary;
      case QueueStatus.inConsultation:
        return const Color(0xFF8B5CF6);
      case QueueStatus.completed:
        return AppColors.success;
    }
  }

  IconData get icon {
    switch (status) {
      case QueueStatus.waiting:
        return Icons.hourglass_top_rounded;
      case QueueStatus.called:
        return Icons.notifications_active_outlined;
      case QueueStatus.inConsultation:
        return Icons.medical_services_outlined;
      case QueueStatus.completed:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
