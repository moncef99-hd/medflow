class FamilyMember {
  final String id;
  final String fullName;
  final String relationship;
  final DateTime dateOfBirth;
  final String? phone;
  final String? email;

  const FamilyMember({
    required this.id,
    required this.fullName,
    required this.relationship,
    required this.dateOfBirth,
    this.phone,
    this.email,
  });

  FamilyMember copyWith({
    String? fullName,
    String? relationship,
    DateTime? dateOfBirth,
    String? phone,
    String? email,
  }) {
    return FamilyMember(
      id: id,
      fullName: fullName ?? this.fullName,
      relationship: relationship ?? this.relationship,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}