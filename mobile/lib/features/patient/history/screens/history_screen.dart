import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/gradient_header.dart';
import '../../appointments/data/appointments_data.dart';
import '../../appointments/models/appointment.dart';
import '../data/consultations_data.dart';
import '../models/consultation.dart';
import '../widgets/consultation_card.dart';
import 'consultation_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Consultation> _allConsultations =
      ConsultationsData.getConsultations();

  final AppointmentsStore _appointmentsStore = AppointmentsStore.instance;

  bool _localeReady = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _appointmentsStore.addListener(_refreshAppointments);

    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('fr', null);

    if (!mounted) return;

    setState(() {
      _localeReady = true;
    });
  }

  void _refreshAppointments() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _appointmentsStore.removeListener(_refreshAppointments);
    _tabController.dispose();
    super.dispose();
  }

  List<Appointment> get upcomingAppointments {
    return _appointmentsStore.appointments
        .where(
          (appointment) =>
              appointment.dateTime.isAfter(DateTime.now()) &&
              appointment.status != AppointmentStatus.cancelled,
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Consultation> get completedConsultations {
    return _allConsultations
        .where((c) => c.status == ConsultationStatus.completed)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Consultation> get futureConsultations {
    return _allConsultations
        .where((c) => c.status == ConsultationStatus.upcoming)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_localeReady) {
      return Container(
        color: theme.scaffoldBackgroundColor,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final completed = completedConsultations;
    final upcoming = futureConsultations;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: GradientHeader(
              title: 'Historique médical',
              subtitle: 'Suivez vos consultations et votre parcours de santé.',
              trailing: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                ),
                child: const Icon(
                  Icons.medical_information_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
          _buildUpcomingSection(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.65,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppColors.cardShadow,
                ),
                labelColor: AppColors.primary,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: _buildTabLabel(
                      'Terminées',
                      completed.length,
                      Icons.check_circle_outline_rounded,
                    ),
                  ),
                  Tab(
                    child: _buildTabLabel(
                      'À venir',
                      upcoming.length,
                      Icons.event_available_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(
                  completed,
                  'Aucune consultation terminée',
                  'Vos consultations passées apparaîtront ici.',
                  Icons.history_rounded,
                ),
                _buildList(
                  upcoming,
                  'Aucune consultation à venir',
                  'Vos prochaines consultations apparaîtront ici.',
                  Icons.calendar_today_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabLabel(String title, int count, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    final appointments = upcomingAppointments;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.softBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Prochains rendez-vous',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${appointments.length}',
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
          if (appointments.isEmpty)
            _buildNoAppointmentCard()
          else
            _buildAppointmentCard(appointments.first),
        ],
      ),
    );
  }

  Widget _buildNoAppointmentCard() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: AppColors.success,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Aucun rendez-vous programmé pour le moment.',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final theme = Theme.of(context);
    final doctor = appointment.doctor;
    final date = appointment.dateTime;

    final initials = doctor.fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    final isConfirmed = appointment.status == AppointmentStatus.confirmed;

    final statusColor = isConfirmed ? AppColors.success : AppColors.warning;

    final statusLabel = isConfirmed ? 'Confirmé' : 'En attente';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.canvasGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctor.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${doctor.specialty} • ${appointment.reason}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    _buildDateInfo(
                      Icons.calendar_today_rounded,
                      DateFormat('dd MMM yyyy', 'fr').format(date),
                    ),
                    _buildDateInfo(
                      Icons.access_time_rounded,
                      DateFormat('HH:mm').format(date),
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

  Widget _buildDateInfo(IconData icon, String value) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: muted),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            color: muted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildList(
    List<Consultation> list,
    String title,
    String subtitle,
    IconData icon,
  ) {
    if (list.isEmpty) {
      return _buildEmptyState(title, subtitle, icon);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return ConsultationCard(
          consultation: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConsultationDetailScreen(consultation: item),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.softBlue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(icon, color: AppColors.primary, size: 34),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
