import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/doctor_profile.dart';

class DoctorProfileStore {
  static const String _storageKey = 'doctor_profile';

  Future<DoctorProfile> load() async {
    final preferences = await SharedPreferences.getInstance();
    final profileJson = preferences.getString(_storageKey);

    if (profileJson == null || profileJson.isEmpty) {
      return const DoctorProfile();
    }

    try {
      final decoded = jsonDecode(profileJson) as Map<String, dynamic>;
      return DoctorProfile.fromJson(decoded);
    } catch (_) {
      return const DoctorProfile();
    }
  }

  Future<bool> save(DoctorProfile profile) async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.setString(_storageKey, jsonEncode(profile.toJson()));
  }

  Future<bool> clear() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(_storageKey);
  }
}
