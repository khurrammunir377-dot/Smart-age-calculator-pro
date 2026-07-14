import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:smart_age_calculator_pro/core/services/pdf_report_service.dart';
import 'package:smart_age_calculator_pro/core/utils/age_calculator.dart';
import 'package:smart_age_calculator_pro/domain/entities/age_result.dart';
import 'package:smart_age_calculator_pro/presentation/providers/history_provider.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/age_result_card.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/date_picker_button.dart';

class ReportGeneratorScreen extends ConsumerStatefulWidget {
  const ReportGeneratorScreen({super.key});

  @override
  ConsumerState<ReportGeneratorScreen> createState() => _ReportGeneratorScreenState();
}

class _ReportGeneratorScreenState extends ConsumerState<ReportGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  AgeResult? _ageResult;
  bool _isWorking = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate = _selectedDate != null && _ageResult != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate Age Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
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
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                            _ageResult = AgeCalculator.calculateAge(date);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_ageResult != null) AgeResultCard(ageResult: _ageResult!),
              const SizedBox(height: 20),
              if (canGenerate)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text('Preview / Print'),
                        onPressed: _isWorking ? null : _previewOrPrint,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('Share PDF'),
                        onPressed: _isWorking ? null : _sharePdf,
                      ),
                    ),
                  ],
                ),
              if (_isWorking) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _previewOrPrint() async {
    if (!_formKey.currentState!.validate() || _ageResult == null || _selectedDate == null) {
      return;
    }

    setState(() => _isWorking = true);
    try {
      final bytes = await PdfReportService.buildReport(
        name: _nameController.text.trim(),
        dob: _selectedDate!,
        ageResult: _ageResult!,
      );
      await Printing.layoutPdf(
        onLayout: (format) async => bytes,
        name: 'Age_Report_${_nameController.text.trim()}',
      );
      _logToHistory();
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _sharePdf() async {
    if (!_formKey.currentState!.validate() || _ageResult == null || _selectedDate == null) {
      return;
    }

    setState(() => _isWorking = true);
    try {
      final bytes = await PdfReportService.buildReport(
        name: _nameController.text.trim(),
        dob: _selectedDate!,
        ageResult: _ageResult!,
      );
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'age_report_${_nameController.text.trim().replaceAll(' ', '_')}.pdf',
      );
      _logToHistory();
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  void _logToHistory() {
    if (_ageResult == null || _selectedDate == null) return;
    ref.read(historyProvider.notifier).addEntry(
          name: _nameController.text,
          dob: _selectedDate!,
          summary:
              '${_ageResult!.years} years, ${_ageResult!.months} months, ${_ageResult!.days} days (PDF report generated)',
        );
  }
}
