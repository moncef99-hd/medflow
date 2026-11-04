import 'package:flutter/material.dart';
import '../../../core/session/user_session.dart';
import '../search/search_filter.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/next_appointment_card.dart';
import 'widgets/recommended_doctors.dart';
import 'widgets/section_header.dart';
import 'widgets/specialties_row.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSearchTap;
  const HomeScreen({super.key, required this.onSearchTap});

  void _openSearch([String? specialty]) {
    SearchFilter.specialty.value = specialty;
    onSearchTap();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          ValueListenableBuilder<String>(
            valueListenable: UserSession.name,
            builder: (_, name, __) => HomeHeader(fullName: name),
          ),
          const SizedBox(height: 20),
          HomeSearchBar(onTap: _openSearch),
          const SizedBox(height: 20),
          const NextAppointmentCard(),
          const SizedBox(height: 24),
          SectionHeader(title: 'Spécialités', onSeeAll: _openSearch),
          const SizedBox(height: 12),
          SpecialtiesRow(onTap: _openSearch),
          const SizedBox(height: 24),
          SectionHeader(title: 'Médecins recommandés', onSeeAll: _openSearch),
          const SizedBox(height: 12),
          const RecommendedDoctors(),
        ],
      ),
    );
  }
}