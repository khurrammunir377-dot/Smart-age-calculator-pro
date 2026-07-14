import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:smart_age_calculator_pro/data/repositories/family_repository.dart';
import 'package:smart_age_calculator_pro/domain/entities/family_member.dart';

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FamilyRepository();
});

final familyMembersProvider =
    StateNotifierProvider<FamilyMembersNotifier, List<FamilyMember>>((ref) {
  return FamilyMembersNotifier(ref.read(familyRepositoryProvider));
});

/// Family members with an upcoming birthday within 30 days, soonest first.
final upcomingFamilyBirthdaysProvider = Provider<List<FamilyMember>>((ref) {
  final members = [...ref.watch(familyMembersProvider)];
  members.sort(
    (a, b) => a.daysUntilNextBirthday().compareTo(b.daysUntilNextBirthday()),
  );
  return members.where((m) => m.daysUntilNextBirthday() <= 30).toList();
});

class FamilyMembersNotifier extends StateNotifier<List<FamilyMember>> {
  final FamilyRepository _repository;

  FamilyMembersNotifier(this._repository) : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getAll();
  }

  /// Copies the picked image into the app's own documents directory so it
  /// keeps working even if the original photo is deleted from the gallery.
  Future<String> persistPhoto(File pickedImage) async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(appDir.path, 'family_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(pickedImage.path)}';
    final savedImage = await pickedImage.copy(p.join(photosDir.path, fileName));
    return savedImage.path;
  }

  Future<void> addFamilyMember({
    required String name,
    required DateTime dob,
    required String relationship,
    String? gender,
    String? photoPath,
  }) async {
    final newMember = FamilyMember(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      name: name,
      dob: dob,
      gender: gender,
      relationship: relationship,
      photoPath: photoPath,
    );

    final updated = [...state, newMember];
    state = updated;
    await _repository.saveAll(updated);
  }

  Future<void> updateFamilyMember(FamilyMember updatedMember) async {
    final updated = state
        .map((m) => m.id == updatedMember.id ? updatedMember : m)
        .toList();
    state = updated;
    await _repository.saveAll(updated);
  }

  Future<void> deleteFamilyMember(int id) async {
    final member = state.firstWhere((m) => m.id == id);
    final updated = state.where((m) => m.id != id).toList();
    state = updated;
    await _repository.saveAll(updated);

    if (member.photoPath != null) {
      final file = File(member.photoPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
