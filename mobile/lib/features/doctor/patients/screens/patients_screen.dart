import 'package:flutter/material.dart';

import '../data/doctor_patients_data.dart';
import '../models/doctor_patient.dart';
import '../widgets/patient_card.dart';
import '../widgets/patient_filter_bar.dart';
import '../widgets/patient_search_bar.dart';
import '../widgets/stat_gradient_card.dart';
import 'patient_details_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  static const Color _blue = Color(0xFF2563EB);
  static const Color _background = Color(0xFFF4F6FB);

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
      backgroundColor: theme.brightness == Brightness.dark
          ? theme.scaffoldBackgroundColor
          : _background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatistics(),
                    const SizedBox(height: 28),
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
                        height: 1.5,
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
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Text(
                          'Patients',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _blue.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${patients.length}',
                            style: const TextStyle(
                              color: _blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Résultats',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
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

  Widget _buildHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8), Color(0xFF1E40AF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(right: -45, top: -65, child: _decorationCircle(190)),
            Positioned(right: 65, bottom: -95, child: _decorationCircle(150)),
            Positioned(left: -55, bottom: -110, child: _decorationCircle(170)),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 25, 22, 27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.17),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.20),
                          ),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ESPACE MÉDECIN',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                letterSpacing: 1.6,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gestion des patients',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  Text(
                    '${_patients.length} patients enregistrés',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Gérez les informations et le suivi de vos patients.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 18,
              bottom: 8,
              child: Icon(
                Icons.medical_information_outlined,
                size: 76,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorationCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
          width: 1.5,
        ),
        color: Colors.white.withValues(alpha: 0.035),
      ),
    );
  }

  Widget _buildStatistics() {
    return Column(
      children: [
        StatGradientCard(
          title: 'Total des patients',
          value: '${_patients.length}',
          icon: Icons.people_alt_rounded,
          color: const Color(0xFF2563EB),
          featured: true,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.48,
          children: [
            StatGradientCard(
              title: 'Nouveaux',
              value: '$_newPatients',
              icon: Icons.person_add_alt_1_rounded,
              color: const Color(0xFF8B5CF6),
            ),
            StatGradientCard(
              title: 'En suivi',
              value: '$_followedPatients',
              icon: Icons.health_and_safety_outlined,
              color: const Color(0xFF10B981),
            ),
            StatGradientCard(
              title: 'Inactifs',
              value: '$_inactivePatients',
              icon: Icons.pause_circle_outline_rounded,
              color: const Color(0xFFF59E0B),
            ),
            StatGradientCard(
              title: 'Alertes',
              value: '$_alertPatients',
              icon: Icons.notifications_active_outlined,
              color: const Color(0xFFEF4444),
            ),
          ],
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
                color: _blue.withValues(alpha: 0.09),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_search_rounded,
                size: 36,
                color: _blue,
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
