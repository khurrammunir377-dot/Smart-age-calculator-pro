class AgeResult {
  final int years;
  final int months;
  final int days;
  final int totalDays;
  final int totalWeeks;
  final int totalMonths;
  final int totalHours;
  final int totalMinutes;
  final int totalSeconds;
  final DateTime nextBirthday;
  final int daysUntilBirthday;
  final bool isBirthdayToday;
  final int weekday;

  AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
    required this.totalWeeks,
    required this.totalMonths,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
    required this.nextBirthday,
    required this.daysUntilBirthday,
    required this.isBirthdayToday,
    required this.weekday,
  });
}
