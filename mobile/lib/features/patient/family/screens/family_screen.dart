import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/family_data.dart';
import '../models/family_member.dart';
import '../widgets/family_member_card.dart';
import '../../appointments/data/appointments_data.dart';
import '../../appointments/models/appointment.dart';
import '../../medical_record/screens/medical_record_screen.dart';
import 'family_member_form_screen.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} à '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _statusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 'En attente';
      case AppointmentStatus.confirmed:
        return 'Confirmé';
      case AppointmentStatus.completed:
        return 'Terminé';
      case AppointmentStatus.cancelled:
        return 'Annulé';
    }
  }

  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.blue;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
    }
  }

  Future<void> _confirmDelete(BuildContext context, FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text(
          'Voulez-vous vraiment supprimer ${member.fullName} de votre famille ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      FamilyStore.instance.deleteMember(member.id);
    }
  }

  void _showMemberDetails(BuildContext context, FamilyMember member) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            member.fullName,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListenableBuilder(
              listenable: AppointmentsStore.instance,
              builder: (context, child) {
                final appointments = AppointmentsStore.instance
                    .appointmentsForFamilyMember(member.id);

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Informations personnelles
                      const Text(
                        'Informations personnelles',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildInfoRow(
                        Icons.people_outline,
                        'Lien familial',
                        member.relationship,
                      ),
                      const SizedBox(height: 8),

                      _buildInfoRow(
                        Icons.cake_outlined,
                        'Date de naissance',
                        _formatDate(member.dateOfBirth),
                      ),

                      if (member.phone != null && member.phone!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.phone_outlined,
                          'Téléphone',
                          member.phone!,
                        ),
                      ],

                      if (member.email != null && member.email!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.email_outlined,
                          'Email',
                          member.email!,
                        ),
                      ],

                      const SizedBox(height: 22),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Historique des rendez-vous
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Rendez-vous',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            '${appointments.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (appointments.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 30),
                              SizedBox(height: 8),
                              Text(
                                'Aucun rendez-vous enregistré pour ce membre.',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        ...appointments.map(
                          (appointment) => Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.doctor.fullName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    appointment.doctor.specialty,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildInfoRow(
                                    Icons.calendar_month_outlined,
                                    'Date',
                                    _formatDateTime(appointment.dateTime),
                                  ),
                                  const SizedBox(height: 6),
                                  _buildInfoRow(
                                    Icons.notes_outlined,
                                    'Motif',
                                    appointment.reason,
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(
                                          appointment.status,
                                        ).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        _statusLabel(appointment.status),
                                        style: TextStyle(
                                          color: _statusColor(
                                            appointment.status,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
         actions: [
  TextButton(
    onPressed: () => Navigator.pop(dialogContext),
    child: const Text('Fermer'),
  ),
  FilledButton.icon(
    onPressed: () {
      Navigator.pop(dialogContext);

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MedicalRecordScreen(member: member),
        ),
      );
    },
    icon: const Icon(Icons.medical_information_outlined),
    label: const Text('Dossier médical'),
  ),
],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text('$label : $value', style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Future<void> _openAddMember(BuildContext context) async {
    await showFamilyMemberForm(context);
  }

  Future<void> _openEditMember(
    BuildContext context,
    FamilyMember member,
  ) async {
    await showFamilyMemberForm(context, member: member);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [  
          Text(
            'Gérez les profils des membres de votre famille.',
            style: TextStyle(color: muted, fontSize: 14),
          ),
          const SizedBox(height: 20),

          ListenableBuilder(
            listenable: FamilyStore.instance,
            builder: (context, child) {
              final members = FamilyStore.instance.members;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Membres enregistrés',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${members.length} membre(s)',
                        style: TextStyle(color: muted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (members.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 42,
                            color: muted,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Aucun membre enregistré',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Ajoutez un membre pour commencer.',
                            style: TextStyle(color: muted, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  else
                    ...members.map(
                      (member) => FamilyMemberCard(
                        member: member,
                        onTap: () => _showMemberDetails(context, member),
                        onEdit: () => _openEditMember(context, member),
                        onDelete: () => _confirmDelete(context, member),
                      ),
                    ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openAddMember(context),
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Ajouter un membre'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
