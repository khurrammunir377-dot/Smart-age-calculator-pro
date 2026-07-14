import 'package:smart_age_calculator_pro/domain/entities/age_result.dart';

class AgeCalculator {
  static AgeResult calculateAge(DateTime birthDate, {DateTime? currentDate}) {
    final now = currentDate ?? DateTime.now();
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);

    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    final duration = now.difference(birth);
    final totalDays = duration.inDays;
    final totalHours = duration.inHours;
    final totalMinutes = duration.inMinutes;
    final totalSeconds = duration.inSeconds;

    final nextBirthday = DateTime(now.year, birth.month, birth.day);
    final nextBirthdayThisYear = nextBirthday.isAfter(now)
        ? nextBirthday
        : DateTime(now.year + 1, birth.month, birth.day);
    final daysUntilBirthday = nextBirthdayThisYear.difference(now).inDays;

    return AgeResult(
      years: years,
      months: months,
      days: days,
      totalDays: totalDays,
      totalWeeks: (totalDays / 7).floor(),
      totalMonths: (totalDays / 30.44).floor(),
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      totalSeconds: totalSeconds,
      nextBirthday: nextBirthdayThisYear,
      daysUntilBirthday: daysUntilBirthday,
      isBirthdayToday: daysUntilBirthday == 0,
      weekday: nextBirthdayThisYear.weekday,
    );
  }
}
