import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/domain/entities/saved_birthday.dart';
import 'package:smart_age_calculator_pro/presentation/providers/birthday_provider.dart';
import 'package:smart_age_calculator_pro/presentation/screens/add_birthday_screen.dart';

class BirthdayRemindersScreen extends ConsumerWidget {
  const BirthdayRemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthdays = ref.watch(birthdaysProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Birthday Reminders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddBirthdayScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: birthdays.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No birthdays saved yet.\nTap + to add one and get reminders.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: birthdays.length,
              itemBuilder: (context, index) {
                final birthday = birthdays[index];
                return _BirthdayTile(birthday: birthday);
              },
            ),
    );
  }
}

class _BirthdayTile extends ConsumerWidget {
  final SavedBirthday birthday;

  const _BirthdayTile({required this.birthday});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysUntil = birthday.daysUntilNextBirthday();
    final isToday = daysUntil == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(birthday.name.isNotEmpty ? birthday.name[0] : '?'),
        ),
        title: Text(birthday.name),
        subtitle: Text(
          'DOB: ${birthday.dob.day}/${birthday.dob.month}/${birthday.dob.year}\n'
          'Reminders: ${_reminderLabel(birthday.reminderDaysBefore)}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isToday ? '🎉 Today!' : '$daysUntil day${daysUntil == 1 ? '' : 's'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isToday ? Colors.green : Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  String _reminderLabel(List<int> days) {
    if (days.isEmpty) return 'None';
    final sorted = [...days]..sort();
    return sorted.map((d) => d == 0 ? 'day-of' : '${d}d').join(', ');
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Birthday'),
        content: Text('Remove ${birthday.name} and cancel their reminders?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(birthdaysProvider.notifier).deleteBirthday(birthday.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
