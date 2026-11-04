import 'package:flutter/foundation.dart';

class UserSession {
  static final ValueNotifier<String> name = ValueNotifier('Patient');

  static void setFromEmail(String email) {
    final prefix = email.split('@').first.trim();
    name.value = prefix.isEmpty
        ? 'Patient'
        : prefix[0].toUpperCase() + prefix.substring(1);
  }

  static void setName(String fullName) {
    name.value = fullName.trim().isEmpty ? 'Patient' : fullName.trim();
  }
}