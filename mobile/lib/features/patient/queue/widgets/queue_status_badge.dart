import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/queue_ticket.dart';

class QueueStatusBadge extends StatelessWidget {
  final QueueStatus status;

  const QueueStatusBadge({
    super.key,
    required this.status,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
