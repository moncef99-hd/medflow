import 'package:flutter/material.dart';

import '../models/dashboard_models.dart';

class DashboardData {
  static const List<DashboardStat> statistics = [
    DashboardStat(
      title: 'Patients suivis',
      value: '128',
      subtitle: '+12 ce mois',
      icon: Icons.people_alt_rounded,
      color: Color(0xFF2563EB),
      backgroundColor: Color(0xFFEAF2FF),
    ),
    DashboardStat(
      title: "Rendez-vous aujourd'hui",
      value: '12',
      subtitle: '8 confirmés',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF0891B2),
      backgroundColor: Color(0xFFE5F9FA),
    ),
    DashboardStat(
      title: 'Consultations',
      value: '08',
      subtitle: 'Cette journée',
      icon: Icons.medical_services_rounded,
      color: Color(0xFF7C3AED),
      backgroundColor: Color(0xFFF1EDFF),
    ),
    DashboardStat(
      title: 'En attente',
      value: '04',
      subtitle: 'À traiter',
      icon: Icons.schedule_rounded,
      color: Color(0xFFD97706),
      backgroundColor: Color(0xFFFFF4E8),
    ),
  ];

  static const List<WeeklyConsultation> weeklyConsultations = [
    WeeklyConsultation(day: 'Lun', count: 8),
    WeeklyConsultation(day: 'Mar', count: 12),
    WeeklyConsultation(day: 'Mer', count: 10),
    WeeklyConsultation(day: 'Jeu', count: 15),
    WeeklyConsultation(day: 'Ven', count: 9),
    WeeklyConsultation(day: 'Sam', count: 13),
    WeeklyConsultation(day: 'Dim', count: 4),
  ];

  static const List<AppointmentStatusData> appointmentStatuses = [
    AppointmentStatusData(
      label: 'Confirmés',
      count: 8,
      color: Color(0xFF2563EB),
    ),
    AppointmentStatusData(
      label: 'En attente',
      count: 4,
      color: Color(0xFFF59E0B),
    ),
    AppointmentStatusData(
      label: 'Terminés',
      count: 6,
      color: Color(0xFF10B981),
    ),
    AppointmentStatusData(label: 'Annulés', count: 2, color: Color(0xFFEF4444)),
  ];

  static const List<UpcomingAppointment> upcomingAppointments = [
    UpcomingAppointment(
      patientName: 'Ahmed Ben Ali',
      specialty: 'Consultation générale',
      time: '09:00',
      status: 'Confirmé',
      statusColor: Color(0xFF2563EB),
      initials: 'AB',
    ),
    UpcomingAppointment(
      patientName: 'Fatma Trabelsi',
      specialty: 'Contrôle médical',
      time: '09:30',
      status: 'Confirmé',
      statusColor: Color(0xFF2563EB),
      initials: 'FT',
    ),
    UpcomingAppointment(
      patientName: 'Youssef Mansour',
      specialty: 'Consultation de suivi',
      time: '10:15',
      status: 'En attente',
      statusColor: Color(0xFFD97706),
      initials: 'YM',
    ),
  ];

  static const List<DashboardActivity> recentActivities = [
    DashboardActivity(
      title: 'Nouveau rendez-vous',
      description: 'Ahmed Ben Ali a réservé un rendez-vous.',
      time: 'Il y a 15 min',
      icon: Icons.calendar_today_rounded,
      color: Color(0xFF2563EB),
    ),
    DashboardActivity(
      title: 'Consultation terminée',
      description: 'Une consultation a été marquée comme terminée.',
      time: 'Il y a 45 min',
      icon: Icons.check_circle_outline_rounded,
      color: Color(0xFF10B981),
    ),
    DashboardActivity(
      title: 'Nouveau patient',
      description: 'Un patient a été ajouté à la liste.',
      time: 'Il y a 2 h',
      icon: Icons.person_add_alt_1_rounded,
      color: Color(0xFF7C3AED),
    ),
  ];
}
