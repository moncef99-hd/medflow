import 'package:flutter/foundation.dart';

class UserSession {
  static final ValueNotifier<String> name = ValueNotifier('Patient');
  static final ValueNotifier<String> email = ValueNotifier('');
  static final ValueNotifier<String> phone = ValueNotifier('');

  static void setFromEmail(String value) {
    final clean = value.trim();
    email.value = clean;
    final prefix = clean.split('@').first.trim();
    name.value = prefix.isEmpty
        ? 'Patient'
        : prefix[0].toUpperCase() + prefix.substring(1);
  }

  static void setName(String fullName) {
    name.value = fullName.trim().isEmpty ? 'Patient' : fullName.trim();
  }

  static void setEmail(String value) => email.value = value.trim();

  static void setPhone(String value) => phone.value = value.trim();

  static void clear() {
    name.value = 'Patient';
    email.value = '';
    phone.value = '';
  }
}