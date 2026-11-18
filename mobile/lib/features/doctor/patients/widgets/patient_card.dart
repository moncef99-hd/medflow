import 'package:flutter/material.dart';

import '../models/doctor_patient.dart';
import 'status_badge.dart';

class PatientCard extends StatelessWidget {
  final DoctorPatient patient;
  final VoidCallback onTap;

  const PatientCard({super.key, required this.patient, required this.onTap});

  static const Color _blue = Color(0xFF2563EB);

  String _formatDate(DateTime? date) {
    if (date == null) return 'Aucune consultation';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _initials() {
    final parts = patient.fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _statusColor() {
    switch (patient.status) {
      case PatientFollowUpStatus.newPatient:
        return _blue;
      case PatientFollowUpStatus.followed:
        return const Color(0xFF10B981);
      case PatientFollowUpStatus.inactive:
        return const Color(0xFFF59E0B);
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

  Color _alertColor() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.critical:
        return const Color(0xFFEF4444);
      case MedicalAlertLevel.warning:
        return const Color(0xFFF59E0B);
      case MedicalAlertLevel.information:
        return _blue;
      case MedicalAlertLevel.none:
        return const Color(0xFF10B981);
    }
  }

  IconData _alertIcon() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.critical:
        return Icons.priority_high_rounded;
      case MedicalAlertLevel.warning:
        return Icons.warning_amber_rounded;
      case MedicalAlertLevel.information:
        return Icons.info_outline_rounded;
      case MedicalAlertLevel.none:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: statusColor),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPatientHeader(theme, statusColor),
                          const SizedBox(height: 17),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoTile(
                                  theme,
                                  icon: Icons.calendar_month_rounded,
                                  label: 'Dernière consultation',
                                  value: _formatDate(
                                    patient.lastConsultationAt,
                                  ),
                                  color: _blue,
                                ),
                              ),
                              if (patient.bloodGroup != null) ...[
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildInfoTile(
                                    theme,
                                    icon: Icons.bloodtype_rounded,
                                    label: 'Groupe sanguin',
                                    value: patient.bloodGroup!,
                                    color: const Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildBadges(),
                          if (patient.hasMedicalAlert &&
                              patient.alertMessage != null &&
                              patient.alertMessage!.trim().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _buildAlertPreview(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientHeader(ThemeData theme, Color statusColor) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${patient.id}  •  ${patient.age} ans  •  ${patient.gender}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Icon(
          Icons.chevron_right_rounded,
          color: theme.colorScheme.onSurfaceVariant,
          size: 23,
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (patient.imageUrl != null && patient.imageUrl!.trim().isNotEmpty) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _blue.withValues(alpha: 0.20), width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            patient.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildInitialAvatar(),
          ),
        ),
      );
    }

    return _buildInitialAvatar();
  }

  Widget _buildInitialAvatar() {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.055),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadges() {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        StatusBadge(
          label: _statusLabel(),
          color: _statusColor(),
          icon: patient.status == PatientFollowUpStatus.newPatient
              ? Icons.person_add_alt_1_rounded
              : patient.status == PatientFollowUpStatus.followed
              ? Icons.check_circle_outline_rounded
              : Icons.schedule_rounded,
          compact: true,
        ),
        if (patient.hasAllergies)
          const StatusBadge(
            label: 'Allergie',
            color: Color(0xFFF59E0B),
            icon: Icons.warning_amber_rounded,
            compact: true,
          ),
        if (patient.hasMedicalAlert)
          StatusBadge(
            label: 'Alerte médicale',
            color: _alertColor(),
            icon: _alertIcon(),
            compact: true,
          ),
      ],
    );
  }

  Widget _buildAlertPreview() {
    final color = _alertColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_alertIcon(), color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              patient.alertMessage!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
