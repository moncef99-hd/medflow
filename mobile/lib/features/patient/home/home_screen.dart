import 'package:flutter/material.dart';

import '../../../core/session/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../search/search_filter.dart';
import 'widgets/next_appointment_card.dart';
import 'widgets/recommended_doctors.dart';
import 'widgets/section_header.dart';
import 'widgets/specialties_row.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchTap;

  const HomeScreen({super.key, required this.onSearchTap});

  void _openSearch() {
    SearchFilter.specialty.value = null;
    onSearchTap();
  }

  void _openSpecialtySearch(String specialty) {
    SearchFilter.specialty.value = specialty;
    onSearchTap();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          ValueListenableBuilder<String>(
            valueListenable: UserSession.name,
            builder: (_, name, __) {
              final firstName = name.trim().isEmpty
                  ? 'Patient'
                  : name.trim().split(' ').first;

              return Column(
                children: [
                  GradientHeader(
                    title: 'Bonjour, $firstName',
                    subtitle: 'Votre santé, notre priorité.',
                    bottomPadding: 20,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: _HeaderSearch(onTap: _openSearch),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const NextAppointmentCard(),
          const SizedBox(height: 24),
          SectionHeader(title: 'Spécialités', onSeeAll: _openSearch),
          const SizedBox(height: 10),
          SpecialtiesRow(onTap: _openSpecialtySearch),
          const SizedBox(height: 20),
          SectionHeader(title: 'Médecins recommandés', onSeeAll: _openSearch),
          const SizedBox(height: 12),
          const RecommendedDoctors(),
        ],
      ),
    );
  }
}

class _HeaderSearch extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderSearch({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Material(
      color: isLight ? Colors.white : AppColors.darkSurface,
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Rechercher un médecin, une spécialité...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isLight ? AppColors.lightMuted : AppColors.darkMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.tune_rounded,
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
