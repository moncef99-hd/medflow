import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../models/doctor.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Doctor doctor;
  final VoidCallback onBookAppointment;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
    required this.onBookAppointment,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final muted = isLight ? AppColors.lightMuted : AppColors.darkMuted;
    final surface = isLight ? AppColors.lightSurface : AppColors.darkSurface;
    final border = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeaderButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const Text(
                    'Profil du médecin',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  _HeaderButton(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: isFavorite ? AppColors.danger : null,
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Scrollable profile
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor identity
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.5,
                                ),
                                width: 2,
                              ),
                            ),
                            child: AppAvatar(
                              name: doctor.fullName,
                              imageUrl: doctor.imageUrl,
                              size: 112,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            doctor.fullName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            doctor.specialty,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.warning,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                doctor.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '(${doctor.reviewCount} avis)',
                                style: TextStyle(color: muted, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Statistics
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.work_outline_rounded,
                            value: '${doctor.experienceYears} ans',
                            label: 'Expérience',
                            surface: surface,
                            border: border,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.star_outline_rounded,
                            value: doctor.rating.toStringAsFixed(1),
                            label: 'Note moyenne',
                            surface: surface,
                            border: border,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.chat_bubble_outline_rounded,
                            value: '${doctor.reviewCount}',
                            label: 'Avis',
                            surface: surface,
                            border: border,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // About
                    _SectionTitle(title: 'À propos'),
                    const SizedBox(height: 10),
                    Text(
                      doctor.bio,
                      style: TextStyle(color: muted, height: 1.7, fontSize: 13),
                    ),

                    const SizedBox(height: 24),

                    // Services
                    _SectionTitle(title: 'Services proposés'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: doctor.services.map((service) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            service,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Clinic information
                    _SectionTitle(title: 'Informations du cabinet'),
                    const SizedBox(height: 12),
                    _InfoTile(
                      icon: Icons.local_hospital_outlined,
                      title: doctor.clinicName,
                      subtitle: 'Établissement médical',
                    ),
                    _InfoTile(
                      icon: Icons.location_on_outlined,
                      title: doctor.address,
                      subtitle: doctor.city,
                    ),
                    _InfoTile(
                      icon: Icons.phone_outlined,
                      title: doctor.phone,
                      subtitle: 'Téléphone du cabinet',
                    ),
                    _InfoTile(
                      icon: Icons.access_time_rounded,
                      title: doctor.workingHours,
                      subtitle: 'Horaires de consultation',
                    ),

                    const SizedBox(height: 24),

                    // Available days
                    _SectionTitle(title: 'Disponibilités'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: doctor.availableDays.map((day) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            day,
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Languages
                    _SectionTitle(title: 'Langues parlées'),
                    const SizedBox(height: 12),
                    Text(
                      doctor.languages.join(' • '),
                      style: TextStyle(color: muted, fontSize: 13),
                    ),

                    const SizedBox(height: 24),

                    // Reviews
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _SectionTitle(title: 'Avis des patients'),
                        Text(
                          '${doctor.reviewCount} avis',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (doctor.reviews.isEmpty)
                      Text(
                        'Aucun avis disponible pour le moment.',
                        style: TextStyle(color: muted, fontSize: 13),
                      )
                    else
                      ...doctor.reviews
                          .take(3)
                          .map((review) => _ReviewCard(review: review)),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Fixed appointment button
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: surface,
            border: Border(top: BorderSide(color: border)),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultation',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${doctor.consultationFee.toStringAsFixed(0)} DT',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: GradientButton(
                  label: 'Prendre rendez-vous',
                  icon: Icons.calendar_month_rounded,
                  onPressed: widget.onBookAppointment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _HeaderButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: iconColor),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color surface;
  final Color border;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.surface,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightMuted
        : AppColors.darkMuted;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 21),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightMuted
        : AppColors.darkMuted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
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
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(subtitle, style: TextStyle(color: muted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final DoctorReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightMuted
        : AppColors.darkMuted;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(name: review.patientName, size: 38),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.patientName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        review.date,
                        style: TextStyle(color: muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warning,
                  size: 17,
                ),
                const SizedBox(width: 3),
                Text(
                  review.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: TextStyle(color: muted, fontSize: 12, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
