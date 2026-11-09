
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final AppointmentsStore _appointmentsStore =
      AppointmentsStore.instance;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _appointmentsStore.addListener(_refreshAppointments);
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

  @override
  Widget build(BuildContext context) {
    final completed = _allConsultations
        .where((c) => c.status == ConsultationStatus.completed)
        .toList();

    final upcoming = _allConsultations
        .where((c) => c.status == ConsultationStatus.upcoming)
        .toList();

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          _buildUpcomingSection(),

          Material(
            color: const Color(0xFFF8FAFC),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF0EA5E9),
              unselectedLabelColor: Colors.grey.shade500,
              indicatorColor: const Color(0xFF0EA5E9),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              tabs: const [
                Tab(text: 'Terminées'),
                Tab(text: 'À venir'),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(
                  completed,
                  'Aucune consultation terminée.',
                ),
                _buildList(
                  upcoming,
                  'Aucune consultation à venir.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSection() {
    final appointments = upcomingAppointments;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF0EA5E9),
                size: 22,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Prochains rendez-vous',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${appointments.length}',
                style: const TextStyle(
                  color: Color(0xFF0EA5E9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (appointments.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Aucun rendez-vous programmé pour le moment.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            _buildAppointmentCard(appointments.first),
        ],
      ),
    );
  }

  // Appointment card using the same visual style as ConsultationCard.
  Widget _buildAppointmentCard(Appointment appointment) {
    final doctor = appointment.doctor;
    final date = appointment.dateTime;

    final initials = doctor.fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    final statusColor =
        appointment.status == AppointmentStatus.confirmed
            ? Colors.green
            : Colors.orange;

    final statusLabel =
        appointment.status == AppointmentStatus.confirmed
            ? 'Confirmé'
            : 'En attente';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // No navigation added: keep the current appointment behavior.
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Doctor avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0EA5E9)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF0EA5E9),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Appointment details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${doctor.specialty} • ${appointment.reason}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Date and time
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd MMM yyyy').format(date),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 14,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('HH:mm').format(date),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Consultation> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return ConsultationCard(
          consultation: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ConsultationDetailScreen(consultation: item),
              ),
            );
          },
        );
      },
    );
  }
}
