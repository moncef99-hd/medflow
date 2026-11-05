import 'package:flutter/material.dart';
import '../models/consultation.dart';

class ConsultationsData {
  static List<Consultation> getConsultations() {
    return [
      Consultation(
        id: '1',
        doctorName: 'Dr. Ahmed Ben Ali',
        specialty: 'Cardiologue',
        doctorInitials: 'AB',
        date: DateTime.now().add(const Duration(days: 2)),
        time: '14:30',
        motif: 'Contrôle tension artérielle',
        status: ConsultationStatus.upcoming,
        doctorColor: const Color(0xFF3B82F6), // Blue
      ),
      Consultation(
        id: '2',
        doctorName: 'Dr. Sarah Mansour',
        specialty: 'Dermatologue',
        doctorInitials: 'SM',
        date: DateTime.now().subtract(const Duration(days: 12)),
        time: '09:00',
        motif: 'Éruption cutanée',
        status: ConsultationStatus.completed,
        diagnosis: 'Dermatite de contact légère.',
        prescription: 'Crème hydrocortisone 1% - Appliquer 2 fois par jour pendant 5 jours.',
        doctorColor: const Color(0xFF8B5CF6), // Purple
      ),
      Consultation(
        id: '3',
        doctorName: 'Dr. Karim Gharbi',
        specialty: 'Généraliste',
        doctorInitials: 'KG',
        date: DateTime.now().subtract(const Duration(days: 45)),
        time: '16:15',
        motif: 'Fièvre et fatigue',
        status: ConsultationStatus.completed,
        diagnosis: 'Grippe saisonnière.',
        prescription: 'Paracétamol 1g - 3 fois par jour. Repos 3 jours.',
        doctorColor: const Color(0xFF10B981), // Green
      ),
    ];
  }
}