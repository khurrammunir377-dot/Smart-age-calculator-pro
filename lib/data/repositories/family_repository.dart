import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_age_calculator_pro/domain/entities/family_member.dart';

class FamilyRepository {
  static const _storageKey = 'family_members';

  Future<List<FamilyMember>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<FamilyMember> members) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(members.map((m) => m.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
