import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_header.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../../appointments/models/doctor_appointment.dart';
import '../data/doctor_consultations_store.dart';
import '../models/doctor_consultation.dart';
import '../widgets/consultation_status_chip.dart';
import 'consultation_form_screen.dart';

class DoctorConsultationsScreen extends StatefulWidget {
  const DoctorConsultationsScreen({super.key});

  @override
  State<DoctorConsultationsScreen> createState() =>
      _DoctorConsultationsScreenState();
}

class _DoctorConsultationsScreenState extends State<DoctorConsultationsScreen> {
  final DoctorConsultationsStore _store = DoctorConsultationsStore.instance;

  String _dateLabel(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} '
        'à ${two(date.hour)}:${two(date.minute)}';
  }

  Future<void> _startConsultation() async {
    final appointments = _store.availableAppointments;

    if (appointments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Aucun rendez-vous confirmé disponible pour le moment.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final selected = await showModalBottomSheet<DoctorAppointment>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choisir un patient',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                'Sélectionnez un rendez-vous confirmé pour démarrer.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: appointments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.softBlue,
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        appointment.patientName,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${appointment.reason}\n${_dateLabel(appointment.dateTime)}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                      ),
                      onTap: () => Navigator.pop(context, appointment),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected == null || !mounted) return;

    final consultation = _store.startConsultation(selected);

    if (consultation == null) return;

    await _openConsultation(consultation);
  }

  Future<void> _openConsultation(DoctorConsultation consultation) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConsultationFormScreen(consultation: consultation),
      ),
    );

    if (mounted) setState(() {});
  }

  Widget _summaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: SoftCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(height: 12),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _consultationCard(DoctorConsultation consultation) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SoftCard(
        onTap: () => _openConsultation(consultation),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultation.patientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        consultation.patientPhone,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ConsultationStatusChip(status: consultation.status),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  color: AppColors.primary,
                  size: 17,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    consultation.reason,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    _dateLabel(consultation.dateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _consultationList(List<DoctorConsultation> consultations) {
    if (consultations.isEmpty) {
      return _emptyState(
        icon: Icons.medical_information_outlined,
        title: 'Aucune consultation',
        subtitle: 'Les consultations apparaîtront ici une fois démarrées.',
      );
    }

    return Column(children: consultations.map(_consultationCard).toList());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, child) {
        final inProgress = _store.inProgressConsultations;
        final completed = _store.completedConsultations;
        final theme = Theme.of(context);

        return DefaultTabController(
          length: 2,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            children: [
              GradientHeader(
                title: 'Gestion des consultations',
                subtitle:
                    'Suivez les dossiers et les comptes rendus de vos patients.',
                trailing: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.medical_information_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  _summaryCard(
                    title: 'En cours',
                    count: inProgress.length,
                    icon: Icons.pending_actions_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 10),
                  _summaryCard(
                    title: 'Terminées',
                    count: completed.length,
                    icon: Icons.task_alt_rounded,
                    color: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _startConsultation,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Démarrer une consultation',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: AppColors.cardShadow,
                  ),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'En cours'),
                    Tab(text: 'Historique'),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              SizedBox(
                height: 460,
                child: TabBarView(
                  children: [
                    SingleChildScrollView(child: _consultationList(inProgress)),
                    SingleChildScrollView(child: _consultationList(completed)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
