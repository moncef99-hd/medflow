import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../data/appointments_data.dart';
import '../models/appointment.dart';
import '../../doctor_profile/models/doctor.dart';
import '../../family/data/family_data.dart';

class BookingScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateUtils.dateOnly(
    DateTime.now().add(const Duration(days: 1)),
  );

  String? selectedTime;
  String selectedBeneficiaryId = '__self__';

  final TextEditingController reasonController = TextEditingController();

  final List<String> availableTimes = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
  ];

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
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

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateUtils.dateOnly(DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: 'Choisir une date',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (date != null && mounted) {
      setState(() {
        selectedDate = DateUtils.dateOnly(date);
        selectedTime = null;
      });
    }
  }

  void confirmBooking() {
    FocusScope.of(context).unfocus();

    final reason = reasonController.text.trim();

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une heure.')),
      );
      return;
    }

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir le motif du rendez-vous.'),
        ),
      );
      return;
    }

    final timeParts = selectedTime!.split(':');

    final appointmentDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    if (!appointmentDate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez choisir une date et une heure futures.'),
        ),
      );
      return;
    }

    final members = FamilyStore.instance.members;
    final validIds = members.map((member) => member.id).toSet();

    final beneficiaryId =
        selectedBeneficiaryId == '__self__' ||
            !validIds.contains(selectedBeneficiaryId)
        ? null
        : selectedBeneficiaryId;

    final appointment = Appointment(
      id: 'A${DateTime.now().millisecondsSinceEpoch}',
      doctor: widget.doctor,
      dateTime: appointmentDate,
      reason: reason,
      status: AppointmentStatus.pending,
      familyMemberId: beneficiaryId,
    );

    AppointmentsStore.instance.addAppointment(appointment);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre rendez-vous a été enregistré.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  Widget _sectionTitle(String number, String title, String subtitle) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.softBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        ),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? AppColors.cardShadow
            : [],
      ),
      child: child,
    );
  }

  Widget _buildDoctorCard() {
    final theme = Theme.of(context);

    return _card(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AppAvatar(
            name: widget.doctor.fullName,
            imageUrl: widget.doctor.imageUrl,
            size: 76,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.fullName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.doctor.specialty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: AppColors.lightMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.doctor.clinicName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
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

  Widget _buildBeneficiarySelector() {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: FamilyStore.instance,
      builder: (context, child) {
        final members = FamilyStore.instance.members;
        final validIds = members.map((member) => member.id).toSet();

        final currentValue =
            selectedBeneficiaryId == '__self__' ||
                validIds.contains(selectedBeneficiaryId)
            ? selectedBeneficiaryId
            : '__self__';

        return _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_alt_outlined,
                    color: AppColors.primary,
                    size: 21,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    'Bénéficiaire du rendez-vous',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? AppColors.lightBg
                      : AppColors.darkBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentValue,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(14),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: '__self__',
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text('Moi-même'),
                          ],
                        ),
                      ),
                      ...members.map(
                        (member) => DropdownMenuItem<String>(
                          value: member.id,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.people_outline_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${member.fullName} (${member.relationship})',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedBeneficiaryId = value;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateSelector() {
    final theme = Theme.of(context);

    return InkWell(
      onTap: selectDate,
      borderRadius: BorderRadius.circular(18),
      child: _card(
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(selectedDate),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Appuyez pour modifier la date',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_calendar_outlined, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    final theme = Theme.of(context);

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Horaires disponibles',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 9,
            runSpacing: 10,
            children: availableTimes.map((time) {
              final isSelected = selectedTime == time;

              return InkWell(
                onTap: () {
                  setState(() {
                    selectedTime = isSelected ? null : time;
                  });
                },
                borderRadius: BorderRadius.circular(13),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : theme.brightness == Brightness.light
                        ? AppColors.lightBg
                        : AppColors.darkBg,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : theme.dividerColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonField() {
    final theme = Theme.of(context);

    return _card(
      child: TextField(
        controller: reasonController,
        maxLines: 4,
        minLines: 3,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: 'Décrivez brièvement le motif de votre consultation...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          alignLabelWithHint: true,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 55),
            child: Icon(Icons.edit_note_rounded, color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Prendre rendez-vous',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Text(
              'Planifiez votre consultation',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choisissez les détails de votre prochain rendez-vous.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            _buildDoctorCard(),

            const SizedBox(height: 26),

            _sectionTitle(
              '1',
              'Pour qui ?',
              'Sélectionnez le bénéficiaire du rendez-vous.',
            ),
            const SizedBox(height: 13),
            _buildBeneficiarySelector(),

            const SizedBox(height: 26),

            _sectionTitle(
              '2',
              'Choisir une date',
              'Sélectionnez le jour de votre consultation.',
            ),
            const SizedBox(height: 13),
            _buildDateSelector(),

            const SizedBox(height: 26),

            _sectionTitle(
              '3',
              'Choisir une heure',
              'Sélectionnez un créneau disponible.',
            ),
            const SizedBox(height: 13),
            _buildTimeSelector(),

            const SizedBox(height: 26),

            _sectionTitle(
              '4',
              'Motif de consultation',
              'Expliquez brièvement la raison de votre visite.',
            ),
            const SizedBox(height: 13),
            _buildReasonField(),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 14,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.35)),
          ),
          boxShadow: theme.brightness == Brightness.light
              ? AppColors.cardShadow
              : [],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consultation',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${widget.doctor.consultationFee.toStringAsFixed(2)} DT',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GradientButton(
                  label: 'Confirmer',
                  icon: Icons.check_circle_outline_rounded,
                  onPressed: confirmBooking,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
