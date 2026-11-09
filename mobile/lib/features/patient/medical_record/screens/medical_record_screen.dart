
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../family/models/family_member.dart';
import '../data/medical_records_data.dart';
import '../models/medical_record.dart';

class MedicalRecordScreen extends StatelessWidget {
  final FamilyMember member;

  const MedicalRecordScreen({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dossier médical'),
      ),
      body: ListenableBuilder(
        listenable: MedicalRecordsStore.instance,
        builder: (context, child) {
          final record = MedicalRecordsStore.instance
              .getRecordByOwnerId(member.id);

          if (record == null) {
            return _buildEmptyState();
          }

          return _buildMedicalRecord(context, record);
        },
      ),
    );
  }

  Widget _buildMedicalRecord(
    BuildContext context,
    MedicalRecord record,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(record),
        const SizedBox(height: 20),

        _buildSection(
          title: 'Allergies',
          icon: Icons.warning_amber_rounded,
          color: Colors.orange,
          items: record.allergies,
          emptyMessage: 'Aucune allergie renseignée.',
        ),

        _buildSection(
          title: 'Antécédents médicaux',
          icon: Icons.history_rounded,
          color: Colors.blue,
          items: record.medicalHistory,
          emptyMessage: 'Aucun antécédent renseigné.',
        ),

        _buildSection(
          title: 'Traitements en cours',
          icon: Icons.medication_outlined,
          color: Colors.green,
          items: record.currentTreatments,
          emptyMessage: 'Aucun traitement renseigné.',
        ),

        _buildNotes(record),
      ],
    );
  }

  Widget _buildHeader(MedicalRecord record) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor:
                    AppColors.primary.withValues(alpha: 0.15),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.relationship,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Groupe sanguin',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            record.bloodType ?? 'Non renseigné',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
    required String emptyMessage,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (items.isEmpty)
              Text(
                emptyMessage,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: color,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(MedicalRecord record) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.notes_rounded,
                  color: AppColors.primary,
                ),
                SizedBox(width: 10),
                Text(
                  'Notes médicales',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              record.notes?.isNotEmpty == true
                  ? record.notes!
                  : 'Aucune note disponible.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 60,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun dossier médical',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aucune information médicale '
              'n’est encore disponible pour ce membre.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
