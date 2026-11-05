import 'package:flutter/material.dart';

import '../models/family_member.dart';

class FamilyStore extends ChangeNotifier {
  FamilyStore._();

  static final FamilyStore instance = FamilyStore._();

  final List<FamilyMember> _members = [
    FamilyMember(
      id: 'F001',
      fullName: 'Ahmed Ben Ali',
      relationship: 'Père',
      dateOfBirth: DateTime(1970, 5, 12),
      phone: '20123456',
    ),
    FamilyMember(
      id: 'F002',
      fullName: 'Fatma Ben Ali',
      relationship: 'Mère',
      dateOfBirth: DateTime(1975, 8, 20),
      phone: '22123456',
    ),
  ];

  List<FamilyMember> get members => List.unmodifiable(_members);

  void addMember(FamilyMember member) {
    _members.add(member);
    notifyListeners();
  }

  void updateMember(FamilyMember updatedMember) {
    final index = _members.indexWhere(
      (member) => member.id == updatedMember.id,
    );

    if (index == -1) return;

    _members[index] = updatedMember;
    notifyListeners();
  }

  void deleteMember(String id) {
    _members.removeWhere((member) => member.id == id);
    notifyListeners();
  }
}
