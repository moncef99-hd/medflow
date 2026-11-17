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
    final background = isLight ? AppColors.lightBg : AppColors.darkBg;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHero(doctor, isLight)),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildStatistics(doctor, surface, border, muted),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildAbout(doctor, muted),
                  const SizedBox(height: 24),
                  _buildServices(doctor),
                  const SizedBox(height: 24),
                  _buildClinic(doctor, muted, surface, border),
                  const SizedBox(height: 24),
                  _buildAvailability(doctor),
                  const SizedBox(height: 24),
                  _buildLanguages(doctor, muted, surface, border),
                  const SizedBox(height: 24),
                  _buildReviews(doctor, muted),
                  const SizedBox(height: 12),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: surface,
            border: Border(top: BorderSide(color: border)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultation',
                    style: TextStyle(
                      color: muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${doctor.consultationFee.toStringAsFixed(0)} DT',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
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

  Widget _buildHero(Doctor doctor, bool isLight) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          Positioned(top: -65, right: -45, child: _decorationCircle(180)),
          Positioned(bottom: 65, left: -65, child: _decorationCircle(145)),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 34),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HeroButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.maybePop(context),
                    ),
                    const Text(
                      'Profil du médecin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _HeroButton(
                      icon: isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      iconColor: isFavorite ? const Color(0xFFFFB4C0) : null,
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.75),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: AppAvatar(
                    name: doctor.fullName,
                    imageUrl: doctor.imageUrl,
                    size: 112,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  doctor.fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    doctor.specialty,
                    style: const TextStyle(
                      color: AppColors.mintText,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFD166),
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${doctor.reviewCount} avis)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        '${doctor.city} · ${doctor.clinicName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
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

  Widget _decorationCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.055),
      ),
    );
  }

  Widget _buildStatistics(
    Doctor doctor,
    Color surface,
    Color border,
    Color muted,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 8),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border.withValues(alpha: 0.7)),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.workspace_premium_outlined,
              value: '${doctor.experienceYears} ans',
              label: 'Expérience',
            ),
          ),
          _statDivider(border),
          Expanded(
            child: _StatItem(
              icon: Icons.star_outline_rounded,
              value: doctor.rating.toStringAsFixed(1),
              label: 'Note moyenne',
            ),
          ),
          _statDivider(border),
          Expanded(
            child: _StatItem(
              icon: Icons.chat_bubble_outline_rounded,
              value: '${doctor.reviewCount}',
              label: 'Avis patients',
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDivider(Color border) {
    return Container(width: 1, height: 42, color: border);
  }

  Widget _buildAbout(Doctor doctor, Color muted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'À propos',
          subtitle: 'Présentation du médecin',
        ),
        const SizedBox(height: 12),
        Text(
          doctor.bio,
          style: TextStyle(color: muted, fontSize: 13, height: 1.7),
        ),
      ],
    );
  }

  Widget _buildServices(Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Services proposés',
          subtitle: 'Les soins disponibles',
        ),
        const SizedBox(height: 13),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: doctor.services.map((service) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                service,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClinic(Doctor doctor, Color muted, Color surface, Color border) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Informations du cabinet',
          subtitle: 'Où consulter ce médecin',
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
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
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailability(Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Disponibilités',
          subtitle: 'Jours de consultation',
        ),
        const SizedBox(height: 13),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: doctor.availableDays.map((day) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    day,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguages(
    Doctor doctor,
    Color muted,
    Color surface,
    Color border,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Langues parlées',
          subtitle: 'Communication avec le médecin',
        ),
        const SizedBox(height: 13),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.translate_rounded,
                color: AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  doctor.languages.join(' • '),
                  style: TextStyle(
                    color: muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(Doctor doctor, Color muted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: _SectionHeading(
                title: 'Avis des patients',
                subtitle: 'Leurs expériences',
              ),
            ),
            Text(
              '${doctor.reviewCount} avis',
              style: TextStyle(
                color: muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        if (doctor.reviews.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Aucun avis disponible pour le moment.',
              style: TextStyle(color: muted, fontSize: 13),
            ),
          )
        else
          ...doctor.reviews
              .take(3)
              .map((review) => _ReviewCard(review: review)),
      ],
    );
  }
}

class _HeroButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _HeroButton({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.glassWhite,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(icon, color: iconColor ?? Colors.white, size: 21),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightMuted
        : AppColors.darkMuted;

    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: muted,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeading({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightMuted
        : AppColors.darkMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(subtitle!, style: TextStyle(color: muted, fontSize: 11)),
        ],
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightMuted
        : AppColors.darkMuted;
    final border = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightBorder
        : AppColors.darkBorder;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: 14),
            Divider(height: 1, color: border),
          ],
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
    final surface = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightSurface
        : AppColors.darkSurface;
    final border = Theme.of(context).brightness == Brightness.light
        ? AppColors.lightBorder
        : AppColors.darkBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: review.patientName, size: 39),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      review.date,
                      style: TextStyle(color: muted, fontSize: 10),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(color: muted, fontSize: 12, height: 1.55),
          ),
        ],
      ),
    );
  }
}
