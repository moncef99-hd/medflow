import 'package:flutter/material.dart';

enum ConsultationStatus { completed, upcoming }

class Consultation {
  final String id;
  final String doctorName;
  final String specialty;
  final String doctorInitials;
  final DateTime date;
  final String time;
  final String motif;
  final ConsultationStatus status;
  final String? diagnosis;
  final String? prescription;
  final Color doctorColor;

  Consultation({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.doctorInitials,
    required this.date,
    required this.time,
    required this.motif,
    required this.status,
    this.diagnosis,
    this.prescription,
    this.doctorColor = const Color(0xFF0EA5E9),
  });
}