import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/soft_card.dart';
import '../data/doctor_appointments_data.dart';
import '../models/doctor_appointment.dart';
import '../widgets/appointment_status_chip.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DoctorAppointmentsStore.instance,
      builder: (context, child) {
        final appointments = DoctorAppointmentsStore.instance.appointments;

        final pendingCount = appointments
            .where((a) => a.status == DoctorAppointmentStatus.pending)
            .length;
        final confirmedCount = appointments
            .where((a) => a.status == DoctorAppointmentStatus.confirmed)
            .length;
        final completedCount = appointments
            .where((a) => a.status == DoctorAppointmentStatus.completed)
            .length;
        final cancelledCount = appointments
            .where((a) => a.status == DoctorAppointmentStatus.cancelled)
            .length;

        return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DoctorAppointmentsHeader(
                                pendingCount: pendingCount,
                                confirmedCount: confirmedCount,
                              ),
                              const SizedBox(height: 23),
                              Row(
                                children: [
                                  Expanded(
                                    child: _OverviewTile(
                                      icon: Icons.pending_actions_rounded,
                                      label: 'En attente',
                                      value: pendingCount.toString(),
                                      color: AppColors.warning,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _OverviewTile(
                                      icon: Icons.event_available_rounded,
                                      label: 'Confirmés',
                                      value: confirmedCount.toString(),
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Vos rendez-vous',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.4,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    '${appointments.length} au total',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 13),
                              _AppointmentTabs(
                                pending: pendingCount,
                                confirmed: confirmedCount,
                                completed: completedCount,
                                cancelled: cancelledCount,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --------------------------------------------------
// DOCTOR HERO HEADER
// --------------------------------------------------

class _DoctorAppointmentsHeader extends StatelessWidget {
  final int pendingCount;
  final int confirmedCount;

  const _DoctorAppointmentsHeader({
    required this.pendingCount,
    required this.confirmedCount,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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

    final dateLabel = '${now.day} ${months[now.month - 1]} ${now.year}';

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppColors.cardShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -65,
            child: Container(
              width: 185,
              height: 185,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 65,
            bottom: -85,
            child: Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.glassWhite,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.medical_services_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'MEDFLOW PRO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Gestion des\nrendez-vous',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Organisez votre activité et suivez vos patients.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 19),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.today_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        dateLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _HeroCounter(
                      label: 'Demandes en attente',
                      value: pendingCount,
                      icon: Icons.hourglass_top_rounded,
                    ),
                    const SizedBox(width: 12),
                    _HeroCounter(
                      label: 'Rendez-vous confirmés',
                      value: confirmedCount,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCounter extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _HeroCounter({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.17)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 9,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// OVERVIEW TILES
// --------------------------------------------------

class _OverviewTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _OverviewTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isLight ? AppColors.lightMuted : AppColors.darkMuted,
                    fontSize: 10,
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

// --------------------------------------------------
// APPOINTMENT TABS
// --------------------------------------------------

class _AppointmentTabs extends StatelessWidget {
  final int pending;
  final int confirmed;
  final int completed;
  final int cancelled;

  const _AppointmentTabs({
    required this.pending,
    required this.confirmed,
    required this.completed,
    required this.cancelled,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isLight ? AppColors.lightSurface : AppColors.darkSurface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
        ),
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: AppColors.headerGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 13),
        tabs: [
          _TabLabel(label: 'Attente', count: pending),
          _TabLabel(label: 'Confirmés', count: confirmed),
          _TabLabel(label: 'Terminés', count: completed),
          _TabLabel(label: 'Annulés', count: cancelled),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final int count;

  const _TabLabel({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
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

  const _AppointmentList({required this.appointments, required this.status});

  @override
  Widget build(BuildContext context) {
    final filteredAppointments =
        appointments
            .where((appointment) => appointment.status == status)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (filteredAppointments.isEmpty) {
      return _EmptyAppointments(status: status);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 25),
      itemCount: filteredAppointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 13),
      itemBuilder: (context, index) {
        return _AppointmentCard(appointment: filteredAppointments[index]);
      },
    );
  }
}

// --------------------------------------------------
// EMPTY STATE
// --------------------------------------------------

class _EmptyAppointments extends StatelessWidget {
  final DoctorAppointmentStatus status;

  const _EmptyAppointments({required this.status});

  String get _message {
    switch (status) {
      case DoctorAppointmentStatus.pending:
        return 'Toutes les demandes ont été traitées. Vous êtes à jour !';
      case DoctorAppointmentStatus.confirmed:
        return 'Les rendez-vous confirmés apparaîtront ici.';
      case DoctorAppointmentStatus.completed:
        return 'Votre historique de consultations apparaîtra ici.';
      case DoctorAppointmentStatus.cancelled:
        return 'Aucun rendez-vous annulé pour le moment.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: AppColors.canvasGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 39,
              ),
            ),
            const SizedBox(height: 19),
            Text(
              'Aucun rendez-vous',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// APPOINTMENT CARD
// --------------------------------------------------

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointment appointment;

  const _AppointmentCard({required this.appointment});

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

  Future<void> _updateStatus(
    BuildContext context,
    DoctorAppointmentStatus newStatus,
    String action,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text('$action le rendez-vous ?'),
          content: Text(
            'Voulez-vous vraiment $action le rendez-vous de '
            '${appointment.patientName} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Retour'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isPending = appointment.status == DoctorAppointmentStatus.pending;
    final isConfirmed = appointment.status == DoctorAppointmentStatus.confirmed;

    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 51,
                height: 51,
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradient,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  appointment.patientName.isNotEmpty
                      ? appointment.patientName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            appointment.patientPhone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              AppointmentStatusChip(status: appointment.status),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: _AppointmentInfo(
                  icon: Icons.calendar_month_rounded,
                  label: 'DATE',
                  value: _formatDate(appointment.dateTime),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AppointmentInfo(
                  icon: Icons.access_time_rounded,
                  label: 'HEURE',
                  value: _formatTime(appointment.dateTime),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.lightBg
                  : AppColors.darkBg,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.lightBorder
                    : AppColors.darkBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.notes_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'MOTIF DE CONSULTATION',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  appointment.reason,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _updateStatus(
                        context,
                        DoctorAppointmentStatus.cancelled,
                        'Refuser',
                      );
                    },
                    icon: const Icon(Icons.close_rounded, size: 17),
                    label: const Text('Refuser'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.65),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      _updateStatus(
                        context,
                        DoctorAppointmentStatus.confirmed,
                        'Accepter',
                      );
                    },
                    icon: const Icon(Icons.check_rounded, size: 17),
                    label: const Text('Accepter'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (isConfirmed) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _reschedule(context),
                    icon: const Icon(Icons.edit_calendar_outlined, size: 17),
                    label: const Text('Modifier'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _updateStatus(
                        context,
                        DoctorAppointmentStatus.cancelled,
                        'Annuler',
                      );
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 17),
                    label: const Text('Annuler'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.65),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
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

class _AppointmentInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AppointmentInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
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
