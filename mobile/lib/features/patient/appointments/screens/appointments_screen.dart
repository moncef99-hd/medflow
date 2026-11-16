import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_header.dart';
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
    if (mounted) setState(() {});
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

  bool _canManage(Appointment appointment) {
    return appointment.dateTime.isAfter(DateTime.now()) &&
        (appointment.status == AppointmentStatus.pending ||
            appointment.status == AppointmentStatus.confirmed);
  }

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

  Future<void> _editAppointment(Appointment appointment) async {
    if (!_canManage(appointment)) return;

    final updatedAppointment = await showModalBottomSheet<Appointment>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditAppointmentSheet(
        appointment: appointment,
        formatDate: _formatDate,
      ),
    );

    if (updatedAppointment == null || !mounted) return;

    final success = _store.updateAppointment(updatedAppointment);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Votre rendez-vous a été modifié.'
              : 'Impossible de modifier ce rendez-vous.',
        ),
        backgroundColor: success ? Colors.green : AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _cancelAppointment(Appointment appointment) async {
    if (!_canManage(appointment)) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.danger,
          size: 38,
        ),
        title: const Text(
          'Annuler le rendez-vous ?',
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Voulez-vous vraiment annuler votre rendez-vous avec '
          '${appointment.doctor.fullName} le '
          '${_formatDate(appointment.dateTime)} à '
          '${_formatTime(appointment.dateTime)} ?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Garder'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirmer l’annulation'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = _store.cancelAppointment(appointment.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Votre rendez-vous a été annulé.'
                : 'Impossible d’annuler ce rendez-vous.',
          ),
          backgroundColor: success ? Colors.green : AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GradientHeader(
          title: 'Mes rendez-vous',
          subtitle: 'Retrouvez et gérez vos consultations.',
          trailing: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.18),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(13),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: theme.textTheme.bodySmall?.color,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.calendar_month_rounded, size: 17),
                  text: 'À venir',
                ),
                Tab(
                  icon: Icon(Icons.history_rounded, size: 17),
                  text: 'Historique',
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentList(upcomingAppointments, isUpcoming: true),
              _buildAppointmentList(pastAppointments, isUpcoming: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentList(
    List<Appointment> appointments, {
    required bool isUpcoming,
  }) {
    if (appointments.isEmpty) return _buildEmptyState(isUpcoming);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 13),
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return _AppointmentCard(
          appointment: appointment,
          canManage: _canManage(appointment),
          onEdit: () => _editAppointment(appointment),
          onCancel: () => _cancelAppointment(appointment),
          formatDate: _formatDate,
          formatTime: _formatTime,
        );
      },
    );
  }

  Widget _buildEmptyState(bool isUpcoming) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming
                    ? Icons.calendar_today_outlined
                    : Icons.history_rounded,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              isUpcoming
                  ? 'Aucun rendez-vous à venir'
                  : 'Aucun historique disponible',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
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
                color: theme.textTheme.bodySmall?.color,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// APPOINTMENT CARD
// ============================================================

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final String Function(DateTime) formatDate;
  final String Function(DateTime) formatTime;

  const _AppointmentCard({
    required this.appointment,
    required this.canManage,
    required this.onEdit,
    required this.onCancel,
    required this.formatDate,
    required this.formatTime,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doctor = appointment.doctor;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.gradient,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: Colors.white,
                  size: 25,
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
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(30),
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
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.055),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _AppointmentInfo(
                    icon: Icons.calendar_month_rounded,
                    label: 'Date',
                    value: formatDate(appointment.dateTime),
                  ),
                ),
                Container(
                  width: 1,
                  height: 35,
                  color: AppColors.primary.withValues(alpha: 0.13),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: _AppointmentInfo(
                    icon: Icons.access_time_rounded,
                    label: 'Heure',
                    value: formatTime(appointment.dateTime),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          _InfoRow(icon: Icons.location_on_outlined, text: doctor.clinicName),
          const SizedBox(height: 9),
          _InfoRow(icon: Icons.description_outlined, text: appointment.reason),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDetails(context),
                  icon: const Icon(Icons.visibility_outlined, size: 17),
                  label: const Text('Détails'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),
              if (canManage) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Modifier'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (canManage) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 18,
                  color: AppColors.danger,
                ),
                label: const Text(
                  'Annuler le rendez-vous',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // New custom Details bottom sheet
  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppointmentDetailsSheet(
        appointment: appointment,
        statusLabel: statusLabel,
        statusColor: statusColor,
        formatDate: formatDate,
        formatTime: formatTime,
      ),
    );
  }
}

// ============================================================
// DETAILS BOTTOM SHEET
// ============================================================

class _AppointmentDetailsSheet extends StatelessWidget {
  final Appointment appointment;
  final String statusLabel;
  final Color statusColor;
  final String Function(DateTime) formatDate;
  final String Function(DateTime) formatTime;

  const _AppointmentDetailsSheet({
    required this.appointment,
    required this.statusLabel,
    required this.statusColor,
    required this.formatDate,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 23),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Détails du rendez-vous',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _CloseButton(onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 20),

              // Doctor information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
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
                              color: Color(0xFF111827),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            doctor.specialty,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const _SheetSectionTitle(title: 'Informations du rendez-vous'),
              const SizedBox(height: 13),

              _SheetInfoTile(
                icon: Icons.calendar_month_rounded,
                label: 'Date',
                value: formatDate(appointment.dateTime),
              ),
              _SheetInfoTile(
                icon: Icons.access_time_rounded,
                label: 'Heure',
                value: formatTime(appointment.dateTime),
              ),
              _SheetInfoTile(
                icon: Icons.location_on_outlined,
                label: 'Cabinet',
                value: doctor.clinicName,
              ),
              _SheetInfoTile(
                icon: Icons.map_outlined,
                label: 'Adresse',
                value: '${doctor.address}, ${doctor.city}',
              ),
              _SheetInfoTile(
                icon: Icons.notes_rounded,
                label: 'Motif de consultation',
                value: appointment.reason,
              ),
              _SheetInfoTile(
                icon: Icons.payments_outlined,
                label: 'Tarif de consultation',
                value: '${doctor.consultationFee.toStringAsFixed(0)} DT',
                isLast: true,
              ),

              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 53,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Fermer',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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

// ============================================================
// EDIT BOTTOM SHEET
// ============================================================

class _EditAppointmentSheet extends StatefulWidget {
  final Appointment appointment;
  final String Function(DateTime) formatDate;

  const _EditAppointmentSheet({
    required this.appointment,
    required this.formatDate,
  });

  @override
  State<_EditAppointmentSheet> createState() => _EditAppointmentSheetState();
}

class _EditAppointmentSheetState extends State<_EditAppointmentSheet> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late TextEditingController reasonController;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    selectedDate = DateUtils.dateOnly(widget.appointment.dateTime);
    selectedTime = TimeOfDay.fromDateTime(widget.appointment.dateTime);
    reasonController = TextEditingController(text: widget.appointment.reason);
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  DateTime get newDateTime => DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  Future<void> _chooseDate() async {
    final today = DateUtils.dateOnly(DateTime.now());

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(today) ? today : selectedDate,
      firstDate: today,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Choisir une nouvelle date',
      cancelText: 'Annuler',
      confirmText: 'Valider',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF111827),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = DateUtils.dateOnly(date);
        errorMessage = null;
      });
    }
  }

  Future<void> _chooseTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      helpText: 'Choisir une nouvelle heure',
      cancelText: 'Annuler',
      confirmText: 'Valider',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF111827),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
        errorMessage = null;
      });
    }
  }

  void _save() {
    final reason = reasonController.text.trim();

    if (reason.isEmpty) {
      setState(() {
        errorMessage = 'Veuillez saisir le motif du rendez-vous.';
      });
      return;
    }

    if (!newDateTime.isAfter(DateTime.now())) {
      setState(() {
        errorMessage = 'Choisissez une date et une heure futures.';
      });
      return;
    }

    final updatedAppointment = widget.appointment.copyWith(
      dateTime: newDateTime,
      reason: reason,
    );

    Navigator.pop(context, updatedAppointment);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(22, 12, 22, 24 + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 23),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Modifier le rendez-vous',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _CloseButton(onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Avec ${widget.appointment.doctor.fullName}',
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
              ),

              const SizedBox(height: 25),
              const _SheetSectionTitle(title: 'Date et heure'),
              const SizedBox(height: 13),

              _EditPickerTile(
                icon: Icons.calendar_month_rounded,
                label: 'Date du rendez-vous',
                value: widget.formatDate(selectedDate),
                onTap: _chooseDate,
              ),
              const SizedBox(height: 11),
              _EditPickerTile(
                icon: Icons.access_time_rounded,
                label: 'Heure du rendez-vous',
                value: selectedTime.format(context),
                onTap: _chooseTime,
              ),

              const SizedBox(height: 24),
              const _SheetSectionTitle(title: 'Motif de consultation'),
              const SizedBox(height: 12),

              TextField(
                controller: reasonController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Décrivez le motif de votre consultation...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF6F7FB),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(color: Color(0xFFE5E9F2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(color: Color(0xFFE5E9F2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.danger,
                      size: 17,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded, size: 20),
                      SizedBox(width: 9),
                      Text(
                        'Enregistrer les modifications',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

// ============================================================
// REUSABLE SHEET COMPONENTS
// ============================================================

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 5,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E6EF),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7280), size: 21),
      style: IconButton.styleFrom(
        backgroundColor: const Color(0xFFF3F5F9),
        fixedSize: const Size(42, 42),
      ),
    );
  }
}

class _SheetSectionTitle extends StatelessWidget {
  final String title;

  const _SheetSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF111827),
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _SheetInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _SheetInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8A93A4),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF202939),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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

class _EditPickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _EditPickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF6F7FB),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFE5E9F2)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Color(0xFF8A93A4),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Color(0xFF202939),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.edit_calendar_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EXISTING CARD COMPONENTS
// ============================================================

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
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 19),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: theme.textTheme.bodySmall?.color,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
