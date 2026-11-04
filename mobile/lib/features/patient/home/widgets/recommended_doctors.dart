import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/doctor_card.dart';
import '../../doctor_profile/data/doctors_data.dart';
import '../../doctor_profile/models/doctor.dart';

class RecommendedDoctors extends StatelessWidget {
  const RecommendedDoctors({super.key});

  String _nextSlot(Doctor d) {
    final start = d.workingHours.split(' - ').first;
    if (d.availableDays.isEmpty) return start;
    return '${d.availableDays.first} $start';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: demoDoctors
          .map(
            (d) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DoctorCard(
                name: d.fullName,
                specialty: d.specialty,
                location: '${d.clinicName}, ${d.city}',
                rating: d.rating,
                nextSlot: _nextSlot(d),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.doctorProfile,
                  arguments: d,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}