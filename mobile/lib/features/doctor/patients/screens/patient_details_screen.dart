import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../models/doctor_patient.dart';

class PatientDetailsScreen extends StatelessWidget {
  final DoctorPatient patient;

  const PatientDetailsScreen({super.key, required this.patient});

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

  Color _alertColor() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.none:
        return AppColors.success;
      case MedicalAlertLevel.information:
        return AppColors.primary;
      case MedicalAlertLevel.warning:
        return AppColors.warning;
      case MedicalAlertLevel.critical:
        return AppColors.danger;
    }
  }

  String _alertLabel() {
    switch (patient.alertLevel) {
      case MedicalAlertLevel.none:
        return 'Aucune alerte';
      case MedicalAlertLevel.information:
        return 'Information médicale';
      case MedicalAlertLevel.warning:
        return 'Attention';
      case MedicalAlertLevel.critical:
        return 'Alerte importante';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dossier patient',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 18),
            _buildDemoNotice(context),
            const SizedBox(height: 18),
            _buildAlertCard(context),
            const SizedBox(height: 22),
            _buildSectionTitle(context, 'Informations personnelles'),
            const SizedBox(height: 12),
            _buildPersonalInfo(context),
            const SizedBox(height: 22),
            _buildSectionTitle(context, 'Informations médicales'),
            const SizedBox(height: 12),
            _buildMedicalInfo(context),
            const SizedBox(height: 22),
            _buildSectionTitle(context, 'Suivi médical'),
            const SizedBox(height: 12),
            _buildFollowUp(context),
            const SizedBox(height: 22),
            _buildSectionTitle(context, 'Historique des consultations'),
            const SizedBox(height: 12),
            _buildConsultationHistory(context),
            const SizedBox(height: 22),
            _buildSectionTitle(context, 'Documents médicaux'),
            const SizedBox(height: 12),
            _buildDocuments(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(24),
      ),
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
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Référence : ${patient.id}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              _statusLabel(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _headerInfo('${patient.age} ans', 'Âge'),
              Container(height: 34, width: 1, color: Colors.white30),
              _headerInfo(patient.gender, 'Genre'),
              Container(height: 34, width: 1, color: Colors.white30),
              _headerInfo(
                patient.bloodGroup ?? 'Non renseigné',
                'Groupe sanguin',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerInfo(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Données de démonstration : les informations affichées '
              'sont fictives et servent uniquement à présenter '
              'l’interface MedFlow.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context) {
    final color = _alertColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            patient.alertLevel == MedicalAlertLevel.none
                ? Icons.verified_user_outlined
                : Icons.warning_amber_rounded,
            color: color,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _alertLabel(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  patient.alertMessage ??
                      (patient.hasAllergies
                          ? 'Des allergies sont renseignées dans le dossier.'
                          : 'Aucune remarque enregistrée.'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return _sectionCard(
      context,
      children: [
        _infoRow(
          Icons.cake_outlined,
          'Date de naissance',
          _formatDate(patient.dateOfBirth),
        ),
        _infoRow(Icons.phone_outlined, 'Téléphone', patient.phone),
        _infoRow(
          Icons.email_outlined,
          'E-mail',
          patient.email ?? 'Non renseigné',
        ),
        _infoRow(
          Icons.location_on_outlined,
          'Adresse',
          patient.address ?? 'Non renseignée',
        ),
      ],
    );
  }

  Widget _buildMedicalInfo(BuildContext context) {
    return _sectionCard(
      context,
      children: [
        _infoRow(
          Icons.bloodtype_outlined,
          'Groupe sanguin',
          patient.bloodGroup ?? 'Non renseigné',
        ),
        _listInfoRow(
          Icons.warning_amber_outlined,
          'Allergies',
          patient.allergies,
          emptyText: 'Aucune donnée renseignée',
        ),
        _listInfoRow(
          Icons.medical_information_outlined,
          'Antécédents déclarés',
          patient.chronicConditions,
          emptyText: 'Aucune donnée renseignée',
        ),
      ],
    );
  }

  Widget _buildFollowUp(BuildContext context) {
    return _sectionCard(
      context,
      children: [
        _infoRow(
          Icons.event_available_outlined,
          'Prochain rendez-vous',
          _formatDate(patient.nextAppointmentAt),
        ),
        _infoRow(
          Icons.history_rounded,
          'Dernière consultation',
          _formatDate(patient.lastConsultationAt),
        ),
      ],
    );
  }

  Widget _buildConsultationHistory(BuildContext context) {
    final date = patient.lastConsultationAt;

    if (date == null) {
      return _emptyCard(
        context,
        Icons.history_rounded,
        'Aucune consultation enregistrée.',
      );
    }

    return _sectionCard(
      context,
      children: [
        _historyItem(
          context,
          date: _formatDate(date),
          title: 'Consultation enregistrée',
          subtitle: 'Entrée fictive pour la démonstration',
          icon: Icons.medical_services_outlined,
        ),
      ],
    );
  }

  Widget _buildDocuments(BuildContext context) {
    return _emptyCard(
      context,
      Icons.folder_open_outlined,
      'Aucun document disponible dans cette démonstration.',
    );
  }

  Widget _sectionCard(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.lightMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
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

  Widget _listInfoRow(
    IconData icon,
    String label,
    List<String> values, {
    required String emptyText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.lightMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 7),
                if (values.isEmpty)
                  Text(emptyText, style: const TextStyle(fontSize: 13))
                else
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: values.map((value) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem(
    BuildContext context, {
    required String date,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(BuildContext context, IconData icon, String message) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 9),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
