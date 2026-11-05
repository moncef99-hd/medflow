import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/queue_ticket.dart';

class QueueProgress extends StatelessWidget {
  final QueueStatus status;

  const QueueProgress({
    super.key,
    required this.status,
  });

  static const List<String> _steps = [
    'En attente',
    'Appelé',
    'Consultation',
    'Terminé',
  ];

  int get _currentStep {
    switch (status) {
      case QueueStatus.waiting:
        return 0;
      case QueueStatus.called:
        return 1;
      case QueueStatus.inConsultation:
        return 2;
      case QueueStatus.completed:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progression de votre passage',
            style: TextStyle(
              color: AppColors.lightText,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: List.generate(_steps.length, (index) {
              final isCompleted = index <= _currentStep;
              final isLast = index == _steps.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? AppColors.primary
                            : AppColors.lightBg,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.lightBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle_outlined,
                        size: 15,
                        color: isCompleted
                            ? Colors.white
                            : AppColors.lightMuted,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < _currentStep
                              ? AppColors.primary
                              : AppColors.lightBorder,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_steps.length, (index) {
              return Expanded(
                child: Text(
                  _steps[index],
                  textAlign: index == 0
                      ? TextAlign.left
                      : index == _steps.length - 1
                          ? TextAlign.right
                          : TextAlign.center,
                  style: TextStyle(
                    color: index <= _currentStep
                        ? AppColors.primary
                        : AppColors.lightMuted,
                    fontSize: 10,
                    fontWeight: index == _currentStep
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
