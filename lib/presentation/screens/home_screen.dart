import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/presentation/providers/age_calculator_provider.dart';
import 'package:smart_age_calculator_pro/presentation/providers/history_provider.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/age_result_card.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/date_picker_button.dart';
import 'package:smart_age_calculator_pro/presentation/screens/settings_screen.dart';
import 'package:smart_age_calculator_pro/presentation/screens/zodiac_screen.dart';
import 'package:smart_age_calculator_pro/presentation/screens/birthday_reminders_screen.dart';
import 'package:smart_age_calculator_pro/presentation/screens/family_tracker_screen.dart';
import 'package:smart_age_calculator_pro/presentation/screens/history_screen.dart';
import 'package:smart_age_calculator_pro/presentation/screens/report_generator_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _nameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ageResult = ref.watch(ageCalculatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Age Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Calculate an Age',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name (optional, saved to history)',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DatePickerButton(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) => setState(() => _selectedDate = date),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate Age'),
                      onPressed: _selectedDate == null ? null : _calculateAndLog,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (ageResult != null) AgeResultCard(ageResult: ageResult),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Tools',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Text('♈')),
                      title: const Text('Zodiac Info'),
                      subtitle: const Text('Western & Chinese zodiac for your date of birth'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ZodiacScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.cake)),
                      title: const Text('Birthday Reminders'),
                      subtitle: const Text('Save birthdays and get notified before they arrive'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BirthdayRemindersScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.family_restroom)),
                      title: const Text('Family Age Tracker'),
                      subtitle: const Text('Save unlimited family members with photos'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FamilyTrackerScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.history)),
                      title: const Text('History'),
                      subtitle: const Text('View and search all past calculations'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.picture_as_pdf)),
                      title: const Text('Age Report (PDF)'),
                      subtitle: const Text('Generate a shareable PDF age report'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ReportGeneratorScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateAndLog() {
    final date = _selectedDate;
    if (date == null) return;

    ref.read(ageCalculatorProvider.notifier).calculateAge(date);
    final result = ref.read(ageCalculatorProvider);
    if (result == null) return;

    ref.read(historyProvider.notifier).addEntry(
          name: _nameController.text,
          dob: date,
          summary: '${result.years} years, ${result.months} months, ${result.days} days',
        );
  }
}
