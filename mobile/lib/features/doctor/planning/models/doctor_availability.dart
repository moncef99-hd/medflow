class DoctorAvailability {
  final Set<int> workingDays;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final int breakStartHour;
  final int breakStartMinute;
  final int breakEndHour;
  final int breakEndMinute;
  final int consultationDuration;

  // Dates are stored as yyyy-MM-dd strings.
  final Set<String> unavailableDates;

  const DoctorAvailability({
    this.workingDays = const {1, 2, 3, 4, 5},
    this.startHour = 8,
    this.startMinute = 0,
    this.endHour = 17,
    this.endMinute = 0,
    this.breakStartHour = 12,
    this.breakStartMinute = 0,
    this.breakEndHour = 13,
    this.breakEndMinute = 0,
    this.consultationDuration = 30,
    this.unavailableDates = const {},
  });

  DoctorAvailability copyWith({
    Set<int>? workingDays,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    int? breakStartHour,
    int? breakStartMinute,
    int? breakEndHour,
    int? breakEndMinute,
    int? consultationDuration,
    Set<String>? unavailableDates,
  }) {
    return DoctorAvailability(
      workingDays: workingDays ?? this.workingDays,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      breakStartHour: breakStartHour ?? this.breakStartHour,
      breakStartMinute: breakStartMinute ?? this.breakStartMinute,
      breakEndHour: breakEndHour ?? this.breakEndHour,
      breakEndMinute: breakEndMinute ?? this.breakEndMinute,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      unavailableDates: unavailableDates ?? this.unavailableDates,
    );
  }

  String get workingHours =>
      '${_format(startHour, startMinute)} - '
      '${_format(endHour, endMinute)}';

  String get breakHours =>
      '${_format(breakStartHour, breakStartMinute)} - '
      '${_format(breakEndHour, breakEndMinute)}';

  static String dateKey(DateTime date) {
    final day = DateUtilsPlaceholder.dateOnly(date);
    return '${day.year.toString().padLeft(4, '0')}-'
        '${day.month.toString().padLeft(2, '0')}-'
        '${day.day.toString().padLeft(2, '0')}';
  }

  bool isUnavailable(DateTime date) {
    return unavailableDates.contains(dateKey(date));
  }

  static String _format(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }
}

// Keeps the model independent from Flutter's DateUtils.
class DateUtilsPlaceholder {
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
