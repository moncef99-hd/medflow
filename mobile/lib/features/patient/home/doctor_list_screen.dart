import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../doctor_profile/data/doctors_data.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = demoDoctors;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MedFlow',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Bonjour !',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Trouvez le médecin qui vous correspond.',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.lightMuted
                    : AppColors.darkMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Médecins disponibles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            ...doctors.map(
              (doctor) => Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 27,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.10,
                            ),
                            child: Text(
                              doctor.fullName
                                  .split(' ')
                                  .where((part) => part.isNotEmpty)
                                  .take(2)
                                  .map((part) => part[0])
                                  .join(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
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
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  doctor.specialty,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  doctor.city,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.light
                                        ? AppColors.lightMuted
                                        : AppColors.darkMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.warning,
                            size: 19,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor.rating.toStringAsFixed(1)} (${doctor.reviewCount} avis)',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          Text(
                            '${doctor.consultationFee.toStringAsFixed(0)} DT',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.doctorProfile,
                              arguments: doctor,
                            );
                          },
                          child: const Text('Voir le profil'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
