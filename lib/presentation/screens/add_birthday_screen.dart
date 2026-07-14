import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/presentation/providers/birthday_provider.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/date_picker_button.dart';

class AddBirthdayScreen extends ConsumerStatefulWidget {
  const AddBirthdayScreen({super.key});

  @override
  ConsumerState<AddBirthdayScreen> createState() => _AddBirthdayScreenState();
}

class _AddBirthdayScreenState extends ConsumerState<AddBirthdayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  final Set<int> _selectedReminderDays = {1};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Birthday')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DatePickerButton(
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Remind me before the birthday',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [1, 3, 7].map((days) {
                  final selected = _selectedReminderDays.contains(days);
                  return FilterChip(
                    label: Text('$days day${days == 1 ? '' : 's'} before'),
                    selected: selected,
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedReminderDays.add(days);
                        } else {
                          _selectedReminderDays.remove(days);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              FilterChip(
                label: const Text('On the day'),
                selected: _selectedReminderDays.contains(0),
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
                      _selectedReminderDays.add(0);
                    } else {
                      _selectedReminderDays.remove(0);
                    }
                  });
                },
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save Birthday'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date of birth')),
      );
      return;
    }

    await ref.read(birthdaysProvider.notifier).addBirthday(
          name: _nameController.text.trim(),
          dob: _selectedDate!,
          reminderDaysBefore: _selectedReminderDays.toList()..sort(),
        );

    if (!mounted) return;
    Navigator.pop(context);
  }
}
