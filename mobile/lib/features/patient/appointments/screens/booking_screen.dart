import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/appointments_data.dart';
import '../models/appointment.dart';
import '../../doctor_profile/models/doctor.dart';

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

  final TextEditingController reasonController = TextEditingController();

  final List<String> availableSlots = [
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
    '16:30',
  ];

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateUtils.dateOnly(DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: 'Choisir une date',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        selectedTime = null;
      });
    }
  }

  String get formattedDate {
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

    return '${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}';
  }

  void confirmBooking() {
    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir un horaire.')),
      );
      return;
    }

    final reason = reasonController.text.trim();

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir le motif de consultation.'),
        ),
      );
      return;
    }

    final parts = selectedTime!.split(':');

    final appointmentDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (!appointmentDate.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisissez un horaire futur.')),
      );
      return;
    }

    final appointment = Appointment(
      id: 'A${DateTime.now().millisecondsSinceEpoch}',
      doctor: widget.doctor,
      dateTime: appointmentDate,
      reason: reason,
      status: AppointmentStatus.pending,
    );

    AppointmentsStore.instance.addAppointment(appointment);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre demande de rendez-vous a été enregistrée.'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.color ?? AppColors.lightMuted;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prendre rendez-vous',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.medical_services_rounded,
                      color: AppColors.primary,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.specialty,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${doctor.consultationFee.toStringAsFixed(0)} DT',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              '1. Choisir une date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            InkWell(
              onTap: chooseDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(14),
                  color: theme.colorScheme.surface,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              '2. Choisir un horaire',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Sélectionnez un créneau disponible.',
              style: TextStyle(color: muted, fontSize: 12),
            ),
            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: availableSlots.map((slot) {
                final isSelected = selectedTime == slot;

                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedTime = slot);
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: theme.colorScheme.surface,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : theme.dividerColor,
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            const Text(
              '3. Motif de consultation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Exemple : consultation de suivi...',
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: confirmBooking,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text(
                  'Confirmer le rendez-vous',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
