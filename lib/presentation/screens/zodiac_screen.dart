import 'package:flutter/material.dart';
import 'package:smart_age_calculator_pro/core/utils/zodiac_calculator.dart';
import 'package:smart_age_calculator_pro/domain/entities/zodiac_info.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/date_picker_button.dart';

class ZodiacScreen extends StatefulWidget {
  const ZodiacScreen({super.key});

  @override
  State<ZodiacScreen> createState() => _ZodiacScreenState();
}

class _ZodiacScreenState extends State<ZodiacScreen> {
  DateTime? _selectedDate;
  ZodiacInfo? _zodiacInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zodiac Information')),
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
                    const Text(
                      'Select Date of Birth',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    DatePickerButton(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                          _zodiacInfo = ZodiacCalculator.calculate(date);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_zodiacInfo != null) ...[
              const SizedBox(height: 20),
              _buildWesternCard(_zodiacInfo!.westernZodiac),
              const SizedBox(height: 20),
              _buildChineseCard(_zodiacInfo!.chineseZodiac),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWesternCard(WesternZodiac zodiac) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(zodiac.symbol, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              zodiac.signName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              zodiac.dateRange,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Divider(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Personality Traits',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(zodiac.personalitySummary, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildChineseCard(ChineseZodiac zodiac) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Chinese Zodiac',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(zodiac.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              zodiac.animalSign,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Birth Year: ${zodiac.birthYear}',
                style: TextStyle(color: Colors.grey.shade600)),
            const Divider(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Characteristics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(zodiac.characteristics, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
