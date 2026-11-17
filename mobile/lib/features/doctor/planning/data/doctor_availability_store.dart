import 'package:flutter/foundation.dart';

import '../models/doctor_availability.dart';

class DoctorAvailabilityStore extends ChangeNotifier {
  DoctorAvailabilityStore._();

  static final DoctorAvailabilityStore instance = DoctorAvailabilityStore._();

  DoctorAvailability _availability = const DoctorAvailability();

  DoctorAvailability get availability => _availability;

  void update(DoctorAvailability updatedAvailability) {
    _availability = updatedAvailability;
    notifyListeners();
  }

  bool isWorkingDay(DateTime date) {
    return _availability.workingDays.contains(date.weekday);
  }

  bool isUnavailable(DateTime date) {
    return _availability.isUnavailable(date);
  }

  void addUnavailableDate(DateTime date) {
    final updatedDates = Set<String>.from(_availability.unavailableDates);
    updatedDates.add(DoctorAvailability.dateKey(date));

    update(_availability.copyWith(unavailableDates: updatedDates));
  }

  void removeUnavailableDate(DateTime date) {
    final updatedDates = Set<String>.from(_availability.unavailableDates);
    updatedDates.remove(DoctorAvailability.dateKey(date));

    update(_availability.copyWith(unavailableDates: updatedDates));
  }
}
