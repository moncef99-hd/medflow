import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/doctor_patients_data.dart';
import '../models/doctor_patient.dart';
import '../widgets/patient_card.dart';
import '../widgets/patient_filter_bar.dart';
import '../widgets/patient_search_bar.dart';
import 'patient_details_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  PatientFilter _selectedFilter = PatientFilter.all;

  List<DoctorPatient> get _patients => DoctorPatientsData.getAll();

  List<DoctorPatient> get _filteredPatients {
    final query = _searchQuery.trim().toLowerCase();

    return _patients.where((patient) {
      final matchesSearch =
          query.isEmpty ||
          patient.fullName.toLowerCase().contains(query) ||
          patient.phone.toLowerCase().contains(query) ||
          patient.id.toLowerCase().contains(query);

      final matchesFilter = switch (_selectedFilter) {
        PatientFilter.all => true,
        PatientFilter.newPatients =>
          patient.status == PatientFollowUpStatus.newPatient,
        PatientFilter.followed =>
          patient.status == PatientFollowUpStatus.followed,
        PatientFilter.inactive =>
          patient.status == PatientFollowUpStatus.inactive,
        PatientFilter.alerts => patient.hasMedicalAlert,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get _newPatients => _patients
      .where((p) => p.status == PatientFollowUpStatus.newPatient)
      .length;

  int get _followedPatients =>
      _patients.where((p) => p.status == PatientFollowUpStatus.followed).length;

  int get _inactivePatients =>
      _patients.where((p) => p.status == PatientFollowUpStatus.inactive).length;

  int get _alertPatients => _patients.where((p) => p.hasMedicalAlert).length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  void _openPatient(DoctorPatient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PatientDetailsScreen(patient: patient)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final patients = _filteredPatients;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(theme)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatistics(theme),
                    const SizedBox(height: 26),
                    Text(
                      'Répertoire des patients',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Retrouvez et consultez les dossiers de vos patients.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    PatientSearchBar(
                      controller: _searchController,
                      value: _searchQuery,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      onClear: _clearSearch,
                    ),
                    const SizedBox(height: 16),
                    PatientFilterBar(
                      selectedFilter: _selectedFilter,
                      onChanged: (filter) {
                        setState(() => _selectedFilter = filter);
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Text(
                          'Patients',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${patients.length}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (patients.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(theme),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final patient = patients[index];

                    return PatientCard(
                      patient: patient,
                      onTap: () => _openPatient(patient),
                    );
                  }, childCount: patients.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESPACE MÉDECIN',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Gestion des patients',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            '${_patients.length} patients enregistrés',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Gérez les informations et le suivi de vos patients.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(ThemeData theme) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.75,
      children: [
        _StatCard(
          title: 'Total patients',
          value: '${_patients.length}',
          icon: Icons.people_alt_rounded,
          color: AppColors.primary,
        ),
        _StatCard(
          title: 'Nouveaux',
          value: '$_newPatients',
          icon: Icons.person_add_alt_1_rounded,
          color: const Color(0xFF0D9488),
        ),
        _StatCard(
          title: 'En suivi',
          value: '$_followedPatients',
          icon: Icons.health_and_safety_outlined,
          color: const Color(0xFF2563EB),
        ),
        _StatCard(
          title: 'Inactifs',
          value: '$_inactivePatients',
          icon: Icons.pause_circle_outline_rounded,
          color: AppColors.warning,
        ),
        _StatCard(
          title: 'Alertes',
          value: '$_alertPatients',
          icon: Icons.notifications_active_outlined,
          color: AppColors.danger,
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Aucun patient trouvé',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez un autre nom ou modifiez vos filtres.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: () {
                _clearSearch();
                setState(() => _selectedFilter = PatientFilter.all);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réinitialiser les filtres'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
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
