import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../models/doctor_patient.dart';
import '../widgets/alert_banner.dart';
import '../widgets/info_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/status_badge.dart';
import '../widgets/timeline_item.dart';

class PatientDetailsScreen extends StatelessWidget {
  final DoctorPatient patient;

  const PatientDetailsScreen({super.key, required this.patient});

  static const Color _blue = Color(0xFF2563EB);
  static const Color _green = Color(0xFF10B981);
  static const Color _orange = Color(0xFFF59E0B);
  static const Color _red = Color(0xFFEF4444);
  static const Color _purple = Color(0xFF8B5CF6);

  String _formatDate(DateTime? date) {
    if (date == null) return 'Non renseignée';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _statusLabel() {
    switch (patient.status) {
      case PatientFollowUpStatus.newPatient:
        return 'Nouveau patient';
      case PatientFollowUpStatus.followed:
        return 'Patient suivi';
      case PatientFollowUpStatus.inactive:
        return 'Patient inactif';
    }
  }

  Color _statusColor() {
    switch (patient.status) {
      case PatientFollowUpStatus.newPatient:
        return _blue;
      case PatientFollowUpStatus.followed:
        return _green;
      case PatientFollowUpStatus.inactive:
        return Colors.grey;
    }
  }

  Color _alertColor() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.none:
        return _green;
      case MedicalAlertLevel.information:
        return _blue;
      case MedicalAlertLevel.warning:
        return _orange;
      case MedicalAlertLevel.critical:
        return _red;
    }
  }

  String _alertLabel() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.none:
        return 'Aucune alerte';
      case MedicalAlertLevel.information:
        return 'Information médicale';
      case MedicalAlertLevel.warning:
        return 'Attention médicale';
      case MedicalAlertLevel.critical:
        return 'Alerte importante';
    }
  }

  IconData _alertIcon() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.none:
        return Icons.verified_user_outlined;
      case MedicalAlertLevel.information:
        return Icons.info_outline_rounded;
      case MedicalAlertLevel.warning:
        return Icons.warning_amber_rounded;
      case MedicalAlertLevel.critical:
        return Icons.health_and_safety_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dossier patient',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildDemoNotice(),
            const SizedBox(height: 16),
            _buildAlertSection(),
            const SizedBox(height: 24),
            _buildPersonalInfo(),
            const SizedBox(height: 20),
            _buildMedicalInfo(context),
            const SizedBox(height: 20),
            _buildFollowUp(),
            const SizedBox(height: 20),
            _buildConsultationHistory(context),
            const SizedBox(height: 20),
            _buildDocuments(context),
          ],
        ),
      ),
    );
  }

  // En-tête du dossier patient
  Widget _buildProfileHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: Stack(
          children: [
            Positioned(top: -45, right: -35, child: _decorationCircle(150)),
            Positioned(bottom: -65, left: -35, child: _decorationCircle(145)),
            Positioned(
              right: 18,
              bottom: 15,
              child: Icon(
                Icons.medical_services_outlined,
                size: 100,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AppAvatar(
                    name: patient.fullName,
                    imageUrl: patient.imageUrl,
                    size: 82,
                    borderColor: Colors.white,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    patient.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Référence : ${patient.id}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  StatusBadge(
                    label: _statusLabel(),
                    color: Colors.white,
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _headerInfo(
                          Icons.cake_outlined,
                          '${patient.age} ans',
                          'Âge',
                        ),
                      ),
                      _headerDivider(),
                      Expanded(
                        child: _headerInfo(
                          Icons.person_outline_rounded,
                          patient.gender,
                          'Genre',
                        ),
                      ),
                      _headerDivider(),
                      Expanded(
                        child: _headerInfo(
                          Icons.bloodtype_outlined,
                          patient.bloodGroup ?? 'Non renseigné',
                          'Groupe sanguin',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorationCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.07),
      ),
    );
  }

  Widget _headerDivider() {
    return Container(
      height: 38,
      width: 1,
      color: Colors.white.withValues(alpha: 0.25),
    );
  }

  Widget _headerInfo(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 19),
          const SizedBox(height: 7),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // Informations de démonstration
  Widget _buildDemoNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _blue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _blue.withValues(alpha: 0.16)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: _blue, size: 21),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Données de démonstration : les informations affichées '
              'sont fictives et servent uniquement à présenter '
              'l’interface MedFlow.',
              style: TextStyle(
                color: _blue,
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Alerte médicale
  Widget _buildAlertSection() {
    final message =
        patient.alertMessage ??
        (patient.hasAllergies
            ? 'Des allergies sont renseignées dans le dossier.'
            : 'Aucune remarque enregistrée.');

    return AlertBanner(
      title: _alertLabel(),
      message: message,
      color: _alertColor(),
      icon: _alertIcon(),
    );
  }

  // Informations personnelles
  Widget _buildPersonalInfo() {
    return SectionCard(
      title: 'Informations personnelles',
      icon: Icons.person_outline_rounded,
      color: _blue,
      child: Column(
        children: [
          InfoTile(
            label: 'Date de naissance',
            value: _formatDate(patient.dateOfBirth),
            icon: Icons.cake_outlined,
            color: _blue,
          ),
          InfoTile(
            label: 'Téléphone',
            value: patient.phone,
            icon: Icons.phone_outlined,
            color: _blue,
          ),
          InfoTile(
            label: 'Adresse e-mail',
            value: patient.email ?? 'Non renseigné',
            icon: Icons.email_outlined,
            color: _blue,
          ),
          InfoTile(
            label: 'Adresse',
            value: patient.address ?? 'Non renseignée',
            icon: Icons.location_on_outlined,
            color: _blue,
          ),
        ],
      ),
    );
  }

  // Informations médicales
  Widget _buildMedicalInfo(BuildContext context) {
    return SectionCard(
      title: 'Informations médicales',
      icon: Icons.medical_information_outlined,
      color: _red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBloodGroupCard(),
          const SizedBox(height: 16),
          _buildMedicalTagList(
            context: context,
            title: 'Allergies',
            values: patient.allergies,
            icon: Icons.warning_amber_rounded,
            color: _orange,
            emptyText: 'Aucune allergie renseignée.',
          ),
          const SizedBox(height: 18),
          _buildMedicalTagList(
            context: context,
            title: 'Antécédents déclarés',
            values: patient.chronicConditions,
            icon: Icons.medical_services_outlined,
            color: _purple,
            emptyText: 'Aucun antécédent renseigné.',
          ),
        ],
      ),
    );
  }

  Widget _buildBloodGroupCard() {
    final bloodGroup = patient.bloodGroup ?? 'Non renseigné';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _red.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _red.withValues(alpha: 0.17)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.bloodtype_rounded, color: _red, size: 25),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Text(
              'Groupe sanguin',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: _red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              bloodGroup,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalTagList({
    required BuildContext context,
    required String title,
    required List<String> values,
    required IconData icon,
    required Color color,
    required String emptyText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 19),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              '${values.length}',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (values.isEmpty)
          Text(
            emptyText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values.map((value) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.15)),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // Suivi médical
  Widget _buildFollowUp() {
    return SectionCard(
      title: 'Suivi médical',
      icon: Icons.calendar_month_outlined,
      color: _green,
      child: Column(
        children: [
          InfoTile(
            label: 'Prochain rendez-vous',
            value: _formatDate(patient.nextAppointmentAt),
            icon: Icons.event_available_outlined,
            color: _green,
          ),
          InfoTile(
            label: 'Dernière consultation',
            value: _formatDate(patient.lastConsultationAt),
            icon: Icons.history_rounded,
            color: _blue,
          ),
          const SizedBox(height: 8),
          StatusBadge(
            label: _statusLabel(),
            color: _statusColor(),
            icon: Icons.assignment_ind_outlined,
          ),
        ],
      ),
    );
  }

  // Historique des consultations
  Widget _buildConsultationHistory(BuildContext context) {
    final date = patient.lastConsultationAt;

    return SectionCard(
      title: 'Historique des consultations',
      icon: Icons.history_rounded,
      color: _purple,
      child: date == null
          ? _buildEmptyState(
              context: context,
              icon: Icons.history_rounded,
              message: 'Aucune consultation enregistrée.',
              color: _purple,
            )
          : TimelineItem(
              date: _formatDate(date),
              title: 'Consultation enregistrée',
              subtitle: 'Entrée fictive pour la démonstration',
              icon: Icons.medical_services_outlined,
              color: _purple,
              isLast: true,
            ),
    );
  }

  // Documents médicaux
  Widget _buildDocuments(BuildContext context) {
    return SectionCard(
      title: 'Documents médicaux',
      icon: Icons.folder_outlined,
      color: _orange,
      child: _buildEmptyState(
        context: context,
        icon: Icons.folder_open_outlined,
        message: 'Aucun document disponible dans cette démonstration.',
        color: _orange,
      ),
    );
  }

  Widget _buildEmptyState({
    required BuildContext context,
    required IconData icon,
    required String message,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.13)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 11),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
