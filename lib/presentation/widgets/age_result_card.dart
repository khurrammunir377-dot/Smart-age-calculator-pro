import 'package:flutter/material.dart';
import 'package:smart_age_calculator_pro/domain/entities/age_result.dart';

class AgeResultCard extends StatelessWidget {
  final AgeResult ageResult;

  const AgeResultCard({super.key, required this.ageResult});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Age',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            _row('Years', ageResult.years.toString()),
            _row('Months', ageResult.months.toString()),
            _row('Days', ageResult.days.toString()),
            const SizedBox(height: 12),
            const Text('Total Time Lived',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip('Total Days', ageResult.totalDays),
                _chip('Total Weeks', ageResult.totalWeeks),
                _chip('Total Hours', ageResult.totalHours),
                _chip('Total Minutes', ageResult.totalMinutes),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.cake, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Next Birthday: ${ageResult.nextBirthday.day}/${ageResult.nextBirthday.month}/${ageResult.nextBirthday.year}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ageResult.isBirthdayToday
                  ? '🎉 It\'s your birthday today!'
                  : 'Days Until Birthday: ${ageResult.daysUntilBirthday}',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    ageResult.isBirthdayToday ? FontWeight.bold : FontWeight.normal,
                color: ageResult.isBirthdayToday ? Colors.green : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _chip(String label, int value) {
    return Chip(label: Text('$label: $value'));
  }
}
