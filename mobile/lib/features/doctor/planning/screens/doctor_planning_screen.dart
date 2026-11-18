import 'package:flutter/material.dart';
import 'package:medflow/core/theme/app_colors.dart';
import 'package:medflow/shared/widgets/gradient_header.dart';
import 'package:medflow/shared/widgets/soft_card.dart';

import '../../appointments/data/doctor_appointments_data.dart';
import '../../appointments/models/doctor_appointment.dart';
import '../data/doctor_availability_store.dart';
import '../models/doctor_availability.dart';

class DoctorPlanningScreen extends StatefulWidget {
  const DoctorPlanningScreen({super.key});

  @override
  State<DoctorPlanningScreen> createState() => _DoctorPlanningScreenState();
}

class _DoctorPlanningScreenState extends State<DoctorPlanningScreen> {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());
  DateTime displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool monthView = true;
  bool editingAvailability = false;

  static const dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  static const monthNames = [
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

  DateTime get weekStart =>
      selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

  List<DateTime> get weekDays =>
      List.generate(7, (i) => weekStart.add(Duration(days: i)));

  String get monthTitle =>
      '${monthNames[displayedMonth.month - 1]} ${displayedMonth.year}';

  String formatTime(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';

  List<DoctorAppointment> get selectedAppointments {
    return DoctorAppointmentsStore.instance.appointments
        .where((a) => DateUtils.isSameDay(a.dateTime, selectedDate))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  void selectDate(DateTime date) {
    setState(() {
      selectedDate = DateUtils.dateOnly(date);
      displayedMonth = DateTime(date.year, date.month);
    });
  }

  void changeMonth(int amount) {
    setState(() {
      displayedMonth = DateTime(
        displayedMonth.year,
        displayedMonth.month + amount,
      );
      selectedDate = DateTime(displayedMonth.year, displayedMonth.month, 1);
    });
  }

  void changeWeek(int amount) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: amount * 7));
      displayedMonth = DateTime(selectedDate.year, selectedDate.month);
    });
  }

  void openAvailabilityEditor() {
    setState(() => editingAvailability = true);
  }

  void closeAvailabilityEditor() {
    setState(() => editingAvailability = false);
  }

  void saveAvailability(DoctorAvailability value) {
    DoctorAvailabilityStore.instance.update(value);

    setState(() {
      editingAvailability = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vos disponibilités ont été mises à jour.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DoctorAvailabilityStore.instance,
      builder: (context, _) {
        final availability = DoctorAvailabilityStore.instance.availability;

        return AnimatedBuilder(
          animation: DoctorAppointmentsStore.instance,
          builder: (context, _) {
            final appointments = selectedAppointments;
            final unavailable = availability.isUnavailable(selectedDate);
            final working = availability.workingDays.contains(
              selectedDate.weekday,
            );

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                GradientHeader(
                  title: 'Planning & disponibilité',
                  subtitle: 'Organisez votre agenda et vos horaires',
                  bottom: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          monthTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _HeaderButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: () =>
                            monthView ? changeMonth(-1) : changeWeek(-1),
                      ),
                      const SizedBox(width: 7),
                      _HeaderButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: () => monthView ? changeMonth(1) : changeWeek(1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildViewSelector(),
                const SizedBox(height: 12),
                _buildCalendar(availability),
                const SizedBox(height: 18),
                _buildSelectedDayHeader(
                  working: working,
                  unavailable: unavailable,
                  appointmentCount: appointments.length,
                ),
                const SizedBox(height: 12),
                if (unavailable)
                  _buildDayMessage(
                    icon: Icons.event_busy_rounded,
                    color: AppColors.danger,
                    title: 'Journée indisponible',
                    message: 'Vous avez marqué cette date comme indisponible.',
                  )
                else if (!working)
                  _buildDayMessage(
                    icon: Icons.weekend_rounded,
                    color: AppColors.warning,
                    title: 'Jour non travaillé',
                    message:
                        'Cette journée ne fait pas partie de vos horaires habituels.',
                  ),
                if (appointments.isEmpty)
                  _buildEmptyState()
                else
                  ...appointments.map(
                    (appointment) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AppointmentCard(
                        appointment: appointment,
                        time: formatTime(appointment.dateTime),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                _buildAvailability(availability),
                const SizedBox(height: 14),
                _buildUnavailableDates(availability),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildViewSelector() {
    return SoftCard(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: _ViewButton(
              label: 'Mois',
              icon: Icons.calendar_month_rounded,
              selected: monthView,
              onTap: () => setState(() => monthView = true),
            ),
          ),
          Expanded(
            child: _ViewButton(
              label: 'Semaine',
              icon: Icons.view_week_rounded,
              selected: !monthView,
              onTap: () => setState(() => monthView = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(DoctorAvailability availability) {
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Calendrier',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              TextButton(
                onPressed: () {
                  final today = DateUtils.dateOnly(DateTime.now());
                  selectDate(today);
                },
                child: const Text("Aujourd'hui"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: dayNames
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          if (monthView)
            _buildMonthGrid(availability)
          else
            _buildWeekGrid(availability),
          const SizedBox(height: 14),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(DoctorAvailability availability) {
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;
    final leadingDays = firstDay.weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leadingDays + daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 7,
        crossAxisSpacing: 3,
        mainAxisExtent: 64,
      ),
      itemBuilder: (context, index) {
        if (index < leadingDays) return const SizedBox.shrink();

        final date = DateTime(
          displayedMonth.year,
          displayedMonth.month,
          index - leadingDays + 1,
        );

        return _buildDateCell(date, availability);
      },
    );
  }

  Widget _buildWeekGrid(DoctorAvailability availability) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weekDays
          .map((date) => Expanded(child: _buildDateCell(date, availability)))
          .toList(),
    );
  }

  Widget _buildDateCell(DateTime date, DoctorAvailability availability) {
    final selected = DateUtils.isSameDay(date, selectedDate);
    final today = DateUtils.isSameDay(date, DateTime.now());
    final working = availability.workingDays.contains(date.weekday);
    final unavailable = availability.isUnavailable(date);

    final appointmentCount = DoctorAppointmentsStore.instance.appointments
        .where((a) => DateUtils.isSameDay(a.dateTime, date))
        .length;

    final foreground = selected
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;

    Color? background;
    if (selected) {
      background = AppColors.primary;
    } else if (unavailable) {
      background = AppColors.danger.withValues(alpha: 0.09);
    } else if (today) {
      background = AppColors.primary.withValues(alpha: 0.08);
    }

    return GestureDetector(
      onTap: () => selectDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected || today
                ? AppColors.primary
                : unavailable
                ? AppColors.danger.withValues(alpha: 0.45)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                color: foreground,
                fontWeight: selected || today
                    ? FontWeight.w900
                    : FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            if (unavailable)
              _tinyDot(selected ? Colors.white : AppColors.danger)
            else if (appointmentCount > 0)
              _tinyDot(selected ? Colors.white : AppColors.primary)
            else if (working)
              _tinyDot(selected ? Colors.white : AppColors.success),
          ],
        ),
      ),
    );
  }

  Widget _tinyDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 13,
      runSpacing: 8,
      children: const [
        _LegendItem(color: AppColors.success, label: 'Jour travaillé'),
        _LegendItem(color: AppColors.primary, label: 'Rendez-vous'),
        _LegendItem(color: AppColors.danger, label: 'Indisponible'),
      ],
    );
  }

  Widget _buildSelectedDayHeader({
    required bool working,
    required bool unavailable,
    required int appointmentCount,
  }) {
    final dateLabel =
        '${dayNames[selectedDate.weekday - 1]} ${selectedDate.day} '
        '${monthNames[selectedDate.month - 1]} ${selectedDate.year}';

    final status = unavailable
        ? 'Indisponible'
        : working
        ? 'Jour travaillé'
        : 'Jour non travaillé';

    final statusColor = unavailable
        ? AppColors.danger
        : working
        ? AppColors.success
        : AppColors.warning;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Programme du jour',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 5),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$appointmentCount',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
                fontSize: 19,
              ),
            ),
            Text('rendez-vous', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildDayMessage({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(message, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 18),
      child: Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 36,
            color: AppColors.primary.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 10),
          const Text(
            'Aucun rendez-vous prévu',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            'Aucun rendez-vous enregistré pour cette date.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailability(DoctorAvailability value) {
    if (editingAvailability) {
      return _AvailabilityEditor(
        key: const ValueKey('availability-editor'),
        initial: value,
        onSave: saveAvailability,
        onCancel: closeAvailabilityEditor,
      );
    }

    return SoftCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Mes disponibilités',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Modifier mes disponibilités',
                onPressed: openAvailabilityEditor,
                icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
              ),
            ],
          ),
          const Divider(height: 20),
          _InfoRow(
            label: 'Jours travaillés',
            value: '${value.workingDays.length} / 7 jours',
          ),
          _InfoRow(label: 'Horaires', value: value.workingHours),
          _InfoRow(label: 'Pause', value: value.breakHours),
          _InfoRow(
            label: 'Durée consultation',
            value: '${value.consultationDuration} minutes',
          ),
          _InfoRow(
            label: 'Dates indisponibles',
            value: '${value.unavailableDates.length}',
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: openAvailabilityEditor,
              icon: const Icon(Icons.tune_rounded),
              label: const Text('Modifier mes horaires'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnavailableDates(DoctorAvailability value) {
    final dates = value.unavailableDates.toList()..sort();

    return SoftCard(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event_busy_rounded,
                color: AppColors.danger,
                size: 23,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Jours indisponibles',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                tooltip: 'Ajouter une date',
                onPressed: _addUnavailableDate,
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Bloquez les dates pendant lesquelles vous ne recevez pas de patients.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (dates.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Aucune date indisponible enregistrée.',
                textAlign: TextAlign.center,
              ),
            )
          else
            ...dates.map((key) {
              final parts = key.split('-').map(int.parse).toList();
              final date = DateTime(parts[0], parts[1], parts[2]);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Color(0x1AEF4444),
                  child: Icon(
                    Icons.event_busy_rounded,
                    color: AppColors.danger,
                    size: 20,
                  ),
                ),
                title: Text(
                  '${date.day.toString().padLeft(2, '0')}/'
                  '${date.month.toString().padLeft(2, '0')}/${date.year}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: const Text('Indisponible'),
                trailing: IconButton(
                  tooltip: 'Retirer cette indisponibilité',
                  onPressed: () {
                    DoctorAvailabilityStore.instance.removeUnavailableDate(
                      date,
                    );
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.danger,
                  ),
                ),
              );
            }),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addUnavailableDate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Ajouter un jour indisponible'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addUnavailableDate() async {
    final today = DateUtils.dateOnly(DateTime.now());

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(today) ? today : selectedDate,
      firstDate: today,
      lastDate: DateTime(today.year + 3, 12, 31),
      helpText: 'Choisir un jour indisponible',
      confirmText: 'Ajouter',
      cancelText: 'Annuler',
    );

    if (date == null || !mounted) return;

    final store = DoctorAvailabilityStore.instance;

    if (store.isUnavailable(date)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cette date est déjà indisponible.')),
      );
      return;
    }

    final appointments = DoctorAppointmentsStore.instance.appointments
        .where((a) => DateUtils.isSameDay(a.dateTime, date))
        .toList();

    if (appointments.isNotEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Rendez-vous déjà programmés'),
          content: Text(
            '${appointments.length} rendez-vous existent à cette date. '
            'La marquer indisponible ne les annulera pas. Voulez-vous continuer ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Continuer'),
            ),
          ],
        ),
      );

      if (confirm != true || !mounted) return;
    }

    store.addUnavailableDate(date);
    selectDate(date);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jour marqué comme indisponible.')),
      );
    }
  }
}

// -----------------------------------------------------------------------------
// EDITOR: editable days, working hours, break times and consultation duration.
// -----------------------------------------------------------------------------

class _AvailabilityEditor extends StatefulWidget {
  final DoctorAvailability initial;
  final ValueChanged<DoctorAvailability> onSave;
  final VoidCallback onCancel;

  const _AvailabilityEditor({
    super.key,
    required this.initial,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_AvailabilityEditor> createState() => _AvailabilityEditorState();
}

class _AvailabilityEditorState extends State<_AvailabilityEditor> {
  late Set<int> selectedDays;
  late TimeOfDay start;
  late TimeOfDay end;
  late TimeOfDay breakStart;
  late TimeOfDay breakEnd;
  late int duration;

  static const labels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  @override
  void initState() {
    super.initState();
    final value = widget.initial;

    selectedDays = Set<int>.from(value.workingDays);
    start = TimeOfDay(hour: value.startHour, minute: value.startMinute);
    end = TimeOfDay(hour: value.endHour, minute: value.endMinute);
    breakStart = TimeOfDay(
      hour: value.breakStartHour,
      minute: value.breakStartMinute,
    );
    breakEnd = TimeOfDay(
      hour: value.breakEndHour,
      minute: value.breakEndMinute,
    );
    duration = value.consultationDuration;
  }

  int _minutes(TimeOfDay time) => time.hour * 60 + time.minute;

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  Future<void> _chooseTime(
    TimeOfDay current,
    ValueChanged<TimeOfDay> onChanged,
  ) async {
    final result = await showTimePicker(
      context: context,
      initialTime: current,
      helpText: 'Choisir une heure',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (result == null || !mounted) return;

    setState(() {
      onChanged(result);
    });
  }

  Widget _timeField(
    String label,
    TimeOfDay value,
    ValueChanged<TimeOfDay> onChanged,
    IconData icon,
  ) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () => _chooseTime(value, onChanged),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            children: [
              Icon(icon, size: 19, color: AppColors.primary),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                _formatTime(value),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(Icons.edit_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _save() {
    if (selectedDays.isEmpty) {
      _showError('Sélectionnez au moins un jour travaillé.');
      return;
    }

    if (_minutes(start) >= _minutes(end)) {
      _showError("L'heure de fin doit être après le début.");
      return;
    }

    final hasBreak = _minutes(breakStart) != _minutes(breakEnd);

    if (hasBreak &&
        (_minutes(breakStart) < _minutes(start) ||
            _minutes(breakEnd) > _minutes(end) ||
            _minutes(breakStart) >= _minutes(breakEnd))) {
      _showError('La pause doit être comprise dans les horaires de travail.');
      return;
    }

    final updated = widget.initial.copyWith(
      workingDays: Set<int>.from(selectedDays),
      startHour: start.hour,
      startMinute: start.minute,
      endHour: end.hour,
      endMinute: end.minute,
      breakStartHour: breakStart.hour,
      breakStartMinute: breakStart.minute,
      breakEndHour: breakEnd.hour,
      breakEndMinute: breakEnd.minute,
      consultationDuration: duration,
    );

    widget.onSave(updated);
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Standard Material panel: no custom SoftCard or modal overlay here.
    return Material(
      color: theme.colorScheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune_rounded, color: AppColors.primary),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Modifier mes disponibilités',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  tooltip: 'Fermer',
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Text(
              'Modifiez vos jours et vos horaires. Vos changements seront appliqués après enregistrement.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),

            _sectionTitle('Jours travaillés', Icons.calendar_month_rounded),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final day = index + 1;
                final selected = selectedDays.contains(day);

                return ChoiceChip(
                  label: Text(labels[index]),
                  selected: selected,
                  showCheckmark: true,
                  selectedColor: AppColors.primary.withValues(alpha: 0.18),
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        selectedDays.add(day);
                      } else {
                        selectedDays.remove(day);
                      }
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 20),
            _sectionTitle('Horaires de travail', Icons.access_time_rounded),
            _timeField(
              'Début de journée',
              start,
              (value) => start = value,
              Icons.wb_sunny_outlined,
            ),
            const SizedBox(height: 9),
            _timeField(
              'Fin de journée',
              end,
              (value) => end = value,
              Icons.nights_stay_outlined,
            ),

            const SizedBox(height: 20),
            _sectionTitle('Pause', Icons.free_breakfast_rounded),
            _timeField(
              'Début de pause',
              breakStart,
              (value) => breakStart = value,
              Icons.pause_circle_outline_rounded,
            ),
            const SizedBox(height: 9),
            _timeField(
              'Fin de pause',
              breakEnd,
              (value) => breakEnd = value,
              Icons.play_circle_outline_rounded,
            ),

            const SizedBox(height: 20),
            _sectionTitle('Durée d’une consultation', Icons.timer_outlined),
            DropdownButtonFormField<int>(
              initialValue: duration,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
              ),
              items: [15, 20, 30, 45, 60]
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text('$value minutes'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => duration = value);
              },
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final DoctorAppointment appointment;
  final String time;

  const _AppointmentCard({required this.appointment, required this.time});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String status;

    switch (appointment.status) {
      case DoctorAppointmentStatus.pending:
        color = AppColors.warning;
        status = 'En attente';
      case DoctorAppointmentStatus.confirmed:
        color = AppColors.success;
        status = 'Confirmé';
      case DoctorAppointmentStatus.completed:
        color = AppColors.primary;
        status = 'Terminé';
      case DoctorAppointmentStatus.cancelled:
        color = AppColors.danger;
        status = 'Annulé';
    }

    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 58,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.reason,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 5),
                Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 35,
          height: 35,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ViewButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
