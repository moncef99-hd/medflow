import 'package:flutter/material.dart';

class DashboardStat {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

class WeeklyConsultation {
  final String day;
  final int count;

  const WeeklyConsultation({required this.day, required this.count});
}

class AppointmentStatusData {
  final String label;
  final int count;
  final Color color;

  const AppointmentStatusData({
    required this.label,
    required this.count,
    required this.color,
  });
}

class UpcomingAppointment {
  final String patientName;
  final String specialty;
  final String time;
  final String status;
  final Color statusColor;
  final String initials;

  const UpcomingAppointment({
    required this.patientName,
    required this.specialty,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.initials,
  });
}

class DashboardActivity {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  const DashboardActivity({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
}
