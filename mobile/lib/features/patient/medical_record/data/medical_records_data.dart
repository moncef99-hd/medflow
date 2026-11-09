
import 'package:flutter/material.dart';

import '../models/medical_record.dart';

class MedicalRecordsStore extends ChangeNotifier {
  MedicalRecordsStore._();

  static final MedicalRecordsStore instance =
      MedicalRecordsStore._();

  final List<MedicalRecord> _records = [
    const MedicalRecord(
      id: 'MR001',
      ownerId: 'F001',
      bloodType: 'A+',
      allergies: ['Pollen'],
      medicalHistory: ['Hypertension'],
      currentTreatments: ['Traitement antihypertenseur'],
      notes: 'Suivi médical régulier.',
    ),
    const MedicalRecord(
      id: 'MR002',
      ownerId: 'F002',
      bloodType: 'O+',
      allergies: [],
      medicalHistory: ['Aucune connue'],
      currentTreatments: [],
      notes: 'Aucun commentaire.',
    ),
  ];

  List<MedicalRecord> get records =>
      List.unmodifiable(_records);

  MedicalRecord? getRecordByOwnerId(String ownerId) {
    for (final record in _records) {
      if (record.ownerId == ownerId) {
        return record;
      }
    }

    return null;
  }

  void addRecord(MedicalRecord record) {
    final existing = getRecordByOwnerId(record.ownerId);

    if (existing != null) return;

    _records.add(record);
    notifyListeners();
  }

  void updateRecord(MedicalRecord updatedRecord) {
    final index = _records.indexWhere(
      (record) => record.id == updatedRecord.id,
    );

    if (index == -1) return;

    _records[index] = updatedRecord;
    notifyListeners();
  }
}
