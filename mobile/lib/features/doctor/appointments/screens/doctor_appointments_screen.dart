
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/doctor_appointments_data.dart';
import '../models/doctor_appointment.dart';
import '../widgets/appointment_status_chip.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestion des rendez-vous',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Consultez et gérez les demandes de vos patients.',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: colors.onSurfaceVariant,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  dividerColor: colors.outlineVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'En attente'),
                    Tab(text: 'Confirmés'),
                    Tab(text: 'Terminés'),
                    Tab(text: 'Annulés'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: DoctorAppointmentsStore.instance,
              builder: (context, child) {
                final appointments =
                    DoctorAppointmentsStore.instance.appointments;

                return TabBarView(
                  children: [
                    _AppointmentList(
                      appointments: appointments,
                      status: DoctorAppointmentStatus.pending,
                    ),
                    _AppointmentList(
                      appointments: appointments,
                      status: DoctorAppointmentStatus.confirmed,
                    ),
                    _AppointmentList(
                      appointments: appointments,
                      status: DoctorAppointmentStatus.completed,
                    ),
                    _AppointmentList(
                      appointments: appointments,
                      status: DoctorAppointmentStatus.cancelled,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// APPOINTMENT LIST
// --------------------------------------------------

class _AppointmentList extends StatelessWidget {
  final List<DoctorAppointment> appointments;
  final DoctorAppointmentStatus status;

  const _AppointmentList({
    required this.appointments,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final filteredAppointments = appointments
        .where((appointment) => appointment.status == status)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 48,
              color: colors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Aucun rendez-vous',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: filteredAppointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _AppointmentCard(
          appointment: filteredAppointments[index],
        );
      },
    );
  }
}

// --------------------------------------------------
// APPOINTMENT CARD
// --------------------------------------------------

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointment appointment;

  const _AppointmentCard({
    required this.appointment,
  });

  String _formatDate(DateTime date) {
    const months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  // --------------------------------------------------
  // ACCEPT / REFUSE / CANCEL
  // --------------------------------------------------

  Future<void> _updateStatus(
    BuildContext context,
    DoctorAppointmentStatus newStatus,
    String action,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            '${action[0].toUpperCase()}${action.substring(1)} '
            'le rendez-vous ?',
          ),
          content: Text(
            'Voulez-vous vraiment $action le rendez-vous de '
            '${appointment.patientName} ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Retour'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    DoctorAppointmentsStore.instance.updateAppointment(
      appointment.copyWith(status: newStatus),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rendez-vous : $action avec succès.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --------------------------------------------------
  // RESCHEDULE APPOINTMENT
  // --------------------------------------------------

  Future<void> _reschedule(BuildContext context) async {
    final now = DateTime.now();

    final initialDate = appointment.dateTime.isBefore(now)
        ? DateTime(now.year, now.month, now.day)
        : DateTime(
            appointment.dateTime.year,
            appointment.dateTime.month,
            appointment.dateTime.day,
          );

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      helpText: 'Choisir une nouvelle date',
      cancelText: 'Annuler',
      confirmText: 'Continuer',
    );

    if (selectedDate == null || !context.mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appointment.dateTime),
      helpText: 'Choisir une nouvelle heure',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (selectedTime == null || !context.mounted) return;

    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (newDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez choisir une date et une heure futures.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    DoctorAppointmentsStore.instance.updateAppointment(
      appointment.copyWith(dateTime: newDateTime),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rendez-vous modifié avec succès.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // --------------------------------------------------
  // BUILD CARD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isPending =
        appointment.status == DoctorAppointmentStatus.pending;

    final isConfirmed =
        appointment.status == DoctorAppointmentStatus.confirmed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient information
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor:
                    AppColors.primary.withValues(alpha: 0.10),
                child: Text(
                  appointment.patientName.isNotEmpty
                      ? appointment.patientName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.patientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      appointment.patientPhone,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              AppointmentStatusChip(
                status: appointment.status,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date and time
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatDate(appointment.dateTime),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 6),
              Text(
                _formatTime(appointment.dateTime),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Consultation reason
          Text(
            'Motif de consultation',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            appointment.reason,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Pending actions
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _updateStatus(
                        context,
                        DoctorAppointmentStatus.cancelled,
                        'refuser',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(
                        color: AppColors.danger,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Refuser'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      _updateStatus(
                        context,
                        DoctorAppointmentStatus.confirmed,
                        'accepter',
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            ),
          ],

          // Confirmed appointment actions
          if (isConfirmed) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _reschedule(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(
                      Icons.edit_calendar_outlined,
                      size: 17,
                    ),
                    label: const Text('Modifier'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _updateStatus(
                        context,
                        DoctorAppointmentStatus.cancelled,
                        'annuler',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(
                        color: AppColors.danger,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 17,
                    ),
                    label: const Text('Annuler'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
