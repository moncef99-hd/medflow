
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/appointments_data.dart';
import '../models/appointment.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final AppointmentsStore _store = AppointmentsStore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _store.addListener(_refreshAppointments);
  }

  void _refreshAppointments() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _store.removeListener(_refreshAppointments);
    _tabController.dispose();
    super.dispose();
  }

  List<Appointment> get upcomingAppointments {
    return _store.appointments
        .where(
          (appointment) =>
              appointment.dateTime.isAfter(DateTime.now()) &&
              appointment.status != AppointmentStatus.cancelled,
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Appointment> get pastAppointments {
    return _store.appointments
        .where(
          (appointment) =>
              appointment.dateTime.isBefore(DateTime.now()) ||
              appointment.status == AppointmentStatus.cancelled,
        )
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final mutedColor =
        theme.textTheme.bodySmall?.color ?? AppColors.lightMuted;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: AppColors.gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: mutedColor,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'À venir'),
                  Tab(text: 'Historique'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList(
                  upcomingAppointments,
                  isUpcoming: true,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                _buildAppointmentList(
                  pastAppointments,
                  isUpcoming: false,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(
    List<Appointment> appointments, {
    required bool isUpcoming,
    required Color textColor,
    required Color mutedColor,
  }) {
    if (appointments.isEmpty) {
      return _buildEmptyState(isUpcoming);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return _AppointmentCard(
          appointment: appointments[index],
          isUpcoming: isUpcoming,
          textColor: textColor,
          mutedColor: mutedColor,
        );
      },
    );
  }

  Widget _buildEmptyState(bool isUpcoming) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUpcoming
                  ? Icons.calendar_today_outlined
                  : Icons.history_rounded,
              size: 52,
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming
                  ? 'Aucun rendez-vous à venir'
                  : 'Aucun historique disponible',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming
                  ? 'Vos prochains rendez-vous apparaîtront ici.'
                  : 'Vos anciens rendez-vous apparaîtront ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isUpcoming;
  final Color textColor;
  final Color mutedColor;

  const _AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
    required this.textColor,
    required this.mutedColor,
  });

  String get statusLabel {
    switch (appointment.status) {
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

  Color get statusColor {
    switch (appointment.status) {
      case AppointmentStatus.pending:
        return AppColors.warning;
      case AppointmentStatus.confirmed:
        return AppColors.success;
      case AppointmentStatus.completed:
        return AppColors.primary;
      case AppointmentStatus.cancelled:
        return AppColors.danger;
    }
  }

  String get formattedDate {
    final date = appointment.dateTime;

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

  String get formattedTime {
    final date = appointment.dateTime;
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              height: 1,
            ),
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.calendar_month_outlined,
              text: formattedDate,
              textColor: textColor,
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.access_time_rounded,
              text: formattedTime,
              textColor: textColor,
            ),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: doctor.clinicName,
              textColor: textColor,
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                appointment.reason,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 12,
                ),
              ),
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) =>
                          _AppointmentDetailsDialog(
                        appointment: appointment,
                        formattedDate: formattedDate,
                        formattedTime: formattedTime,
                        statusLabel: statusLabel,
                        statusColor: statusColor,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                  ),
                  label: const Text('Voir les détails'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textColor;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.primary,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// Modern appointment details dialog

class _AppointmentDetailsDialog extends StatelessWidget {
  final Appointment appointment;
  final String formattedDate;
  final String formattedTime;
  final String statusLabel;
  final Color statusColor;

  const _AppointmentDetailsDialog({
    required this.appointment,
    required this.formattedDate,
    required this.formattedTime,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Détails du rendez-vous',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Informations de consultation',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.lightMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.lightMuted,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Doctor information
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.medical_services_outlined,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.fullName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.specialty,
                          style: const TextStyle(
                            color: AppColors.lightMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          doctor.clinicName,
                          style: const TextStyle(
                            color: AppColors.lightMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // Date and time
              Row(
                children: [
                  Expanded(
                    child: _DetailTile(
                      icon: Icons.calendar_month_outlined,
                      label: 'Date',
                      value: formattedDate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DetailTile(
                      icon: Icons.access_time_rounded,
                      label: 'Heure',
                      value: formattedTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const Text(
                'Informations complémentaires',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              _DetailRow(
                icon: Icons.location_on_outlined,
                label: 'Adresse',
                value: '${doctor.address}, ${doctor.city}',
              ),

              const SizedBox(height: 13),

              _DetailRow(
                icon: Icons.description_outlined,
                label: 'Motif',
                value: appointment.reason,
              ),

              const SizedBox(height: 20),

              // Price
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Tarif de consultation',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${doctor.consultationFee.toStringAsFixed(0)} DT',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Close button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 9),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.lightMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 19,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.lightMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
