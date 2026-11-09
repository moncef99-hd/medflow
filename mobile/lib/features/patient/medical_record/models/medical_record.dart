
class MedicalRecord {
  final String id;
  final String ownerId;
  final String? bloodType;
  final List<String> allergies;
  final List<String> medicalHistory;
  final List<String> currentTreatments;
  final String? notes;

  const MedicalRecord({
    required this.id,
    required this.ownerId,
    this.bloodType,
    this.allergies = const [],
    this.medicalHistory = const [],
    this.currentTreatments = const [],
    this.notes,
  });

  MedicalRecord copyWith({
    String? bloodType,
    List<String>? allergies,
    List<String>? medicalHistory,
    List<String>? currentTreatments,
    String? notes,
  }) {
    return MedicalRecord(
      id: id,
      ownerId: ownerId,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      currentTreatments:
          currentTreatments ?? this.currentTreatments,
      notes: notes ?? this.notes,
    );
  }
}
