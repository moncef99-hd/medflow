import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/queue_ticket.dart';

class QueueProgress extends StatelessWidget {
  final QueueStatus status;

  const QueueProgress({super.key, required this.status});

  static const List<String> _steps = [
    'En attente',
    'Appelé',
    'Consultation',
    'Terminé',
  ];

  static const List<IconData> _icons = [
    Icons.hourglass_top_rounded,
    Icons.notifications_active_outlined,
    Icons.medical_services_outlined,
    Icons.check_rounded,
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progression du passage',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Suivez chaque étape de votre visite',
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: List.generate(_steps.length, (index) {
              final isCompleted = index <= _currentStep;
              final isCurrent = index == _currentStep;
              final isLast = index == _steps.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.primary
                            : theme.scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.primary
                              : theme.dividerColor,
                          width: isCurrent ? 2 : 1,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.22,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check_rounded : _icons[index],
                        size: 17,
                        color: isCompleted
                            ? Colors.white
                            : theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index < _currentStep
                              ? AppColors.primary
                              : theme.dividerColor.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_steps.length, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == _steps.length - 1 ? 0 : 3,
                  ),
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
                          : theme.textTheme.bodySmall?.color,
                      fontSize: 9,
                      fontWeight: index == _currentStep
                          ? FontWeight.w800
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.055),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 17,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    _currentMessage,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _currentMessage {
    switch (status) {
      case QueueStatus.waiting:
        return 'Votre ticket est enregistré. Veuillez patienter.';
      case QueueStatus.called:
        return 'C’est votre tour ! Préparez-vous à entrer.';
      case QueueStatus.inConsultation:
        return 'Votre consultation est actuellement en cours.';
      case QueueStatus.completed:
        return 'Votre consultation est terminée. Merci !';
    }
  }
}
