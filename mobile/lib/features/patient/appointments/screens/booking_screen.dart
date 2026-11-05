import 'package:flutter/material.dart';

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
        selectedDate = date;
        selectedTime = null;
      });
    }
  }

  void confirmBooking() {
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

    final appointment = Appointment(
      id: 'A${DateTime.now().millisecondsSinceEpoch}',
      doctor: widget.doctor,
      dateTime: appointmentDate,
      reason: reason,
      status: AppointmentStatus.pending,

      // null = rendez-vous du patient principal.
      // Sinon, le rendez-vous est associé au membre sélectionné.
      familyMemberId: selectedBeneficiaryId == '__self__'
          ? null
          : selectedBeneficiaryId,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prendre un rendez-vous'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Informations du médecin
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.fullName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.doctor.specialty,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Choix du bénéficiaire
            const Text(
              'Pour qui est ce rendez-vous ?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            ListenableBuilder(
              listenable: FamilyStore.instance,
              builder: (context, child) {
                final members = FamilyStore.instance.members;

                final validIds = members.map((member) => member.id).toSet();

                final currentValue =
                    selectedBeneficiaryId == '__self__' ||
                        validIds.contains(selectedBeneficiaryId)
                    ? selectedBeneficiaryId
                    : '__self__';

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: currentValue,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem<String>(
                        value: '__self__',
                        child: Text('Moi-même'),
                      ),
                      ...members.map(
                        (member) => DropdownMenuItem<String>(
                          value: member.id,
                          child: Text(
                            '${member.fullName} (${member.relationship})',
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
                );
              },
            ),

            const SizedBox(height: 26),

            // Choix de la date
            const Text(
              '1. Choisir une date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: selectDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(formatDate(selectedDate)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 26),

            // Choix de l'heure
            const Text(
              '2. Choisir une heure',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: availableTimes.map((time) {
                final isSelected = selectedTime == time;

                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedTime = selected ? time : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 26),

            // Motif du rendez-vous
            const Text(
              '3. Motif du rendez-vous',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Décrivez brièvement le motif...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 30),

            // Confirmation
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: confirmBooking,
                child: const Text(
                  'Confirmer le rendez-vous',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
