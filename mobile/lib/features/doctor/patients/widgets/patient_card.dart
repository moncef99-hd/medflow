import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../models/doctor_patient.dart';

class PatientCard extends StatelessWidget {
  final DoctorPatient patient;
  final VoidCallback onTap;

  const PatientCard({super.key, required this.patient, required this.onTap});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Aucune consultation';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Color _alertColor() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.critical:
        return AppColors.danger;
      case MedicalAlertLevel.warning:
        return AppColors.warning;
      case MedicalAlertLevel.information:
        return AppColors.primary;
      case MedicalAlertLevel.none:
        return AppColors.success;
    }
  }

  String _statusLabel() {
    switch (patient.status) {
      case PatientFollowUpStatus.newPatient:
        return 'Nouveau';
      case PatientFollowUpStatus.followed:
        return 'Suivi';
      case PatientFollowUpStatus.inactive:
        return 'Inactif';
    }
  }

  Color _statusColor() {
    switch (patient.status) {
      case PatientFollowUpStatus.newPatient:
        return AppColors.primary;
      case PatientFollowUpStatus.followed:
        return AppColors.success;
      case PatientFollowUpStatus.inactive:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final mutedColor = theme.colorScheme.onSurfaceVariant;

    return Card(
      color: theme.colorScheme.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.35)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppAvatar(
                    name: patient.fullName,
                    imageUrl: patient.imageUrl,
                    size: 54,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${patient.id}  •  ${patient.age} ans  •  ${patient.gender}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                    size: 25,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _InfoItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Dernière consultation',
                    value: _formatDate(patient.lastConsultationAt),
                  ),
                  if (patient.bloodGroup != null) ...[
                    const SizedBox(width: 12),
                    _InfoItem(
                      icon: Icons.bloodtype_outlined,
                      label: 'Groupe sanguin',
                      value: patient.bloodGroup!,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Tag(label: _statusLabel(), color: _statusColor()),
                  if (patient.hasAllergies)
                    const _Tag(
                      label: 'Allergie',
                      color: AppColors.warning,
                      icon: Icons.warning_amber_rounded,
                    ),
                  if (patient.hasMedicalAlert)
                    _Tag(
                      label: 'Alerte médicale',
                      color: _alertColor(),
                      icon: Icons.notifications_active_outlined,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _Tag({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
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
