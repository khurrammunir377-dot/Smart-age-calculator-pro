import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_age_calculator_pro/presentation/providers/family_provider.dart';
import 'package:smart_age_calculator_pro/presentation/widgets/date_picker_button.dart';

const _relationshipOptions = [
  'Mother',
  'Father',
  'Sister',
  'Brother',
  'Spouse',
  'Son',
  'Daughter',
  'Grandmother',
  'Grandfather',
  'Friend',
  'Other',
];

class AddFamilyMemberScreen extends ConsumerStatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  ConsumerState<AddFamilyMemberScreen> createState() =>
      _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends ConsumerState<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _customRelationshipController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  DateTime? _selectedDate;
  String? _gender;
  String _relationship = _relationshipOptions.first;
  File? _pickedImage;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _customRelationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Family Member')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        _pickedImage != null ? FileImage(_pickedImage!) : null,
                    child: _pickedImage == null
                        ? const Icon(Icons.add_a_photo, size: 32)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _pickImage,
                  child: Text(_pickedImage == null ? 'Add Photo' : 'Change Photo'),
                ),
              ),
              const SizedBox(height: 16),
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
              DropdownButtonFormField<String>(
                value: _relationship,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  prefixIcon: Icon(Icons.group),
                  border: OutlineInputBorder(),
                ),
                items: _relationshipOptions
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _relationship = value);
                },
              ),
              if (_relationship == 'Other') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customRelationshipController,
                  decoration: const InputDecoration(
                    labelText: 'Specify relationship',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (_relationship == 'Other' &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Please specify the relationship';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DatePickerButton(
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Family Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (image != null) {
        setState(() => _pickedImage = File(image.path));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not pick image: $e')),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date of birth')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final notifier = ref.read(familyMembersProvider.notifier);

    String? photoPath;
    if (_pickedImage != null) {
      photoPath = await notifier.persistPhoto(_pickedImage!);
    }

    final relationship = _relationship == 'Other'
        ? _customRelationshipController.text.trim()
        : _relationship;

    await notifier.addFamilyMember(
      name: _nameController.text.trim(),
      dob: _selectedDate!,
      relationship: relationship,
      gender: _gender,
      photoPath: photoPath,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }
}
